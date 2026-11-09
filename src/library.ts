import path from "node:path";

/** `ugcore.typings`: on except in ug-core's own source, always on, or off. */
export type Mode = "auto" | "on" | "off";

export interface Paths {
  /** The library this version installed. */
  current: string;
  /** The folder the extension owns. Any entry inside it that is not `current` is stale. */
  storage: string;
  home: string;
  windows: boolean;
}

/** Comparable form of a library entry: `~` expanded, resolved, case-folded on Windows. */
export function normalize(entry: string, paths: Pick<Paths, "home" | "windows">): string {
  const expanded = entry === "~" || /^~[\\/]/.test(entry) ? paths.home + entry.slice(1) : entry;
  const resolved = paths.windows ? path.win32.resolve(expanded) : path.posix.resolve(expanded);

  return paths.windows ? resolved.toLowerCase() : resolved;
}

function isOurs(entry: string, paths: Paths): boolean {
  const storage = normalize(paths.storage, paths);
  const separator = paths.windows ? "\\" : "/";
  const normalized = normalize(entry, paths);

  return normalized === storage || normalized.startsWith(storage + separator);
}

/**
 * The library list with our entry present or absent, and stale entries of ours removed.
 * Every other entry, such as CfxLua's natives, keeps its place. Returns null when nothing changes.
 */
export function updateList(list: readonly string[] | undefined, include: boolean, paths: Paths): string[] | null {
  const before = list ?? [];
  const after = before.filter((entry) => !isOurs(entry, paths));

  if (include) after.push(paths.current);

  const changed = after.length !== before.length || after.some((entry, index) => entry !== before[index]);

  return changed ? after : null;
}

export interface Plan {
  /** Our entry in the user (or .code-workspace) list. */
  user: boolean;
  /** Our entry in this folder's own list, when it has one or MUST get one to hide ours. */
  workspace: boolean;
  /** The folder MUST get its own list without our entry, because its source declares UgCore itself. */
  hideInWorkspace: boolean;
}

/**
 * ug-core's own source declares every UgCore type. With the library on top, LuaLS sees each
 * declaration twice and type checking weakens, so `auto` hides the library in that workspace only.
 */
export function plan(mode: Mode, coreWorkspace: boolean): Plan {
  if (mode === "off") return { user: false, workspace: false, hideInWorkspace: false };
  if (mode === "auto" && coreWorkspace) return { user: true, workspace: false, hideInWorkspace: true };

  return { user: true, workspace: true, hideInWorkspace: false };
}

/** True for ug-core's `core/shared/init.lua`, the file that declares `UgCore.Internal`. */
export function isCoreInit(content: string): boolean {
  return /^UgCore\.Internal\s*=\s*\{\s*\}/m.test(content);
}
