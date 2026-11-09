--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/inventory/server/service.lua.

---Moves units between slots of one or two inventories. A full stack swaps with a different item.
---Without `toSlot`, the units go where `AddItem` would put them.
---
---Client: `Move(fromSlot, toSlot, count)`.
---@param from integer|string player source or inventory id
---@param fromSlot integer
---@param to integer|string player source or inventory id
---@param toSlot? integer
---@param count? integer defaults to the whole stack
---@param reason? string
---@return boolean ok
---@return UgErrorCode? errorCode `not_found`, `cannot_carry`, `invalid_args`, `no_permission`
---@overload fun(fromSlot: integer, toSlot: integer, count?: integer): boolean, UgErrorCode?
function UgCore.Inventory.Move(from, fromSlot, to, toSlot, count, reason) end

---Latest audit rows, newest first. Saves the inventory first, so the log is complete. MUST run in a thread.
---
---Server only.
---@param target integer|string player source or inventory id
---@param limit? integer 1 to 100, defaults to 25
---@return boolean ok
---@return UgItemLogEntry[]? entries
---@return UgErrorCode? errorCode
function UgCore.Inventory.GetLog(target, limit) end

---Uses the item in a slot of the player's inventory: checks, then the registered handler, then consumption.
---
---Client: `Use(slot)`.
---@param source integer
---@param slot integer
---@return boolean ok
---@return UgErrorCode? errorCode `not_loaded`, `not_found`, `invalid_args` when not usable, `rate_limited` during cooldown, `no_permission`
---@overload fun(slot: integer): boolean, UgErrorCode?
function UgCore.Inventory.Use(source, slot) end
