--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/shops/server/api.lua.

---Shops sell items for an account at prices from the server. Clients pick an item by its position and a count,
---nothing else. Stock is reserved before paying, and the payment is refunded when the items cannot be given.
---@class UgCore.Shops
UgCore.Shops = {}

---@class UgShopItem
---@field name string
---@field price integer per unit
---@field stock? integer most units in stock. Without it, the item never runs out.
---@field restock? integer minutes between refills to `stock`
---@field metadata? table given with each unit, such as a loaded weapon

---@class UgShopOptions: UgAccessRules
---@field label string
---@field coords vector3|vector3[] where players buy
---@field distance? number meters, defaults to 2.5
---@field account string account that pays
---@field items UgShopItem[]

---@class UgShopDefinition: UgShopOptions
---@field name string
---@field coords vector3[]
---@field resource? string registering resource, nil for config shops

---@class UgShopListing
---@field label string
---@field account string
---@field items { index: integer, name: string, price: integer, stock?: integer }[]

---@class UgShopStock
---@field stock integer
---@field restockedAt integer Unix seconds

---Buys `count` units of the item at `index` in the shop. MUST run in a thread.
---
---Client: `Buy(name, index, count)`.
---@param source integer
---@param name string shop name
---@param index integer position of the item in the shop
---@param count integer 1 to 1000
---@return boolean ok
---@return UgErrorCode? errorCode `not_found`, `no_permission`, `insufficient_items` when out of stock, `cannot_carry`, `insufficient_funds`, `not_loaded`
---@overload fun(name: string, index: integer, count: integer): boolean, UgErrorCode?
function UgCore.Shops.Buy(source, name, index, count) end

---Registers a shop from a resource, removed when it stops. Its stock stays saved.
---
---Server only.
---@param name string
---@param options UgShopOptions
function UgCore.Shops.Register(name, options) end

---Server only.
---@param name string
---@return { label: string, coords: vector3[], distance: number, account: string, items: UgShopItem[], stock: table<string, integer> }? shop a copy
function UgCore.Shops.Get(name) end

---Client: `GetAll()`.
---@return string[] names sorted by name
---@overload fun(): table<string, { label: string, coords: vector3[] }>
function UgCore.Shops.GetAll() end

---Refills limited items to their stock. Without `item`, every item of the shop.
---
---Server only.
---@param name string
---@param item? string
---@return boolean ok false for unknown shops or items without stock
function UgCore.Shops.Restock(name, item) end
