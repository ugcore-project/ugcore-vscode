--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/client/config.lua.

---Client and shared config values, replicated by the server. Every call returns a deep copy.
---@class UgCore.Config
UgCore.Config = {}

---@class UgReplicatedConfig
---@field kind 'settings'|'data'
---@field values table
