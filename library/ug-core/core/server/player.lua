--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/player.lua.

---@class UgPlayer
---@field source integer
---@field name string
---@field identifier string primary identifier
---@field characterId? integer loaded character when the object was created
---@field joinedAt integer Unix seconds
local UgPlayer = {}

---Server only.
---@return boolean online false once the player dropped
function UgPlayer:IsOnline() end

---Server only.
---@return boolean loaded true once a character is loaded, or at join without the characters module
function UgPlayer:IsLoaded() end

---Server only.
---@param key? string every key when nil
---@return any
function UgPlayer:GetMetadata(key) end

---Server only.
---@param key string camelCase
---@param value any `nil` deletes the key
---@param replicate? boolean copies the key to the `ug-core:Metadata` statebag
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:SetMetadata(key, value, replicate) end

---Server only.
---@param reason? string shown to the player, a generic message when nil
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:Kick(reason) end

---Server only.
---@return UgDeathState
function UgPlayer:GetDeathState() end

---Server only.
---@return boolean
function UgPlayer:IsDead() end

---Server only.
---@return boolean
function UgPlayer:IsDowned() end

---Server only.
---@return UgInjury[]
function UgPlayer:GetInjuries() end

---Server only.
---@return UgCauseOfDeath?
function UgPlayer:GetCauseOfDeath() end

---Server only.
---@param region? UgBodyRegion every region when nil
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:ClearInjuries(region) end

---Server only.
---@param cause? UgCauseOfDeath
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:Down(cause) end

---Server only.
---@param cause? UgCauseOfDeath
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:Kill(cause) end

---Server only.
---@param options? UgReviveOptions
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:Revive(options) end

---Server only.
---@param coords? vector4
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:Respawn(coords) end

---Server only.
---@return string[]
function UgPlayer:GetIdentifiers() end

---MUST run in a thread.
---
---Server only.
---@return boolean banned
---@return UgBan? ban
---@return UgErrorCode? errorCode
function UgPlayer:IsBanned() end

---MUST run in a thread.
---
---Server only.
---@param options? UgBanOptions
---@return boolean ok
---@return integer? banId
---@return UgErrorCode? errorCode
function UgPlayer:Ban(options) end

---Server only.
---@param permission string
---@return boolean
function UgPlayer:HasPermission(permission) end

---MUST run in a thread.
---
---Server only.
---@param permission string
---@param by? string
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:GrantPermission(permission, by) end

---MUST run in a thread.
---
---Server only.
---@param permission string
---@return boolean ok
---@return boolean? removed
---@return UgErrorCode? errorCode
function UgPlayer:RevokePermission(permission) end

---Server only.
---@return string[] permissions granted with GrantPermission
function UgPlayer:GetPermissions() end

---MUST run in a thread.
---
---Server only.
---@param group string a group from config/permissions.lua
---@param by? string
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:AddGroup(group, by) end

---MUST run in a thread.
---
---Server only.
---@param group string
---@return boolean ok
---@return boolean? removed
---@return UgErrorCode? errorCode
function UgPlayer:RemoveGroup(group) end

---Server only.
---@return string[] groups highest weight first
function UgPlayer:GetGroups() end

---Server only.
---@param group string
---@return boolean member directly or through inheritance
function UgPlayer:IsInGroup(group) end

---Server only.
---@return integer weight highest group weight, 0 without groups
function UgPlayer:GetWeight() end

---Server only.
---@param target UgPlayer|integer|string a player object, source or identifier
---@return boolean outranks true when this player's weight is strictly higher
function UgPlayer:CanTarget(target) end

---Server only.
---@return UgCharacter?
function UgPlayer:GetCharacter() end

---Server only.
---@return boolean ok
---@return UgCharacter[]? characters
---@return UgErrorCode? errorCode
function UgPlayer:GetCharacters() end

---Server only.
---@param characterId integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:LoadCharacter(characterId) end

---Server only.
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:UnloadCharacter() end

---Server only.
---@param account string
---@return integer? balance nil when no character is loaded
function UgPlayer:GetBalance(account) end

---Server only.
---@return table<string, integer>? balances nil when no character is loaded
function UgPlayer:GetBalances() end

---Server only.
---@param account string
---@param amount integer
---@param reason? string
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode
function UgPlayer:AddMoney(account, amount, reason) end

