import { functionType } from "./annotations.mts";
import type { FunctionItem, Item, Side } from "./extract.mts";

export interface SourceFile {
  /** Path relative to ug-core, such as `core/shared/events.lua`. */
  path: string;
  items: Item[];
}

export interface Rendered {
  files: Map<string, string>;
  functions: number;
  overloads: number;
}

const HEADER = `--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta
`;

const SIDE_LABEL: Record<Side, string> = { shared: "Shared", server: "Server", client: "Client" };

/** The part of a function that changes how callers use it. */
function signature(item: FunctionItem): string {
  const annotations = item.doc.filter((line) => /^---@(param|return|generic|overload)\b/.test(line));

  return `${item.params}\n${annotations.join("\n").replace(/\s+/g, " ")}`;
}

/** Inserts description lines before the first annotation of a doc block. */
function describe(doc: readonly string[], lines: readonly string[]): string[] {
  const first = doc.findIndex((line) => line.startsWith("---@"));
  const at = first === -1 ? doc.length : first;

  return [...doc.slice(0, at), ...lines, ...doc.slice(at)];
}

function name(item: FunctionItem): string {
  return item.target.replace(/^.*[.:]/, "");
}

/**
 * Renders extracted files. A function that ug-core defines on several sides with different
 * signatures, such as `Callback.Register`, keeps the first definition and gets the others as
 * `---@overload`. Files are read shared, then server, then client, so the server form leads.
 */
export function render(sources: readonly SourceFile[], banner: string): Rendered {
  const groups = new Map<string, FunctionItem[]>();

  for (const source of sources) {
    for (const item of source.items) {
      if (item.kind !== "function") continue;

      const group = groups.get(item.key) ?? [];

      group.push(item);
      groups.set(item.key, group);
    }
  }

  const docs = new Map<FunctionItem, string[]>();
  const dropped = new Set<FunctionItem>();
  let overloads = 0;

  for (const group of groups.values()) {
    const [first, ...others] = group as [FunctionItem, ...FunctionItem[]];
    const sides = new Set(group.map((item) => item.side));
    const extra: string[] = [];
    const overloadLines: string[] = [];

    for (const other of others) {
      if (signature(other) === signature(first)) {
        dropped.add(other);
        continue;
      }

      const type = functionType(other.params, other.doc);

      // Generics cannot be expressed as an overload: both definitions stay.
      if (type === null) continue;

      dropped.add(other);
      overloadLines.push(`---@overload ${type}`);
      extra.push(`---${SIDE_LABEL[other.side]}: \`${name(other)}(${other.params})\`.`);
      overloads++;
    }

    if (!sides.has("shared") && sides.size === 1) {
      extra.push(`---${SIDE_LABEL[first.side]} only.`);
    }

    // A `---` line separates the notes from an existing description in the hover.
    const described = first.doc.some((line) => !line.startsWith("---@"));
    const doc = extra.length > 0 ? describe(first.doc, described ? ["---", ...extra] : extra) : [...first.doc];

    docs.set(first, [...doc, ...overloadLines]);

    for (const other of others) {
      if (!dropped.has(other)) docs.set(other, other.doc);
    }
  }

  const files = new Map<string, string>();
  let functions = 0;

  for (const source of sources) {
    const blocks: string[] = [];

    for (const item of source.items) {
      if (item.kind === "raw") {
        blocks.push(item.text);
        continue;
      }

      const doc = docs.get(item);

      if (!doc) continue;

      blocks.push([...doc, `function ${item.target}(${item.params}) end`].join("\n"));
      functions++;
    }

    if (blocks.length === 0) continue;

    files.set(source.path, `${HEADER}\n-- ${banner} Source: ${source.path}.\n\n${blocks.join("\n\n")}\n`);
  }

  return { files, functions, overloads };
}
