--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/items/server/api.lua.

---Item definitions from config/items.lua and from resources, and the registry of usable items.
---Definitions replicate to clients through `GlobalState['ug-core:Items']`, without metadata validators.
---@class UgCore.Items
UgCore.Items = {}

---@class UgItemDefinition
---@field name string
---@field label string
---@field weight integer grams per unit
---@field stack boolean
---@field maxStack integer 1 when the item does not stack
---@field description? string
---@field keepOnRespawn boolean
---@field usable boolean

---@class UgItemRegistration
---@field label string
---@field weight integer grams per unit
---@field stack? boolean defaults to true
---@field maxStack? integer
---@field description? string
---@field keepOnRespawn? boolean
---@field metadata? UgSchemaRule|fun(metadata: table): boolean, any, string? validates metadata on every write

---@class UgItemUseOptions
---@field consume? integer units removed from the slot after a successful use, defaults to 0
---@field cooldown? integer ms between uses of this item per player, defaults to 0
---@field requireAlive? boolean defaults to true

---@class UgItemUse
---@field handler fun(source: integer, item: UgInventorySlot): boolean?
---@field options UgItemUseOptions
---@field resource string

---@alias UgMetadataValidator fun(metadata: table): boolean, table?, string?

---@class UgItemEntry: UgItemDefinition
---@field resource? string registering resource, nil for config items

---Registers an item from a resource. Config items win: their fields stay, only `metadata` is added.
---Items registered by a resource are removed when it stops.
---
---Server only.
---@param name string lowercase letters, digits and underscores
---@param definition UgItemRegistration
function UgCore.Items.Register(name, definition) end

---@param name string
---@return UgItemDefinition? definition a copy, nil for unknown items
function UgCore.Items.Get(name) end

---@return table<string, UgItemDefinition> definitions copies, by name
function UgCore.Items.GetAll() end

---@param name string
---@return boolean
function UgCore.Items.Exists(name) end

---Makes an item usable. The handler gets `(source, item)` and runs after every check. Return false to refuse the use:
---nothing is consumed. Handlers registered by a resource are removed when it stops.
---
---Server only.
---@param name string an existing item
---@param handler fun(source: integer, item: UgInventorySlot): boolean?
---@param options? UgItemUseOptions
function UgCore.Items.RegisterUse(name, handler, options) end

---Server only.
---@param name string
---@return boolean
function UgCore.Items.IsUsable(name) end
