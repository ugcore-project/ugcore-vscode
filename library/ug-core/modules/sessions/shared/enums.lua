--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/sessions/shared/enums.lua.

---@enum UgSessionsEvent
UgCore.Enums.Events.Sessions = {
    Created = 'ug-core:Sessions:Created',
    Destroyed = 'ug-core:Sessions:Destroyed',
    Joined = 'ug-core:Sessions:Joined',
    Left = 'ug-core:Sessions:Left',
}

---@enum UgSessionsHook
UgCore.Enums.Hooks.Sessions = {
    BeforeJoin = 'Sessions:BeforeJoin',
}
