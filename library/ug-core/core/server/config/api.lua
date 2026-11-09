--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/config/api.lua.

---Resolved config values. Every call returns a deep copy.
---@class UgCore.Config
UgCore.Config = {}

---Without `key`, returns the whole config. For data configs, `key` is an entry id and MAY be missing.
---@param name string
---@param key? string
---@return any
function UgCore.Config.Get(name, key) end
