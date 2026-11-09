--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/events.lua.

---After-the-fact notifications over local events, so every resource on the same side receives them.
---Handlers drop `ug-core:*` events that ug-core did not emit.
---@class UgCore.Events
UgCore.Events = {}

---@param name UgCoreEvent|string
---@param handler fun(...: any)
---@return integer id for `Off`
function UgCore.Events.On(name, handler) end

---The handler runs at most once.
---@param name UgCoreEvent|string
---@param handler fun(...: any)
---@return integer id for `Off`
function UgCore.Events.Once(name, handler) end

---@param id integer
---@return boolean removed false when the id is unknown or already removed
function UgCore.Events.Off(id) end

---Names MUST start with the emitting resource name.
---@param name UgCoreEvent|string
---@param ... any
function UgCore.Events.Emit(name, ...) end
