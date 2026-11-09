--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/inventory/server/containers.lua.

---Who MAY use a stash or a shop. Any listed job, gang or group gives access. None listed means everyone.
---@class UgAccessRules
---@field jobs? table<string, integer> job name -> minimum grade
---@field gangs? table<string, integer> gang name -> minimum grade
---@field groups? string[] permission groups
---@field check? fun(source: integer): boolean extra check, after jobs, gangs and groups

---@class UgStashOptions: UgAccessRules
---@field label string
---@field slots integer
---@field weight integer grams
---@field coords? vector3 where players open it themselves. Without coords, only `Inventory.Open` opens it.
---@field distance? number meters, defaults to 2.0
---@field personal? boolean one inventory per character

---@class UgStashDefinition: UgStashOptions
---@field name string
---@field resource? string registering resource, nil for config stashes

---@class UgInventoryReach
---@field kind 'direct'|'stash'|'trunk'|'glovebox'|'drop'
---@field name? string stash name
---@field netId? integer vehicle network id
---@field plate? string normalized plate
---@field id? string drop id

---@class UgDrop
---@field coords vector3
---@field expiresAt integer GetGameTimer ms

---Registers a stash from a resource. Removed when the resource stops; its items stay saved.
---
---Server only.
---@param name string lowercase letters, digits and underscores
---@param options UgStashOptions
function UgCore.Inventory.RegisterStash(name, options) end

---Server only.
---@param name string
---@return UgStashDefinition? definition a copy without `check`, nil for unknown stashes
function UgCore.Inventory.GetStash(name) end

---The inventory id of a stash. Personal stashes need the player, for their character.
---
---Server only.
---@param name string
---@param source? integer
---@return string? id nil for unknown stashes, or a personal stash without a loaded character
function UgCore.Inventory.GetStashId(name, source) end

---Loads a saved inventory by id: player, stash, trunk or glovebox. MUST run in a thread.
---
---Server only.
---@param id string
---@return boolean ok
---@return UgErrorCode? errorCode `not_found` for unknown ids
function UgCore.Inventory.Load(id) end

---Starts or stops saving the trunk and glovebox of a plate. A garage resource does this for owned vehicles.
---Stopping deletes the saved items. MUST run in a thread.
---
---Server only.
---@param plate string
---@param persistent boolean
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Inventory.SetPersistent(plate, persistent) end

---Creates a ground drop. With `items`, every item MUST fit, or no drop is created.
---
---Server only.
---@param coords vector3
---@param items? { name: string, count: integer, metadata?: table }[]
---@param reason? string stored in the audit log
---@return boolean ok
---@return string? id
---@return UgErrorCode? errorCode
function UgCore.Inventory.CreateDrop(coords, items, reason) end

---@return table<string, vector3> drops by id
function UgCore.Inventory.GetDrops() end
