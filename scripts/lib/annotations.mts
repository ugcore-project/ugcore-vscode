/**
 * Reads LuaLS annotation lines (`---@param`, `---@return`). Types MAY contain spaces, such as
 * `fun(source: integer, ...: any): any`, so they are read with bracket depth, not split on whitespace.
 */

const OPEN = new Set(["(", "[", "{", "<"]);
const CLOSE = new Set([")", "]", "}", ">"]);
// Inside a type, whitespace after these characters (or before `|` and `,`) continues the type.
const JOINERS = new Set([":", "|", ","]);

/** Splits `text` into the leading LuaLS type and the rest. */
export function readType(text: string): [type: string, rest: string] {
  const source = text.trimStart();
  let depth = 0;
  let index = 0;
  let quote: string | null = null;

  while (index < source.length) {
    const char = source[index] as string;

    if (quote) {
      if (char === quote) quote = null;
      index++;
      continue;
    }

    if (char === "'" || char === '"' || char === "`") {
      quote = char;
    } else if (OPEN.has(char)) {
      depth++;
    } else if (CLOSE.has(char) && !(char === ">" && source[index - 1] === "-")) {
      depth = Math.max(0, depth - 1);
    } else if (/\s/.test(char) && depth === 0) {
      const before = source.slice(0, index).trimEnd();
      const after = source.slice(index).trimStart();
      const last = before[before.length - 1] ?? "";

      if (!JOINERS.has(last) && !after.startsWith("|") && !after.startsWith(",")) {
        break;
      }
    }

    index++;
  }

  return [source.slice(0, index).trim(), source.slice(index).trim()];
}

export interface Param {
  name: string;
  type: string;
  optional: boolean;
}

/** Parses `---@param name[?] type description`. */
export function parseParam(line: string): Param | null {
  const match = /^---@param\s+(\.\.\.|[A-Za-z_][A-Za-z0-9_]*)(\?)?\s+(.*)$/.exec(line);

  if (!match) return null;

  const [type] = readType(match[3] as string);

  return { name: match[1] as string, type, optional: match[2] === "?" };
}

/** Parses `---@return type [name] [description]` and returns the type. */
export function parseReturn(line: string): string | null {
  const match = /^---@return\s+(.*)$/.exec(line);

  if (!match) return null;

  const [type] = readType(match[1] as string);

  return type === "" ? null : type;
}

/**
 * A `fun(...)` type for `---@overload`, from a function's parameter list and doc block.
 * Returns null when the doc declares generics, which an overload cannot reference.
 */
export function functionType(params: string, doc: readonly string[]): string | null {
  if (doc.some((line) => line.startsWith("---@generic"))) return null;

  const declared = new Map<string, Param>();

  for (const line of doc) {
    const param = parseParam(line);

    if (param) declared.set(param.name, param);
  }

  const parts = params
    .split(",")
    .map((name) => name.trim())
    .filter((name) => name !== "")
    .map((name) => {
      const param = declared.get(name);

      return `${name}${param?.optional ? "?" : ""}: ${param?.type ?? "any"}`;
    });

  const returns = doc.map(parseReturn).filter((type): type is string => type !== null);

  return `fun(${parts.join(", ")})${returns.length > 0 ? `: ${returns.join(", ")}` : ""}`;
}
