import { readFileSync } from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { expand, type Snippet } from "../scripts/lib/snippets.mts";

const ROOT = path.resolve(import.meta.dirname, "..");

function load(file: string): Snippet[] {
  return Object.values(JSON.parse(readFileSync(path.join(ROOT, "snippets", file), "utf8")) as Record<string, Snippet>);
}

const all = [...load("lua.json"), ...load("manifest.json")];

describe("snippets", () => {
  it("have unique ug prefixes and a description", () => {
    const prefixes = all.map((snippet) => snippet.prefix);

    expect(new Set(prefixes).size).toBe(prefixes.length);

    for (const snippet of all) {
      expect(snippet.prefix, snippet.prefix).toMatch(/^ug[a-z]+$/);
      expect(snippet.description.length, snippet.prefix).toBeGreaterThan(10);
    }
  });

  it("use enums, never raw event, hook or error strings", () => {
    for (const snippet of load("lua.json")) {
      const body = snippet.body.join("\n");

      expect(body, snippet.prefix).not.toMatch(/'ug-core:/);
      expect(body, snippet.prefix).not.toMatch(/'(invalid_args|not_found|not_loaded|no_permission|internal_error)'/);
      expect(body, snippet.prefix).not.toMatch(/RegisterNetEvent|TriggerServerEvent|TriggerClientEvent/);
    }
  });

  it("expand placeholders, choices and nested defaults", () => {
    expect(expand("a(${1:x}, ${2|one,two|}, $3, ${4}, ${5:f(${6:y})})$0")).toBe("a(x, one, , , f(y))");
    expect(expand("cost \\$5")).toBe("cost $5");
    expect(() => expand("$TM_FILENAME")).toThrow(/not supported/);
  });
});
