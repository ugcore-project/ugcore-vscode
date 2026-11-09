--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/accounts/shared/enums.lua.

---@enum UgAccountsEvent
UgCore.Enums.Events.Accounts = {
    Changed = 'ug-core:Accounts:Changed',
}

---@enum UgAccountsHook
UgCore.Enums.Hooks.Accounts = {
    BeforeAdd = 'Accounts:BeforeAdd',
    BeforeRemove = 'Accounts:BeforeRemove',
    BeforeTransfer = 'Accounts:BeforeTransfer',
}
