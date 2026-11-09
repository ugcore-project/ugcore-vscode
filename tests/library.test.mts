import { describe, expect, it } from "vitest";
import { isCoreInit, normalize, plan, updateList, type Paths } from "../src/library.ts";

const WINDOWS: Paths = {
  current: "C:\\Users\\dev\\AppData\\Roaming\\Code\\User\\globalStorage\\ugcore-project.ugcore-vscode\\library",
  storage: "C:\\Users\\dev\\AppData\\Roaming\\Code\\User\\globalStorage\\ugcore-project.ugcore-vscode",
  home: "C:\\Users\\dev",
  windows: true,
};

const CFX = [
  "~\\AppData\\Roaming\\Code\\User\\globalStorage\\overextended.cfxlua-vscode\\library\\runtime",
  "~\\AppData\\Roaming\\Code\\User\\globalStorage\\overextended.cfxlua-vscode\\library\\natives\\GTAV",
];

describe("updateList", () => {
  it("appends the library and keeps every other entry in place", () => {
    expect(updateList(CFX, true, WINDOWS)).toEqual([...CFX, WINDOWS.current]);
  });

  it("returns null when the list already matches", () => {
    expect(updateList([...CFX, WINDOWS.current], true, WINDOWS)).toBeNull();
    expect(updateList(CFX, false, WINDOWS)).toBeNull();
    expect(updateList(undefined, false, WINDOWS)).toBeNull();
  });

  it("removes the library, also written with ~ or another case", () => {
    const tilde = "~\\AppData\\Roaming\\Code\\User\\globalStorage\\UGCORE-PROJECT.ugcore-vscode\\library";

    expect(updateList([...CFX, tilde], false, WINDOWS)).toEqual(CFX);
  });

  it("replaces stale entries of an older layout inside its own storage", () => {
    const stale = `${WINDOWS.storage}\\library-0.9.0`;

    expect(updateList([stale, ...CFX], true, WINDOWS)).toEqual([...CFX, WINDOWS.current]);
  });

  it("leaves a folder that only starts like its storage alone", () => {
    const neighbour = `${WINDOWS.storage}-fork\\library`;

    expect(updateList([neighbour], true, WINDOWS)).toEqual([neighbour, WINDOWS.current]);
  });

  it("compares case-sensitively on Linux", () => {
    const linux: Paths = { current: "/home/dev/.config/Code/ugcore/library", storage: "/home/dev/.config/Code/ugcore", home: "/home/dev", windows: false };

    expect(updateList(["/home/dev/.config/Code/UGCORE/library"], true, linux)).toEqual([
      "/home/dev/.config/Code/UGCORE/library",
      linux.current,
    ]);
    expect(normalize("~/x", linux)).toBe("/home/dev/x");
  });
});

describe("plan", () => {
  it("turns the library on for consumers", () => {
    expect(plan("auto", false)).toEqual({ user: true, workspace: true, hideInWorkspace: false });
  });

  it("hides it in ug-core's own source only, keeping it for other workspaces", () => {
    expect(plan("auto", true)).toEqual({ user: true, workspace: false, hideInWorkspace: true });
    expect(plan("on", true)).toEqual({ user: true, workspace: true, hideInWorkspace: false });
  });

  it("removes it everywhere when off", () => {
    expect(plan("off", false)).toEqual({ user: false, workspace: false, hideInWorkspace: false });
  });
});

describe("isCoreInit", () => {
  it("recognizes ug-core's init file only", () => {
    expect(isCoreInit("---@class UgCore\nUgCore = {}\n\n---@class UgCore.Internal\nUgCore.Internal = {}\n")).toBe(true);
    expect(isCoreInit("local x = UgCore.Internal\n")).toBe(false);
  });
});
