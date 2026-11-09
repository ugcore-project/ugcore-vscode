--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/logger.lua.

---Messages with extra arguments are formatted with `string.format`.
---@class UgCore.Logger
UgCore.Logger = {}

---Printed only when debug is enabled.
---@param message any
---@param ... any
function UgCore.Logger.Debug(message, ...) end

---@param message any
---@param ... any
function UgCore.Logger.Info(message, ...) end

---@param message any
---@param ... any
function UgCore.Logger.Warn(message, ...) end

---@param message any
---@param ... any
function UgCore.Logger.Error(message, ...) end
