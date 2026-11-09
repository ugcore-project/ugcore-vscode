--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/inventory/server/store.lua.

---@class UgInventoryItem
---@field name string
---@field count integer
---@field metadata? table

---@class UgInventorySlot: UgInventoryItem
---@field slot integer

---@class UgInventoryContainer
---@field id string
---@field label? string shown to players who open it
---@field slots integer
---@field maxWeight integer
---@field items table<integer, UgInventoryItem>
---@field owner? integer player source whose own inventory this is
---@field viewers table<integer, boolean> player sources that have it open
---@field persistent boolean saved to the database
---@field lastUsed integer GetGameTimer ms of the last access, for idle unloading
---@field logs UgDbQuery[] audit rows not written yet

---@class UgInventoryChange
---@field slot integer
---@field item? UgInventoryItem nil when the slot is now empty
