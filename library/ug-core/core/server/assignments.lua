--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/assignments.lua.

---@class UgAssignmentGrade
---@field name string
---@field label string
---@field salary integer
---@field boss? boolean

---@class UgAssignmentDefinition
---@field label string
---@field grades UgAssignmentGrade[]
---@field defaultDuty? boolean

---@class UgAssignment
---@field name string
---@field label string
---@field grade integer
---@field gradeName string
---@field gradeLabel string
---@field salary integer
---@field boss boolean
---@field onDuty? boolean only with duty

---@class UgAssignmentSpec
---@field namespace string such as `Jobs`, for errors
---@field config string data config name
---@field table string SQL table with `character_id`, `name`, `grade`
---@field statebag string such as `ug-core:Job`
---@field default string definition every character falls back to
---@field duty boolean
---@field changed string event emitted with `(source, assignment, previous)`
---@field dutyChanged? string event emitted with `(source, onDuty)`
---@field beforeSet string hook with `{ source, name, grade }`
