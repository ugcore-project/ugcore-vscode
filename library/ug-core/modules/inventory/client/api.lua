--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/inventory/client/api.lua.

---The local player's inventory, sent by the server to this player only. Reads are local.
---Actions ask the server, which decides. They MUST run in a thread and return `ok, errorCode`.
---@class UgCore.Inventory
UgCore.Inventory = {}

---@class UgClientInventory
---@field label? string
---@field slots integer
---@field maxWeight integer
---@field items table<integer, UgInventoryItem>

---Client only.
---@return boolean loaded false before a character is loaded
function UgCore.Inventory.IsLoaded() end

---Total weight in grams, from the replicated item weights.
---
---Client only.
---@return integer
function UgCore.Inventory.GetWeight() end

---Maximum weight in grams.
---
---Client only.
---@return integer
function UgCore.Inventory.GetMaxWeight() end

---Client only.
---@return integer
function UgCore.Inventory.GetSlots() end

---Gives items to a nearby player. MUST run in a thread.
---
---Client only.
---@param target integer server id of the other player
---@param slot integer
---@param count? integer defaults to the whole stack
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Inventory.Give(target, slot, count) end

---Asks the server to send the whole inventory again. MUST run in a thread.
---
---Client only.
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Inventory.Refresh() end

---Moves units between the player's inventory and the open one. MUST run in a thread.
---
---Client only.
---@param from 'player'|'other'
---@param fromSlot integer
---@param to 'player'|'other'
---@param toSlot integer
---@param count? integer defaults to the whole stack
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Inventory.MoveBetween(from, fromSlot, to, toSlot, count) end

---Drops items on the ground, into a drop nearby or a new one. MUST run in a thread.
---
---Client only.
---@param slot integer
---@param count? integer defaults to the whole stack
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Inventory.Drop(slot, count) end

---Client only.
---@return { label?: string, slots: integer, maxWeight: integer, items: UgInventorySlot[] }? inventory a copy of the open inventory
function UgCore.Inventory.GetOther() end
