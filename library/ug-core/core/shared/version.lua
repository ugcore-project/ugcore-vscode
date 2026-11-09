--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/version.lua.

---ug-core's version, from its manifest. Resources check it to require a minimum version.
---@class UgCore.Version
UgCore.Version = {}

---@return string version such as `1.2.0`, `0.0.0` when the manifest has none
function UgCore.Version.Get() end

---@param minimum string such as `1.2.0`
---@return boolean
function UgCore.Version.IsAtLeast(minimum) end

---Raises when ug-core is older than `minimum`. Warns once when ug-core has a newer major version:
---breaking changes are MAJOR, so the calling resource MAY need an update.
---@param minimum string such as `1.2.0`
function UgCore.Version.Require(minimum) end
