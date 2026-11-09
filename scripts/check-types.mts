/**
 * Checks the generated library with lua-language-server, the same way an owner's editor does.
 *
 * - tests/luals/positive/*.lua and every snippet in snippets/lua.json MUST have no problems.
 * - tests/luals/negative/*.lua lines ending in `--! <code>` MUST raise that diagnostic, and nothing else may.
 *
 * Needs lua-language-server (LUALS, or the sumneko.lua VS Code extension) and the FiveM natives
 * (FIVEM_LLS_ADDON, a checkout of overextended/fivem-lls-addon, or the CfxLua extension's storage).
 */

import { execFile } from "node:child_process";
import { existsSync, readdirSync } from "node:fs";
import { cp, mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";
import { toLua, type Snippet } from "./lib/snippets.mts";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const LUALS_VERSION = "3.19.1";

// The severities ug-core's own CI uses, so consumers get the same strictness.
const SETTINGS = {
  "runtime.version": "Lua 5.4",
  "runtime.nonstandardSymbol": ["/**/", "`", "+=", "-=", "*=", "/=", "<<=", ">>=", "&=", "|=", "^="],
  "workspace.checkThirdParty": false,
  "type.weakUnionCheck": false,
  "type.weakNilCheck": false,
  "diagnostics.severity": {
    "undefined-global": "Error",
    "undefined-field": "Error",
    "param-type-mismatch": "Error",
    "assign-type-mismatch": "Error",
    "return-type-mismatch": "Error",
    "missing-parameter": "Error",
    "missing-return": "Error",
    "missing-fields": "Error",
  },
};

interface Diagnostic {
  code: string;
  message: string;
  range: { start: { line: number } };
}

function findLuals(): string {
  if (process.env.LUALS) return process.env.LUALS;

  const extensions = path.join(os.homedir(), ".vscode", "extensions");
  const binary = process.platform === "win32" ? "lua-language-server.exe" : "lua-language-server";
  const candidates = existsSync(extensions)
    ? readdirSync(extensions)
        .filter((name) => name.startsWith(`sumneko.lua-${LUALS_VERSION}`))
        .map((name) => path.join(extensions, name, "server", "bin", binary))
        .filter((file) => existsSync(file))
    : [];

  if (!candidates[0]) throw new Error(`lua-language-server ${LUALS_VERSION} not found. Set LUALS to its binary.`);

  return candidates[0];
}

function findNatives(): string {
  if (process.env.FIVEM_LLS_ADDON) return process.env.FIVEM_LLS_ADDON;

  const user =
    process.platform === "win32"
      ? path.join(process.env.APPDATA ?? "", "Code", "User")
      : process.platform === "darwin"
        ? path.join(os.homedir(), "Library", "Application Support", "Code", "User")
        : path.join(os.homedir(), ".config", "Code", "User");
  const storage = path.join(user, "globalStorage", "overextended.cfxlua-vscode");

  if (!existsSync(path.join(storage, "plugin.lua"))) {
    throw new Error("FiveM natives not found. Set FIVEM_LLS_ADDON to a checkout of overextended/fivem-lls-addon.");
  }

  return storage;
}

/** Diagnostics per file path, from LuaLS's check output. */
async function readDiagnostics(file: string): Promise<Map<string, Diagnostic[]>> {
  const result = new Map<string, Diagnostic[]>();

  if (!existsSync(file)) return result;

  const parsed = JSON.parse(await readFile(file, "utf8")) as Record<string, Diagnostic[]> | [];

  for (const [uri, diagnostics] of Object.entries(parsed)) {
    result.set(path.resolve(fileURLToPath(uri)).toLowerCase(), diagnostics);
  }

  return result;
}

async function main(): Promise<void> {
  const luals = findLuals();
  const natives = findNatives();
  const work = await mkdtemp(path.join(os.tmpdir(), "ugcore-vscode-"));
  const positive = path.join(work, "positive");
  const negative = path.join(work, "negative");

  try {
    await cp(path.join(ROOT, "tests", "luals", "positive"), positive, { recursive: true });
    await cp(path.join(ROOT, "tests", "luals", "negative"), negative, { recursive: true });

    const snippets = JSON.parse(await readFile(path.join(ROOT, "snippets", "lua.json"), "utf8")) as Record<string, Snippet>;

    await mkdir(path.join(positive, "snippets"));

    // `source` stands for the handler argument that server snippets use.
    for (const snippet of Object.values(snippets)) {
      const body = toLua(snippet).replace(/^(?=.)/gm, "    ");

      await writeFile(
        path.join(positive, "snippets", `${snippet.prefix}.lua`),
        `---@param source integer\nlocal function snippet(source)\n${body}\nend\n\nreturn snippet\n`,
      );
    }

    const config = {
      ...SETTINGS,
      "workspace.library": [
        path.join(ROOT, "library"),
        path.join(natives, "library", "runtime"),
        path.join(natives, "library", "natives", "CFX-NATIVE"),
        path.join(natives, "library", "natives", "GTAV"),
      ],
      "runtime.plugin": path.join(natives, "plugin.lua"),
    };
    const configPath = path.join(work, "luarc.json");
    const output = path.join(work, "check.json");

    await writeFile(configPath, JSON.stringify(config, null, 2));
    await promisify(execFile)(
      luals,
      ["--check", work, "--checklevel=Information", `--configpath=${configPath}`, `--check_out_path=${output}`],
      { maxBuffer: 64 * 1024 * 1024 },
    ).catch((error: { stdout?: string }) => {
      // LuaLS MAY exit non-zero when it finds problems. The output file decides.
      if (!existsSync(output) && !error.stdout?.includes("no problems")) throw error;
    });

    const diagnostics = await readDiagnostics(output);
    const failures: string[] = [];
    let expected = 0;

    for (const [file, list] of diagnostics) {
      if (file.startsWith(positive.toLowerCase())) {
        for (const item of list) {
          failures.push(`${path.relative(work, file)}:${item.range.start.line + 1} unexpected ${item.code}: ${item.message}`);
        }
      }
    }

    for (const name of readdirSync(negative).filter((file) => file.endsWith(".lua"))) {
      const file = path.join(negative, name);
      const lines = (await readFile(file, "utf8")).split(/\r?\n/);
      const found = diagnostics.get(path.resolve(file).toLowerCase()) ?? [];

      lines.forEach((line, index) => {
        const want = /--!\s*([\w-]+)\s*$/.exec(line)?.[1];
        const got = found.filter((item) => item.range.start.line === index);

        if (want) {
          expected++;

          if (!got.some((item) => item.code === want)) {
            failures.push(`negative/${name}:${index + 1} expected ${want}, got ${got.map((item) => item.code).join(", ") || "nothing"}`);
          }
        }

        for (const item of got.filter((item) => item.code !== want)) {
          failures.push(`negative/${name}:${index + 1} unexpected ${item.code}: ${item.message}`);
        }
      });
    }

    if (failures.length > 0) {
      console.error(failures.join("\n"));
      console.error(`${failures.length} problem(s).`);
      process.exit(1);
    }

    console.log(`Types check: ${Object.keys(snippets).length} snippets and the positive fixtures are clean, ${expected} expected errors raised.`);
  } finally {
    await rm(work, { recursive: true, force: true });
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
