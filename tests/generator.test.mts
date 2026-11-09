import { describe, expect, it } from "vitest";
import { functionType, parseParam, readType } from "../scripts/lib/annotations.mts";
import { extract, type Item } from "../scripts/lib/extract.mts";
import { render } from "../scripts/lib/render.mts";

const HEADER = `--[[

    ug-core - https://github.com/ugcore-project

]] --
`;

function lua(...lines: string[]): string {
  return `${HEADER}\n${lines.join("\n")}\n`;
}

function output(...files: [path: string, side: "shared" | "server" | "client", source: string][]): Map<string, string> {
  return render(
    files.map(([path, side, source]) => ({ path, items: extract(source, path, side) })),
    "Generated.",
  ).files;
}

function functions(items: Item[]): string[] {
  return items.flatMap((item) => (item.kind === "function" ? [item.target] : []));
}

describe("annotations", () => {
  it("reads types with spaces inside brackets and after colons", () => {
    expect(readType("fun(source: integer, ...: any): any the handler")).toEqual(["fun(source: integer, ...: any): any", "the handler"]);
    expect(readType("integer|string usually the source")).toEqual(["integer|string", "usually the source"]);
    expect(readType("table<string, boolean>")).toEqual(["table<string, boolean>", ""]);
    expect(readType("(UgGuardAction)? action")).toEqual(["(UgGuardAction)?", "action"]);
    expect(readType("'latest'|'outdated' status")).toEqual(["'latest'|'outdated'", "status"]);
  });

  it("parses optional params and builds overload types", () => {
    expect(parseParam("---@param options? UgHookOptions lower runs first")).toEqual({ name: "options", type: "UgHookOptions", optional: true });
    expect(
      functionType("name, handler, ...", ["---@param name string", "---@param handler fun(...: any): any", "---@return boolean ok", "---@return any value"]),
    ).toBe("fun(name: string, handler: fun(...: any): any, ...: any): boolean, any");
    expect(functionType("value", ["---@generic T", "---@param value T"])).toBeNull();
  });
});

describe("extract", () => {
  it("follows local aliases to the public path", () => {
    const items = extract(
      lua("---@class UgCore.Events", "local Events = {}", "UgCore.Events = Events", "", "---@param id integer", "function Events.Off(id)", "    return true", "end"),
      "core/shared/events.lua",
      "shared",
    );

    expect(functions(items)).toEqual(["UgCore.Events.Off"]);
    expect(items[0]).toEqual({ kind: "raw", text: "---@class UgCore.Events\nUgCore.Events = {}" });
  });

  it("drops everything under UgCore.Internal, through aliases too", () => {
    const items = extract(
      lua(
        "---@class UgCore.Internal.Network",
        "local InternalNetwork = {}",
        "UgCore.Internal.Network = InternalNetwork",
        "local Utils = UgCore.Internal.Utils",
        "function InternalNetwork.Listen(name) end",
        "function Utils.Raise(level) end",
        "function UgCore.Internal.Secret() end",
      ),
      "core/server/network.lua",
      "server",
    );

    expect(items).toEqual([]);
  });

  it("keeps local classes with their methods, and skips local functions", () => {
    const items = extract(
      lua(
        "---@class UgRateLimiter",
        "---@field private max integer",
        "local Limiter = {}",
        "Limiter.__index = Limiter",
        "",
        "local function refill() end",
        "",
        "---@param key integer|string",
        "---@return boolean allowed",
        "function Limiter:Consume(key) end",
      ),
      "core/server/ratelimit.lua",
      "server",
    );

    expect(items[0]).toEqual({ kind: "raw", text: "---@class UgRateLimiter\n---@field private max integer\nlocal Limiter = {}" });
    expect(functions(items)).toEqual(["Limiter:Consume"]);
  });

  it("copies enum literals and rewrites aliases inside them", () => {
    const items = extract(
      lua(
        "local Violations = UgCore.Enums.Violations",
        "",
        "---@type table<UgViolation, integer>",
        "UgCore.Enums.ViolationWeights = {",
        "    [Violations.InvalidPayload] = 5, -- worst",
        "}",
      ),
      "core/shared/enums/violations.lua",
      "shared",
    );

    expect(items).toEqual([
      {
        kind: "raw",
        text: "---@type table<UgViolation, integer>\nUgCore.Enums.ViolationWeights = {\n    [UgCore.Enums.Violations.InvalidPayload] = 5, -- worst\n}",
      },
    ]);
  });

  it("keeps standalone type blocks and skips blocks of private classes", () => {
    const items = extract(
      lua("---@alias UgHookName 'a'|'b'", "", "---@class UgCore.Internal.Thing", "---@field x integer", "", "---Just a comment.", ""),
      "core/shared/enums/hooks.lua",
      "shared",
    );

    expect(items).toEqual([{ kind: "raw", text: "---@alias UgHookName 'a'|'b'" }]);
  });

  it("reads function assignments and parameter lists over several lines", () => {
    const items = extract(
      lua("---@class UgCore.Jobs", "local Jobs = {}", "UgCore.Jobs = Jobs", "Jobs.Get = function(source)", "end", "function Jobs.Set(source,", "    job, grade)", "end"),
      "modules/jobs/server/api.lua",
      "server",
    );

    expect(items.filter((item) => item.kind === "function").map((item) => item.kind === "function" && [item.target, item.params])).toEqual([
      ["UgCore.Jobs.Get", "source"],
      ["UgCore.Jobs.Set", "source, job, grade"],
    ]);
  });
});

