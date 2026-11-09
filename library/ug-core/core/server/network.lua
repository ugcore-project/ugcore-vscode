--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/network.lua.

---Client-to-server net events with a schema and a rate limit. The only place that calls RegisterNetEvent.
---@class UgCore.Network
UgCore.Network = {}

---@class UgNetworkEntry
---@field name string full event name, for logs
---@field options UgNetworkOptions
---@field limiter UgRateLimiter

---Registers `<resource>:<name>`. The handler gets `(source, ...)` with validated arguments.
---
---Client: `Register(name, handler)`.
---@param name string
---@param options UgNetworkOptions
---@param handler fun(source: integer, ...: any)
---@overload fun(name: string, handler: fun(...: any))
function UgCore.Network.Register(name, options, handler) end

---Server only.
---@param source integer player source, or -1 for every player
---@param name string full event name, such as `ug-hud:Update`
---@param ... any
function UgCore.Network.TriggerClient(source, name, ...) end

---Server only.
---@param name string full event name
---@param ... any
function UgCore.Network.TriggerClients(name, ...) end
