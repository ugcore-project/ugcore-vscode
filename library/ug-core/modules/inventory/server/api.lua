--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/inventory/server/api.lua.

---Server-authoritative inventories. Every change is all or nothing, runs a hook, writes an audit row and emits an event.
---`target` is a player source, for that player's inventory, or an inventory id such as `player:12`.
---@class UgCore.Inventory
UgCore.Inventory = {}

---@class UgInventoryInfo
---@field id string
---@field slots integer
---@field maxWeight integer grams
---@field weight integer grams

---@class UgItemLogEntry
---@field item string
---@field amount integer positive when added
---@field metadata? table
---@field reason? string
---@field related? string the other inventory of a move or give
---@field createdAt integer Unix seconds

---Adds items, filling existing stacks first. MUST NOT be partial: all units fit, or nothing changes.
---
---Server only.
---@param target integer|string player source or inventory id
---@param name string
---@param count integer 1 to 1,000,000
---@param metadata? table
---@param reason? string stored in the audit log
---@return boolean ok
---@return UgErrorCode? errorCode `invalid_args`, `cannot_carry`, `no_permission` when a hook cancelled
function UgCore.Inventory.AddItem(target, name, count, metadata, reason) end

---Removes items from the lowest slots first. With `metadata`, only stacks whose metadata has those keys and values.
---
---Server only.
---@param target integer|string player source or inventory id
---@param name string
---@param count integer
---@param metadata? table filter
---@param reason? string stored in the audit log
---@return boolean ok
---@return UgErrorCode? errorCode `insufficient_items`, `no_permission` when a hook cancelled
function UgCore.Inventory.RemoveItem(target, name, count, metadata, reason) end

---Removes units from one slot.
---
---Server only.
---@param target integer|string player source or inventory id
---@param slot integer
---@param count? integer defaults to the whole stack
---@param reason? string
---@return boolean ok
---@return UgErrorCode? errorCode `not_found` for an empty slot, `insufficient_items`, `no_permission`
function UgCore.Inventory.RemoveFromSlot(target, slot, count, reason) end

---Replaces the metadata of a whole slot. The audit log records it with an amount of 0.
---
---Server only.
---@param target integer|string player source or inventory id
---@param slot integer
---@param metadata? table nil removes it
---@param reason? string
---@return boolean ok
---@return UgErrorCode? errorCode `not_found` for an empty slot, `invalid_args` for rejected metadata
function UgCore.Inventory.SetMetadata(target, slot, metadata, reason) end

---Removes every item, except those `keep` returns true for.
---
---Server only.
---@param target integer|string player source or inventory id
---@param reason? string
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Inventory.Clear(target, reason) end

---Client: `Count(name)`.
---@param target integer|string player source or inventory id
---@param name string
---@param metadata? table filter
---@return integer count 0 for unknown inventories
---@overload fun(name: string): integer
function UgCore.Inventory.Count(target, name, metadata) end

---Client: `HasItem(name, count)`.
---@param target integer|string player source or inventory id
---@param name string
---@param count? integer defaults to 1
---@param metadata? table filter
---@return boolean
---@overload fun(name: string, count?: integer): boolean
function UgCore.Inventory.HasItem(target, name, count, metadata) end

---Server only.
---@param target integer|string player source or inventory id
---@param name string
---@param count integer
---@param metadata? table
---@return boolean
function UgCore.Inventory.CanCarry(target, name, count, metadata) end

---Client: `GetItems()`.
---@param target integer|string player source or inventory id
---@return UgInventorySlot[] items copies, by slot
---@overload fun(): UgInventorySlot[]
function UgCore.Inventory.GetItems(target) end

---Client: `GetSlot(slot)`.
---@param target integer|string player source or inventory id
---@param slot integer
---@return UgInventorySlot? item a copy, nil for empty slots
---@overload fun(slot: integer): UgInventorySlot?
function UgCore.Inventory.GetSlot(target, slot) end

---Server only.
---@param target integer|string player source or inventory id
---@return UgInventoryInfo? info nil for unknown inventories
function UgCore.Inventory.Get(target) end

---Server only.
---@param inventoryId string
---@return integer? source the player who owns it, nil when offline or not a player inventory
function UgCore.Inventory.GetSource(inventoryId) end
