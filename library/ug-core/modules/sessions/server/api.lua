--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/sessions/server/api.lua.

---Sessions are routing buckets owned by ug-core, allocated from 1000 up. A player is in at most one session.
---Bucket 0 is the shared world.
---@class UgCore.Sessions
UgCore.Sessions = {}

---@class UgSessionOptions
---@field name? string up to 64 characters
---@field lockdown? 'strict'|'relaxed'|'inactive' client entity creation, defaults to strict
---@field population? boolean ambient peds and vehicles, defaults to false
---@field persistent? boolean keeps the session when the last member leaves, defaults to false

---@class UgSession
---@field id integer
---@field name? string
---@field bucket integer
---@field lockdown string
---@field population boolean
---@field persistent boolean
---@field members integer[]

---@class UgSessionRecord
---@field id integer
---@field name? string
---@field bucket integer
---@field lockdown string
---@field population boolean
---@field persistent boolean
---@field members table<integer, boolean>

---Server only.
---@param options? UgSessionOptions
---@return boolean ok
---@return integer? sessionId
---@return UgErrorCode? errorCode
function UgCore.Sessions.Create(options) end

---Moves every member back to the shared world.
---
---Server only.
---@param sessionId integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Sessions.Destroy(sessionId) end

---Leaves the current session first. `Sessions:BeforeJoin` MAY cancel.
---
---Server only.
---@param source integer
---@param sessionId integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Sessions.Join(source, sessionId) end

---Back to the shared world. An empty session that is not persistent is destroyed.
---
---Server only.
---@param source integer
---@return boolean ok
---@return UgErrorCode? errorCode `not_found` when the player is in no session
function UgCore.Sessions.Leave(source) end

---Server only.
---@param sessionId integer
---@return UgSession?
function UgCore.Sessions.Get(sessionId) end

---Server only.
---@param sessionId integer
---@return integer[] sources of the members, none for unknown sessions
function UgCore.Sessions.GetMembers(sessionId) end

---Server only.
---@param source integer
---@return integer? sessionId
function UgCore.Sessions.GetSession(source) end
