--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/weapons/server/api.lua.

---Weapons are inventory items. The server gives the equipped one to the ped and owns its state:
---serial, loaded ammo, durability, components and tint, stored in the item's metadata.
---Clients report their ammo count. The server only accepts it going down, and wears the weapon per shot.
---@class UgCore.Weapons
UgCore.Weapons = {}

---@class UgWeaponDefinition
---@field name string item name
---@field hash integer
---@field weapon string weapon name, such as `WEAPON_PISTOL`
---@field ammo? string ammo item
---@field capacity integer most rounds loaded, 0 without ammo
---@field wear number durability lost per shot, out of 100
---@field components table<string, integer> attachment item -> component hash

---@class UgEquippedWeapon
---@field name string item name
---@field serial string
---@field hash integer
---@field ammo integer rounds loaded
---@field durability number 0 to 100

---@class UgWeaponSerial
---@field serial string
---@field item string
---@field characterId? integer character it was created for
---@field createdAt integer Unix seconds

---Takes the weapon away. Its state is already in the item.
---
---Client: `Unequip()`.
---@param source integer
---@param reason? string
---@return boolean ok false when nothing was equipped
---@overload fun(): boolean, UgErrorCode?
function UgCore.Weapons.Unequip(source, reason) end

---Gives the weapon in a slot of the player's inventory to the ped. Equipping the equipped weapon takes it away.
---
---Client: `Equip(slot)`.
---@param source integer
---@param slot integer
---@return boolean ok
---@return UgErrorCode? errorCode `not_loaded`, `not_found`, `invalid_args` for other items and broken weapons, `no_permission`
---@overload fun(slot: integer): boolean, UgErrorCode?
function UgCore.Weapons.Equip(source, slot) end

---Client: `GetEquipped()`.
---@param source integer
---@return UgEquippedWeapon? weapon a copy, nil when nothing is equipped
---@overload fun(): { hash: integer, ammo: integer, tint?: integer }?
function UgCore.Weapons.GetEquipped(source) end

---Loads ammo items from the player's inventory, up to the weapon's capacity.
---
---Client: `Reload()`.
---@param source integer
---@return boolean ok
---@return UgErrorCode? errorCode `not_found` without an equipped weapon, `invalid_args` for weapons without ammo, `insufficient_items`
---@overload fun(): boolean, UgErrorCode?
function UgCore.Weapons.Reload(source) end

---Takes the loaded rounds out, back into the player's inventory.
---
---Client: `Unload()`.
---@param source integer
---@return boolean ok
---@return UgErrorCode? errorCode `not_found` without an equipped weapon, `invalid_args` for weapons without ammo, `cannot_carry`
---@overload fun(): boolean, UgErrorCode?
function UgCore.Weapons.Unload(source) end

---Attaches a component or tint item from the player's inventory to a weapon in it. The item is used up.
---
---Client: `Attach(weaponSlot, itemSlot)`.
---@param source integer
---@param weaponSlot integer
---@param itemSlot integer
---@return boolean ok
---@return UgErrorCode? errorCode `not_loaded`, `not_found`, `invalid_args` when the item does not fit this weapon or is already attached
---@overload fun(weaponSlot: integer, itemSlot: integer): boolean, UgErrorCode?
function UgCore.Weapons.Attach(source, weaponSlot, itemSlot) end

---Takes a component off a weapon, back into the player's inventory. Tints cannot be removed.
---
---Client: `Detach(weaponSlot, item)`.
---@param source integer
---@param weaponSlot integer
---@param item string the attachment item
---@return boolean ok
---@return UgErrorCode? errorCode `not_loaded`, `not_found`, `cannot_carry`
---@overload fun(weaponSlot: integer, item: string): boolean, UgErrorCode?
function UgCore.Weapons.Detach(source, weaponSlot, item) end

---Sets a weapon's durability, for repair benches and gunsmiths.
---
---Server only.
---@param target integer|string player source or inventory id
---@param slot integer
---@param durability? number 0 to 100, defaults to 100
---@return boolean ok
---@return UgErrorCode? errorCode `not_found`, `invalid_args` for other items
function UgCore.Weapons.Repair(target, slot, durability) end

---Who a serial was made for. MUST run in a thread.
---
---Server only.
---@param serial string
---@return boolean ok
---@return UgWeaponSerial? record nil for unknown serials
---@return UgErrorCode? errorCode
function UgCore.Weapons.GetBySerial(serial) end

---Server only.
---@param name string
---@return boolean
function UgCore.Weapons.IsWeapon(name) end

---Server only.
---@param name string item name
---@return { weapon: string, ammo?: string, capacity: integer, wear: number, components: string[] }? definition
function UgCore.Weapons.GetDefinition(name) end
