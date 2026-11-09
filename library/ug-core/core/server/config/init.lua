--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/config/init.lua.

---@class UgConfigEntry
---@field name string
---@field definition UgConfigDefinition
---@field values table? resolved values, nil until loaded
---@field sources table<string, UgConfigSource>? per setting key, nil until loaded
