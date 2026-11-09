--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/players/server/api.lua.

---Connected players. Metadata lives for the session. Keys set with `replicate` reach every client.
---@class UgCore.Players
UgCore.Players = {}

---@class UgPlayerRecord
---@field source integer
---@field name string
---@field identifier string
---@field characterId? integer
---@field joinedAt integer
---@field metadata table<string, any>
---@field replicated table<string, boolean>

---Server only.
---@param source integer
---@return UgPlayer?
function UgCore.Players.Get(source) end

---Server only.
---@return UgPlayer[] sorted by source
function UgCore.Players.GetAll() end

---Server only.
---@param identifier string
---@return UgPlayer?
function UgCore.Players.GetByIdentifier(identifier) end

---Server only.
---@param characterId integer
---@return UgPlayer?
function UgCore.Players.GetByCharacterId(characterId) end

---Session metadata. `nil` deletes the key. Replicated keys reach every client, so they MUST NOT hold secrets.
---
---Server only.
---@param source integer
---@param key string camelCase
---@param value any
---@param replicate? boolean
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Players.SetMetadata(source, key, value, replicate) end

---Server only.
---@param source integer
---@param key? string every key when nil
---@return any
function UgCore.Players.GetMetadata(source, key) end

---Server only.
---@param source integer
---@param reason? string shown to the player, a generic message when nil
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Players.Kick(source, reason) end
