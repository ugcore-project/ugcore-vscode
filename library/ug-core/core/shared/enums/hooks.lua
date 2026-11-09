--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/enums/hooks.lua.

---Module groups are declared in their module's shared/enums.lua.
---@alias UgHookName UgPlayersHook|UgGuardHook|UgCharactersHook|UgAccountsHook|UgJobsHook|UgGangsHook|UgSessionsHook|UgPermissionsHook|UgItemsHook|UgInventoryHook|UgWeaponsHook|UgShopsHook

---@enum UgPlayersHook
UgCore.Enums.Hooks.Players = {
    BeforeDown = 'Players:BeforeDown',
    BeforeBleedout = 'Players:BeforeBleedout',
    BeforeRespawn = 'Players:BeforeRespawn',
    BeforeRevive = 'Players:BeforeRevive',
}

---@enum UgGuardHook
UgCore.Enums.Hooks.Guard = {
    BeforeAction = 'Guard:BeforeAction',
}
