--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/permissions/server/groups.lua.

---@class UgGroupDefinition
---@field label string
---@field weight integer higher outranks lower
---@field inherits? string group whose permissions this group also has
---@field permissions string[]

---@class UgGroupSummary
---@field name string
---@field label string
---@field weight integer
---@field inherits? string
---@field members integer

---Adds the target to a group from config/permissions.lua and applies it right away. MUST run in a thread.
---
---Server only.
---@param target integer|string source or identifier
---@param group string
---@param by? string who added it, up to 64 characters
---@return boolean ok
---@return UgErrorCode? errorCode `invalid_args` for groups missing from config, `no_permission` when a hook cancelled
function UgCore.Permissions.AddGroup(target, group, by) end

---Removes the target from a group. Also removes stored memberships of groups no longer in config. MUST run in a thread.
---
---Server only.
---@param target integer|string source or identifier
---@param group string
---@return boolean ok
---@return boolean? removed false when the target was not a member
---@return UgErrorCode? errorCode
function UgCore.Permissions.RemoveGroup(target, group) end

---Groups of the target from config/permissions.lua, highest weight first. Inherited groups are not listed.
---
---Server only.
---@param target integer|string source or identifier
---@return string[]
function UgCore.Permissions.GetGroups(target) end

---True when the target is in the group, directly or through inheritance: a founder is also an admin.
---Only groups managed by ug-core count, not principals from server.cfg.
---
---Server only.
---@param target integer|string source or identifier
---@param group string
---@return boolean
function UgCore.Permissions.IsInGroup(target, group) end

---Highest weight of the target's groups, 0 without groups.
---
---Server only.
---@param target integer|string source or identifier
---@return integer
function UgCore.Permissions.GetWeight(target) end

---True when `actor` outranks `target`: a strictly higher weight. The console (source 0) outranks everyone.
---
---Server only.
---@param actor integer|string source, identifier or 0 for the console
---@param target integer|string source or identifier
---@return boolean
function UgCore.Permissions.CanTarget(actor, target) end

---Server only.
---@param group string
---@return UgGroupDefinition? definition a copy, nil for groups missing from config
function UgCore.Permissions.GetGroupDefinition(group) end
