--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/locale/shared/api.lua.

---Core messages from `locales/<core.locale>.json`, with English for missing keys. Keys are dotted paths.
---Placeholders are `{name}`.
---@class UgCore.Locale
UgCore.Locale = {}

---@param key string such as `identity.banned`
---@param vars? table<string, any> values for `{name}` placeholders
---@return string text the key itself when no locale has it
function UgCore.Locale.Get(key, vars) end

---@return string code such as `en`
function UgCore.Locale.GetCode() end