describe("render", () => {
  const server = lua(
    "---@class UgCore.Callback",
    "local Callback = {}",
    "UgCore.Callback = Callback",
    "",
    "---Registers a callback.",
    "---@param name string",
    "---@param options UgNetworkOptions",
    "---@param handler fun(source: integer, ...: any): any",
    "function Callback.Register(name, options, handler) end",
    "",
    "---@param name string",
    "function Callback.Unregister(name) end",
  );
  const client = lua(
    "---@class UgCore.Callback",
    "local Callback = {}",
    "UgCore.Callback = Callback",
    "",
    "---@param name string",
    "---@param handler fun(...: any): any",
    "function Callback.Register(name, handler) end",
    "",
    "---@param name string",
    "function Callback.Unregister(name) end",
    "",
    "---@return boolean",
    "function Callback.ClientOnly() end",
  );

  it("turns a different client signature into an overload of the server one", () => {
    const files = output(["core/server/callback.lua", "server", server], ["core/client/callback.lua", "client", client]);
    const serverFile = files.get("core/server/callback.lua") as string;

    expect(serverFile).toContain(
      [
        "---Registers a callback.",
        "---",
        "---Client: `Register(name, handler)`.",
        "---@param name string",
        "---@param options UgNetworkOptions",
        "---@param handler fun(source: integer, ...: any): any",
        "---@overload fun(name: string, handler: fun(...: any): any)",
        "function UgCore.Callback.Register(name, options, handler) end",
      ].join("\n"),
    );
    expect(serverFile).toContain("---@param name string\nfunction UgCore.Callback.Unregister(name) end");
    expect(serverFile.startsWith(HEADER.split("\n")[0] as string)).toBe(true);
    expect(serverFile).toContain("---@meta");

    const clientFile = files.get("core/client/callback.lua") as string;

    expect(clientFile).not.toContain("Callback.Register");
    expect(clientFile).not.toContain("Callback.Unregister");
    expect(clientFile).toContain("---Client only.\n---@return boolean\nfunction UgCore.Callback.ClientOnly() end");
  });

  it("writes no file for a source without public declarations", () => {
    expect(output(["core/server/boot.lua", "server", lua("local x = 1", "print(x)")]).size).toBe(0);
  });
});