---Server only.
---@param account string
---@param amount integer
---@param reason? string
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode
function UgPlayer:RemoveMoney(account, amount, reason) end

---Server only.
---@param account string
---@param balance integer
---@param reason? string
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode
function UgPlayer:SetMoney(account, balance, reason) end

---Server only.
---@param targetCharacterId integer
---@param account string
---@param amount integer
---@param reason? string
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode
function UgPlayer:TransferMoney(targetCharacterId, account, amount, reason) end

---Server only.
---@param account string
---@param limit? integer
---@return boolean ok
---@return UgLedgerEntry[]? entries
---@return UgErrorCode? errorCode
function UgPlayer:GetLedger(account, limit) end

---Server only.
---@return UgAssignment?
function UgPlayer:GetJob() end

---MUST run in a thread.
---
---Server only.
---@param name string
---@param grade? integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:SetJob(name, grade) end

---MUST run in a thread.
---
---Server only.
---@param grade integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:SetJobGrade(grade) end

---Server only.
---@param onDuty boolean
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:SetDuty(onDuty) end

---Server only.
---@return boolean
function UgPlayer:IsOnDuty() end

---Server only.
---@param name string
---@param count integer
---@param metadata? table
---@param reason? string
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:AddItem(name, count, metadata, reason) end

---Server only.
---@param name string
---@param count integer
---@param metadata? table filter
---@param reason? string
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:RemoveItem(name, count, metadata, reason) end

---Server only.
---@param name string
---@param metadata? table filter
---@return integer
function UgPlayer:GetItemCount(name, metadata) end

---Server only.
---@param name string
---@param count? integer defaults to 1
---@param metadata? table filter
---@return boolean
function UgPlayer:HasItem(name, count, metadata) end

---Server only.
---@param name string
---@param count integer
---@param metadata? table
---@return boolean
function UgPlayer:CanCarry(name, count, metadata) end

---Server only.
---@return UgInventorySlot[]
function UgPlayer:GetItems() end

---Server only.
---@param slot integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:UseItem(slot) end

---MUST run in a thread.
---
---Server only.
---@param inventoryId string
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:OpenInventory(inventoryId) end

---Server only.
function UgPlayer:CloseInventory() end

---Server only.
---@return string? id the inventory this player has open
function UgPlayer:GetOpenInventory() end

---Server only.
---@return UgEquippedWeapon?
function UgPlayer:GetEquippedWeapon() end

---Server only.
---@param slot integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:EquipWeapon(slot) end

---Server only.
---@param reason? string
---@return boolean ok false when nothing was equipped
function UgPlayer:UnequipWeapon(reason) end

---MUST run in a thread.
---
---Server only.
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:ReloadWeapon() end

---MUST run in a thread.
---
---Server only.
---@param shop string
---@param index integer position of the item in the shop
---@param count integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:Buy(shop, index, count) end

---Server only.
---@return UgAssignment?
function UgPlayer:GetGang() end

---MUST run in a thread.
---
---Server only.
---@param name string
---@param grade? integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:SetGang(name, grade) end

---MUST run in a thread.
---
---Server only.
---@param grade integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:SetGangGrade(grade) end

---Server only.
---@return integer? sessionId nil in the shared world
function UgPlayer:GetSession() end

---Server only.
---@param sessionId integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:JoinSession(sessionId) end

---Server only.
---@return boolean ok
---@return UgErrorCode? errorCode
function UgPlayer:LeaveSession() end

---Server only.
---@param violation UgViolation
---@param detail? string server logs only
function UgPlayer:Flag(violation, detail) end

---Server only.
---@return number score
function UgPlayer:GetScore() end

---Server only.
---@param coords vector3 a position the server knows, never one sent by the client
---@param maxDistance number
---@return boolean
function UgPlayer:IsNear(coords, maxDistance) end

---Server only.
---@param name string full event name, such as `ug-hud:Update`
---@param ... any
function UgPlayer:TriggerClient(name, ...) end

---Asks this player's client. MUST run in a thread. The answer is untrusted and validated with `options.schema`.
---
---Server only.
---@param name string full callback name, such as `ug-hud:GetSettings`
---@param options UgClientCallbackOptions
---@param ... any
---@return boolean ok
---@return any value
---@return UgErrorCode? errorCode
function UgPlayer:AwaitCallback(name, options, ...) end
