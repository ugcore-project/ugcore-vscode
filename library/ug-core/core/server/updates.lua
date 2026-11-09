--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/updates.lua.

---@alias UgUpdateStatus 'latest'|'outdated'|'ahead'|'unknown'|'disabled'

---@class UgUpdateResult
---@field status UgUpdateStatus
---@field current string
---@field latest? string latest release version, without the `v` prefix
---@field url? string release page of the latest version
