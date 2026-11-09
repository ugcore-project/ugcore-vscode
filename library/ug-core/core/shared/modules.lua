--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/modules.lua.

---Enabled modules, in load order. Empty until the module loader runs.
---@class UgCore.Modules
UgCore.Modules = {}

---@param name string
---@return boolean
function UgCore.Modules.IsEnabled(name) end

---@return string[] names in load order
function UgCore.Modules.GetEnabled() end

---Raises when `name` is not enabled. For code that cannot adapt to a missing module.
---@param name string
function UgCore.Modules.Require(name) end
