--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/jobs/server/api.lua.

---One job per character, from config/jobs.lua. The current job replicates in the `ug-core:Job` statebag.
---@class UgCore.Jobs
UgCore.Jobs = {}

---Client: `Get()`.
---@param source integer
---@return UgAssignment? nil without a loaded character
---@overload fun(): UgAssignment?
function UgCore.Jobs.Get(source) end

---MUST run in a thread. Unknown jobs and grades return `invalid_args`.
---
---Server only.
---@param source integer
---@param name string
---@param grade? integer defaults to 1
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Jobs.Set(source, name, grade) end

---MUST run in a thread.
---
---Server only.
---@param source integer
---@param grade integer
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Jobs.SetGrade(source, grade) end

---Server only.
---@param source integer
---@param onDuty boolean
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Jobs.SetDuty(source, onDuty) end

---Client: `IsOnDuty()`.
---@param source integer
---@return boolean
---@overload fun(): boolean
function UgCore.Jobs.IsOnDuty(source) end

---Server only.
---@param name string
---@param grade? integer
---@return boolean
function UgCore.Jobs.Exists(name, grade) end

---Server only.
---@param name string
---@return UgAssignmentDefinition?
function UgCore.Jobs.GetDefinition(name) end
