--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/hooks.lua.

---Before-the-fact extension points. Handlers MAY cancel or replace the payload.
---Hooks belong to the resource that registered them and are removed when it stops.
---@class UgCore.Hooks
UgCore.Hooks = {}

---@class UgHookEntry
---@field id integer
---@field name UgHookName
---@field handler UgHookHandler
---@field priority integer
---@field resource string

---Server only.
---@param name UgHookName
---@param handler UgHookHandler
---@param options? UgHookOptions
---@return integer id for `Unregister`
function UgCore.Hooks.Register(name, handler, options) end

---Server only.
---@param id integer
---@return boolean removed false when the id is unknown or already removed
function UgCore.Hooks.Unregister(id) end
