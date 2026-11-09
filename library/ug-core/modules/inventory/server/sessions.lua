--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/inventory/server/sessions.lua.

---@class UgInventorySession
---@field id string
---@field reach UgInventoryReach

---@class UgOpenedInventory
---@field label? string
---@field slots integer
---@field maxWeight integer grams
---@field items UgInventorySlot[]

---Opens an inventory for a player from server code, such as a house stash or a search.
---Reach is not checked: the caller decided. The player sees it as `other` until it closes. MUST run in a thread.
---
---Client: `Open(kind, key)`.
---@param source integer
---@param inventoryId string any saved inventory id, or a loaded one
---@return boolean ok
---@return UgErrorCode? errorCode `not_loaded`, `not_found`, `no_permission` when a hook cancelled
---@overload fun(kind: 'stash'|'trunk'|'glovebox'|'drop', key: string|integer): boolean, UgErrorCode?
function UgCore.Inventory.Open(source, inventoryId) end

---Client: `Close()`.
---@param source integer
---@overload fun(): boolean, UgErrorCode?
function UgCore.Inventory.Close(source) end

---Server only.
---@param source integer
---@return string? id the inventory the player has open
function UgCore.Inventory.GetOpen(source) end
