/**
 * Extracts the public declarations of one ug-core source file: doc blocks, namespace tables,
 * enums and function signatures. Bodies and everything under `UgCore.Internal` are dropped.
 *
 * ug-core defines its API on locals that alias `UgCore.*`:
 *
 *   ---@class UgCore.Events
 *   local Events = {}
 *   UgCore.Events = Events
 *   function Events.On(name, handler) ... end
 *
 * so the extractor tracks those aliases per file and emits every function under its public path.
 */

export type Side = "shared" | "server" | "client";

export interface FunctionItem {
  kind: "function";
  /** Identity across files: the public path, or the class name for methods of local classes. */
  key: string;
  /** What the generated file declares, such as `UgCore.Events.On` or `UgPlayer:IsOnline`. */
  target: string;
  params: string;
  doc: string[];
  side: Side;
  file: string;
}

export interface RawItem {
  kind: "raw";
  text: string;
}

export type Item = FunctionItem | RawItem;

type Alias = { kind: "path"; path: string } | { kind: "local"; className: string } | { kind: "private" };

const IDENT = "[A-Za-z_][A-Za-z0-9_]*";
const PATH = new RegExp(`^${IDENT}(?:\\.${IDENT})*$`);
const ROOT = "UgCore";
const PRIVATE = "UgCore.Internal";

export function isPrivatePath(path: string): boolean {
  return path === PRIVATE || path.startsWith(`${PRIVATE}.`);
}

/** The class a doc block declares, if any. */
function classOf(block: readonly string[]): string | null {
  for (const line of block) {
    const match = /^---@class\s+(?:\([^)]*\)\s*)?([A-Za-z_][\w.]*)/.exec(line);

    if (match) return match[1] as string;
  }

  return null;
}

/** A block that only declares types: classes, aliases or enums without code after it. */
function declaresTypes(block: readonly string[]): boolean {
  const declared = classOf(block);

  if (declared && isPrivatePath(declared)) return false;

  return block.some((line) => /^---@(class|alias|enum)\s/.test(line));
}

/** Net `{` minus `}` on a line, outside strings and comments. */
function braceBalance(line: string): number {
  let balance = 0;
  let quote: string | null = null;

  for (let index = 0; index < line.length; index++) {
    const char = line[index];

    if (quote) {
      if (char === "\\") index++;
      else if (char === quote) quote = null;
      continue;
    }

    if (char === "'" || char === '"') quote = char;
    else if (char === "-" && line[index + 1] === "-") break;
    else if (char === "{") balance++;
    else if (char === "}") balance--;
  }

  return balance;
}

/** Removes a trailing `-- comment` outside strings. */
function stripComment(text: string): string {
  let quote: string | null = null;

  for (let index = 0; index < text.length; index++) {
    const char = text[index];

    if (quote) {
      if (char === "\\") index++;
      else if (char === quote) quote = null;
      continue;
    }

    if (char === "'" || char === '"') quote = char;
    else if (char === "-" && text[index + 1] === "-") return text.slice(0, index).trimEnd();
  }

  return text.trimEnd();
}

/** Skips the license header, `--[[ ... ]] --`. */
function headerEnd(lines: readonly string[]): number {
  if (!lines[0]?.startsWith("--[[")) return 0;

  const end = lines.findIndex((line) => line.includes("]]"));

  return end === -1 ? 0 : end + 1;
}

