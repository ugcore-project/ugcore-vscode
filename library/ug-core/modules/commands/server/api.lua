--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/commands/server/api.lua.

---Chat commands. Arguments are untrusted input: they are typed, bounded and validated before the handler runs.
---Failures from players emit `ug-core:Commands:Failed` for UI resources. ug-core itself shows nothing to players.
---@class UgCore.Commands
UgCore.Commands = {}

---@class UgCommandEntry
---@field info UgCommandInfo
---@field options UgCommandOptions
---@field limiter UgRateLimiter
---@field handler fun(source: integer, args: table<string, any>)

---Registers a chat command `/name`. The handler gets `(source, args)` with args keyed by name. Source 0 is the console.
---
---Server only.
---@param name string
---@param options UgCommandOptions
---@param handler fun(source: integer, args: table<string, any>)
function UgCore.Commands.Register(name, options, handler) end

---True when the player passes the command's `permission` and `groups`. For chat suggestions and menus.
---Rate limits, `requirePlayer` and arguments are not checked. Unknown commands return false.
---
---Server only.
---@param source integer player source, or 0 for the console
---@param name string command name without the slash
---@return boolean
function UgCore.Commands.CanUse(source, name) end

---Commands sorted by name, for chat suggestions. Filter them per player with CanUse.
---
---Server only.
---@return UgCommandInfo[]
function UgCore.Commands.GetAll() end
