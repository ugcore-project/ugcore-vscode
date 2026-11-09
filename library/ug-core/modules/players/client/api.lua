--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/players/client/api.lua.

---The local player. Reads statebags only.
---@class UgCore.LocalPlayer
UgCore.LocalPlayer = {}

---Client only.
---@return { name: string, characterId: integer? }?
function UgCore.LocalPlayer.GetData() end

---Client only.
---@return boolean
function UgCore.LocalPlayer.IsLoaded() end

---Replicated metadata only.
---
---Client only.
---@param key? string every replicated key when nil
---@return any
function UgCore.LocalPlayer.GetMetadata(key) end

---Client only.
---@return UgDeathState
function UgCore.LocalPlayer.GetDeathState() end

---Client only.
---@return boolean
function UgCore.LocalPlayer.IsDead() end

---Client only.
---@return boolean
function UgCore.LocalPlayer.IsDowned() end

---Client only.
---@return UgInjury[]
function UgCore.LocalPlayer.GetInjuries() end
