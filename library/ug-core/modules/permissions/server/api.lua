--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/permissions/server/api.lua.

---Permissions granted per identifier, stored in `ug_permissions` and applied as ACEs on `identifier.<id>`.
---`Has` is a plain ACE check, so ACEs from server.cfg count too.
---@class UgCore.Permissions
UgCore.Permissions = {}

---Server only.
---@param source integer
---@param permission string
---@return boolean
function UgCore.Permissions.Has(source, permission) end

---Grants and applies the ACE right away. MUST run in a thread.
---
---Server only.
---@param target integer|string source or identifier
---@param permission string
---@param by? string who granted it, up to 64 characters
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Permissions.Grant(target, permission, by) end

---Revokes a permission granted with Grant. ACEs from server.cfg stay. MUST run in a thread.
---
---Server only.
---@param target integer|string source or identifier
---@param permission string
---@return boolean ok
---@return boolean? removed false when it was not granted
---@return UgErrorCode? errorCode
function UgCore.Permissions.Revoke(target, permission) end

---Permissions granted with Grant, sorted. ACEs from server.cfg are not listed.
---
---Server only.
---@param target integer|string source or identifier
---@return string[]
function UgCore.Permissions.GetAll(target) end
