--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/gangs/server/api.lua.

---One gang per character, from config/gangs.lua. The current gang replicates in the `ug-core:Gang` statebag.
---@class UgCore.Gangs
UgCore.Gangs = {}

---Client: `Get()`.
---@param source integer
---@return UgAssignment? nil without a loaded character
---@overload fun(): UgAssignment?
function UgCore.Gangs.Get(source) end

---MUST run in a thread. Unknown gangs and grades return `invalid_args`.
---
---Server only.
---@param source integer
---@param name string
---@param grade? integer defaults to 1
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Gangs.Set(source, name, grade) end

---MUST run in a thread.
---
---Server only.
---@param source integer
---@param grade integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Gangs.SetGrade(source, grade) end

---Server only.
---@param name string
---@param grade? integer
---@return boolean
function UgCore.Gangs.Exists(name, grade) end

---Server only.
---@param name string
---@return UgAssignmentDefinition?
function UgCore.Gangs.GetDefinition(name) end
