--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/permissions/shared/enums.lua.

---@enum UgPermissionsEvent
UgCore.Enums.Events.Permissions = {
    GroupAdded = 'ug-core:Permissions:GroupAdded',
    GroupRemoved = 'ug-core:Permissions:GroupRemoved',
}

---@enum UgPermissionsHook
UgCore.Enums.Hooks.Permissions = {
    BeforeGroupAdd = 'Permissions:BeforeGroupAdd',
    BeforeGroupRemove = 'Permissions:BeforeGroupRemove',
}
