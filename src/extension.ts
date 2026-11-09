import { existsSync } from "node:fs";
import { cp, mkdir, readFile, rm } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import * as vscode from "vscode";
import { isCoreInit, plan, updateList, type Mode, type Paths } from "./library";

const LIBRARY_KEY = "workspace.library";
const NOTICE_KEY = "ugcore.coreNoticeShown";

let log: vscode.LogOutputChannel;
let queue: Promise<void> = Promise.resolve();

/**
 * Copies the bundled library to global storage when it changed. Storage keeps one stable path across
 * updates, so the entry in Lua.workspace.library never points at an old extension folder.
 */
async function installLibrary(context: vscode.ExtensionContext): Promise<string> {
  const source = path.join(context.extensionPath, "library");
  const target = path.join(context.globalStorageUri.fsPath, "library");
  const sourceMeta = await readFile(path.join(source, "meta.json"), "utf8");
  const targetMeta = existsSync(path.join(target, "meta.json")) ? await readFile(path.join(target, "meta.json"), "utf8") : "";

  if (sourceMeta !== targetMeta) {
    await rm(target, { recursive: true, force: true });
    await mkdir(path.dirname(target), { recursive: true });
    await cp(source, target, { recursive: true });
    log.info(`Installed the UgCore library in ${target}.`);
  }

  return target;
}

/** True when the open folders hold ug-core's own source. */
async function containsCoreSource(): Promise<boolean> {
  const files = await vscode.workspace.findFiles("**/core/shared/init.lua", "**/node_modules/**", 20);

  for (const file of files) {
    const content = Buffer.from(await vscode.workspace.fs.readFile(file)).toString("utf8");

    if (isCoreInit(content)) return true;
  }

  return false;
}

async function apply(context: vscode.ExtensionContext): Promise<void> {
  const mode = vscode.workspace.getConfiguration("ugcore").get<Mode>("typings", "auto");
  const current = await installLibrary(context);
  const coreWorkspace = await containsCoreSource();
  const wanted = plan(mode, coreWorkspace);
  const lua = vscode.workspace.getConfiguration("Lua");
  const info = lua.inspect<string[]>(LIBRARY_KEY);
  const paths: Paths = {
    current,
    storage: context.globalStorageUri.fsPath,
    home: os.homedir(),
    windows: process.platform === "win32",
  };
  const multiRoot = vscode.workspace.workspaceFile !== undefined;
  const hasFolder = (vscode.workspace.workspaceFolders?.length ?? 0) > 0;

  // A .code-workspace file holds the list for its folders, like the CfxLua extension does.
  let userList = info?.globalValue;

  if (!multiRoot) {
    const next = updateList(userList, wanted.user, paths);

    if (next) {
      await lua.update(LIBRARY_KEY, next, vscode.ConfigurationTarget.Global);
      log.info(`User Lua.workspace.library ${wanted.user ? "now includes" : "no longer includes"} the UgCore library.`);
      userList = next;
    }
  }

  if (!hasFolder) return;

  const workspaceValue = info?.workspaceValue;
  let include: boolean | null = null;

  if (multiRoot) include = wanted.user && !wanted.hideInWorkspace;
  else if (wanted.hideInWorkspace) include = false;
  else if (workspaceValue !== undefined) include = wanted.workspace;

  if (include === null) return;

  const base = workspaceValue ?? userList ?? [];
  const next = updateList(base, include, paths);
  // Without its own list, a single folder inherits the user list: it only needs one to hide our entry.
  const needed = workspaceValue !== undefined || multiRoot || updateList(userList, false, paths) !== null;

  if (next && needed) {
    await lua.update(LIBRARY_KEY, next, vscode.ConfigurationTarget.Workspace);
    log.info(`Workspace Lua.workspace.library ${include ? "now includes" : "no longer includes"} the UgCore library.`);
  }

  if (wanted.hideInWorkspace && !context.workspaceState.get<boolean>(NOTICE_KEY)) {
    await context.workspaceState.update(NOTICE_KEY, true);
    void vscode.window.showInformationMessage(
      "UgCore: this workspace contains ug-core's source, which declares its own types. The UgCore library is off here.",
    );
  }
}

/** Runs one apply at a time, so settings writes never interleave. */
function schedule(context: vscode.ExtensionContext): Promise<void> {
  queue = queue
    .then(() => apply(context))
    .catch((error: unknown) => {
      log.error(error instanceof Error ? error : String(error));
      void vscode.window.showErrorMessage(`UgCore: could not apply typings. ${String(error)}`);
    });

  return queue;
}

export function activate(context: vscode.ExtensionContext): Promise<void> {
  log = vscode.window.createOutputChannel("UgCore", { log: true });

  context.subscriptions.push(
    log,
    vscode.commands.registerCommand("ugcore.apply", () => schedule(context)),
    vscode.commands.registerCommand("ugcore.info", async () => {
      const meta = JSON.parse(await readFile(path.join(context.extensionPath, "library", "meta.json"), "utf8")) as {
        ugCore: string;
        modules: string[];
      };

      void vscode.window.showInformationMessage(
        `UgCore types from ug-core ${meta.ugCore}, modules: ${meta.modules.join(", ")}.`,
      );
    }),
    vscode.workspace.onDidChangeConfiguration((event) => {
      if (event.affectsConfiguration("ugcore.typings")) void schedule(context);
    }),
    vscode.workspace.onDidChangeWorkspaceFolders(() => void schedule(context)),
  );

  return schedule(context);
}

export function deactivate(): void {}