export function extract(source: string, file: string, side: Side): Item[] {
  const lines = source.replace(/\r\n?/g, "\n").split("\n");
  const aliases = new Map<string, Alias>();
  // `local X = {}` without a class, which a later `UgCore.Name = X` makes public.
  const plainTables = new Set<string>();
  const items: Item[] = [];

  const raw = (text: string): void => {
    items.push({ kind: "raw", text });
  };

  /** Resolves `Owner` or `Owner.Field` through the file's aliases. */
  const resolve = (path: string): Alias | null => {
    const [root, ...rest] = path.split(".");
    const tail = rest.length > 0 ? `.${rest.join(".")}` : "";

    if (root === ROOT) return isPrivatePath(path) ? { kind: "private" } : { kind: "path", path };

    const alias = aliases.get(root as string);

    if (!alias || alias.kind === "private") return alias ?? null;
    if (alias.kind === "local") return tail === "" ? alias : null;

    const full = alias.path + tail;

    return isPrivatePath(full) ? { kind: "private" } : { kind: "path", path: full };
  };

  /** Index after a statement whose table literal MAY span lines. */
  const statementEnd = (index: number): number => {
    let balance = braceBalance(lines[index] as string);
    let next = index + 1;

    while (balance > 0 && next < lines.length) {
      balance += braceBalance(lines[next] as string);
      next++;
    }

    return next;
  };

  /** Rewrites aliases inside copied code, so `[Violations.X]` reads `[UgCore.Enums.Violations.X]`. */
  const rewrite = (text: string): string => {
    let result = text;

    for (const [name, alias] of aliases) {
      if (alias.kind === "path") {
        result = result.replace(new RegExp(`(?<![\\w.])${name}\\.`, "g"), `${alias.path}.`);
      }
    }

    return result;
  };

  /** Reads a parameter list that starts in `rest` and MAY continue on the next lines. */
  const readParams = (rest: string, index: number): [params: string, end: number] => {
    let text = rest;
    let end = index;

    while (!text.includes(")") && end + 1 < lines.length) {
      end++;
      text += ` ${(lines[end] as string).trim()}`;
    }

    return [text.slice(0, text.indexOf(")")).replace(/\s+/g, " ").trim(), end + 1];
  };

  const addFunction = (owner: string, separator: string, name: string, params: string, doc: string[]): void => {
    const resolved = resolve(owner);

    if (!resolved || resolved.kind === "private") return;

    if (resolved.kind === "local") {
      items.push({
        kind: "function",
        key: `${resolved.className}${separator}${name}`,
        target: `${owner}${separator}${name}`,
        params,
        doc,
        side,
        file,
      });
      return;
    }

    const target = `${resolved.path}${separator}${name}`;

    items.push({ kind: "function", key: target, target, params, doc, side, file });
  };

  /** Handles one top-level statement with its doc block. Returns the next line index. */
  const statement = (index: number, block: string[]): number => {
    const line = lines[index] as string;
    let match: RegExpExecArray | null;

    if (line.startsWith("local function")) return index + 1;

    if ((match = /^function\s+([A-Za-z_][\w.]*)([.:])([A-Za-z_]\w*)\s*\((.*)$/.exec(line))) {
      const [params, end] = readParams(match[4] as string, index);

      addFunction(match[1] as string, match[2] as string, match[3] as string, params, block);
      return end;
    }

    if ((match = /^local\s+([A-Za-z_]\w*)\s*=\s*(.*)$/.exec(line))) {
      const name = match[1] as string;
      const value = stripComment(match[2] as string);
      const declared = classOf(block);

      if (PATH.test(value)) {
        const target = resolve(value);

        if (target) aliases.set(name, target);
        return index + 1;
      }

      if (declared) {
        if (isPrivatePath(declared)) {
          aliases.set(name, { kind: "private" });
        } else if (declared.startsWith(`${ROOT}.`)) {
          aliases.set(name, { kind: "path", path: declared });
          raw([...block, `${declared} = {}`].join("\n"));
        } else {
          aliases.set(name, { kind: "local", className: declared });
          raw([...block, `local ${name} = {}`].join("\n"));
        }
      } else if (value === "{}") {
        plainTables.add(name);
      }

      return statementEnd(index);
    }

    if ((match = /^([A-Za-z_][\w.]*)\s*=\s*(.*)$/.exec(line))) {
      const target = match[1] as string;
      const value = stripComment(match[2] as string);

      if (target === ROOT) {
        raw([...block, `${ROOT} = {}`].join("\n"));
        return statementEnd(index);
      }

      if (!target.includes(".")) return statementEnd(index);

      const resolved = resolve(target);

      if (!resolved || resolved.kind !== "path") return statementEnd(index);

      const fn = /^function\s*\((.*)$/.exec(value);

      if (fn) {
        const dot = target.lastIndexOf(".");
        const [params, end] = readParams(fn[1] as string, index);

        addFunction(target.slice(0, dot), ".", target.slice(dot + 1), params, block);
        return end;
      }

      if (PATH.test(value) && !value.includes(".")) {
        if (plainTables.has(value)) {
          aliases.set(value, { kind: "path", path: resolved.path });
          raw([...block, `${resolved.path} = {}`].join("\n"));
        }

        return index + 1;
      }

      if (value.startsWith("{")) {
        const end = statementEnd(index);
        const literal = [value, ...lines.slice(index + 1, end)].join("\n");

        raw([...block, `${resolved.path} = ${rewrite(literal)}`].join("\n"));
        return end;
      }

      if (classOf(block)) raw([...block, `${resolved.path} = {}`].join("\n"));
      else if (block.some((doc) => doc.startsWith("---@type"))) raw([...block, `${resolved.path} = nil`].join("\n"));

      return statementEnd(index);
    }

    return index + 1;
  };

  let index = headerEnd(lines);

  while (index < lines.length) {
    const line = lines[index] as string;

    if (line.startsWith("---")) {
      const start = index;

      while (index < lines.length && (lines[index] as string).startsWith("---")) index++;

      const block = lines.slice(start, index);
      const next = lines[index];

      // A block followed by a blank line, a comment or indented code belongs to no statement.
      if (next === undefined || next.trim() === "" || next.startsWith("--") || /^\s/.test(next)) {
        if (declaresTypes(block)) raw(block.join("\n"));
        continue;
      }

      index = statement(index, block);
      continue;
    }

    if (line !== "" && !/^\s/.test(line) && !line.startsWith("--")) {
      index = statement(index, []);
      continue;
    }

    index++;
  }

  return items;
}
