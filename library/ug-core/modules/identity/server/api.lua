--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/identity/server/api.lua.

---Identifiers and bans. A ban covers every identifier of the player except `ip:`.
---@class UgCore.Identity
UgCore.Identity = {}

---Every identifier of a connected or connecting player, such as `license:abc`.
---
---Server only.
---@param source integer
---@return string[]
function UgCore.Identity.GetIdentifiers(source) end

---The identifier of the type set in config/identity.lua.
---
---Server only.
---@param source integer
---@return string?
function UgCore.Identity.GetPrimary(source) end

---MUST run in a thread.
---
---Server only.
---@param target integer|string|string[] source, identifier or identifiers
---@return boolean banned
---@return UgBan? ban the active ban that lasts longest
---@return UgErrorCode? errorCode `internal_error` when the database failed
function UgCore.Identity.IsBanned(target) end

---Bans every identifier of the target. MUST run in a thread.
---Pass identifiers instead of a source when the player is already dropped.
---
---Server only.
---@param target integer|string|string[] source, identifier or identifiers
---@param options? UgBanOptions
---@return boolean ok
---@return integer? banId
---@return UgErrorCode? errorCode
function UgCore.Identity.Ban(target, options) end

---Lifts every active ban covering the target. MUST run in a thread.
---
---Server only.
---@param target integer|string|string[] source, identifier or identifiers
---@return boolean ok
---@return integer? count of lifted bans
---@return UgErrorCode? errorCode
function UgCore.Identity.Unban(target) end
