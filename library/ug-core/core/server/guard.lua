--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/guard.lua.

---Scores suspicious behavior per player and acts on thresholds from config/guard.lua.
---Detail stays in server logs. Kick and ban messages are generic.
---@class UgCore.Guard
UgCore.Guard = {}

---@class UgGuardState
---@field score number
---@field updated integer
---@field warned boolean
---@field flags UgGuardFlag[]

---Reports a violation. Resources MUST use it for their own checks.
---
---Server only.
---@param source integer
---@param violation UgViolation
---@param detail? string server logs only
function UgCore.Guard.Flag(source, violation, detail) end

---Server only.
---@param source integer
---@return number score after decay, 0 for unknown players
function UgCore.Guard.GetScore(source) end

---Reads the ped position on the server (OneSync). Client-sent coordinates are never trusted.
---
---Server only.
---@param source integer
---@param coords vector3
---@param maxDistance number
---@return boolean
function UgCore.Guard.IsNear(source, coords, maxDistance) end
