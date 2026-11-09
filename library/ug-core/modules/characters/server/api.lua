--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/characters/server/api.lua.

---Characters of a player, keyed by the primary identifier. Delete is a soft delete.
---Every function that touches the database MUST run in a thread.
---@class UgCore.Characters
UgCore.Characters = {}

---@class UgCharacterParticipant
---@field create? fun(source: integer, characterId: integer): boolean
---@field load? fun(source: integer, characterId: integer): boolean
---@field unload? fun(source: integer, characterId: integer)

---Server only.
---@param source integer
---@return boolean ok
---@return UgCharacter[]? characters ordered by creation
---@return UgErrorCode? errorCode
function UgCore.Characters.GetAll(source) end

---Input usually comes from a character creator, so invalid input returns `invalid_args` instead of raising.
---
---Server only.
---@param source integer
---@param input UgCharacterInput
---@return boolean ok
---@return integer? characterId
---@return UgErrorCode? errorCode `no_permission` when the limit is reached or a hook cancelled
function UgCore.Characters.Create(source, input) end

---Soft delete. The loaded character cannot be deleted.
---
---Server only.
---@param source integer
---@param characterId integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Characters.Delete(source, characterId) end

---Loads an owned character. A loaded character is unloaded first. Restores death state when persisted.
---
---Server only.
---@param source integer
---@param characterId integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Characters.Load(source, characterId) end

---Saves and unloads the character. The player goes back to not loaded and alive.
---
---Server only.
---@param source integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Characters.Unload(source) end

---Last saved position of a character, nil before its first save. MUST run in a thread.
---
---Server only.
---@param characterId integer
---@return boolean ok
---@return vector4? position
---@return UgErrorCode? errorCode
function UgCore.Characters.GetPosition(characterId) end

---Server only.
---@param source integer
---@return UgCharacter?
function UgCore.Characters.GetActive(source) end
