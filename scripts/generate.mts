/**
 * Generates the LuaLS library in `library/` from ug-core's source.
 *
 *   npm run generate -- --core <path to ug-core>
 *
 * Without `--core`, it reads UGCORE_PATH, then `../Base/resources/[ug]/ug-core`.
 * The output is deterministic: CI regenerates it from a pinned ug-core and fails on any diff.
 */

import { createHash } from "node:crypto";
import { existsSync } from "node:fs";
import { mkdir, readdir, readFile, rm, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { extract, type Side } from "./lib/extract.mts";
import { render, type SourceFile } from "./lib/render.mts";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const OUTPUT = path.join(ROOT, "library");
const SIDES: Side[] = ["shared", "server", "client"];

function corePath(): string {
  const flag = process.argv.indexOf("--core");
  const value = flag !== -1 ? process.argv[flag + 1] : process.env.UGCORE_PATH;

  return path.resolve(value ?? path.join(ROOT, "..", "Base", "resources", "[ug]", "ug-core"));
}

/** Lua files in a folder and its subfolders, in the same order on every OS. */
async function luaFiles(folder: string): Promise<string[]> {
  if (!existsSync(folder)) return [];

  const entries = await readdir(folder, { recursive: true, withFileTypes: true });
  const posix = (file: string): string => file.split(path.sep).join("/");

  // `\` and `/` sort differently against digits and capitals, so sort on one form.
  return entries
    .filter((entry) => entry.isFile() && entry.name.endsWith(".lua"))
    .map((entry) => path.join(entry.parentPath, entry.name))
    .sort((a, b) => (posix(a) < posix(b) ? -1 : posix(a) > posix(b) ? 1 : 0));
}

async function main(): Promise<void> {
  const core = corePath();
  const manifest = await readFile(path.join(core, "fxmanifest.lua"), "utf8").catch(() => {
    throw new Error(`No fxmanifest.lua in ${core}. Pass --core <path to ug-core>.`);
  });
  const version = /^version\s+'([^']+)'/m.exec(manifest)?.[1] ?? "0.0.0";
  const modules = [...manifest.matchAll(/^ug_module\s+'([^']+)'/gm)].map((match) => match[1] as string);

  // Shared first, then server, then client: the first definition of a function leads its overloads.
  const sources: SourceFile[] = [];

  for (const side of SIDES) {
    const folders = [path.join(core, "core", side), ...modules.map((name) => path.join(core, "modules", name, side))];

    for (const folder of folders) {
      for (const file of await luaFiles(folder)) {
        const relative = path.relative(core, file).split(path.sep).join("/");

        sources.push({ path: relative, items: extract(await readFile(file, "utf8"), relative, side) });
      }
    }
  }

  const banner = `Generated from ug-core ${version} by ugcore-vscode. Do not edit: run \`npm run generate\`.`;
  const rendered = render(sources, banner);

  await rm(path.join(OUTPUT, "ug-core"), { recursive: true, force: true });

  const written = new Map(rendered.files);

  // types/ holds ---@meta files already: they are copied as they are.
  for (const file of await luaFiles(path.join(core, "types"))) {
    written.set(path.relative(core, file).split(path.sep).join("/"), (await readFile(file, "utf8")).replace(/\r\n?/g, "\n"));
  }

  const hash = createHash("sha256");

  // Code-unit order: localeCompare depends on the machine's locale.
  for (const [relative, content] of [...written].sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))) {
    const target = path.join(OUTPUT, "ug-core", relative);

    await mkdir(path.dirname(target), { recursive: true });
    await writeFile(target, content);
    hash.update(relative).update("\0").update(content);
  }

  const meta = { ugCore: version, modules, hash: hash.digest("hex").slice(0, 16) };

  await writeFile(path.join(OUTPUT, "meta.json"), `${JSON.stringify(meta, null, 2)}\n`);

  console.log(
    `ug-core ${version}: ${written.size} files, ${rendered.functions} functions, ${rendered.overloads} overloads, ${modules.length} modules.`,
  );
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
