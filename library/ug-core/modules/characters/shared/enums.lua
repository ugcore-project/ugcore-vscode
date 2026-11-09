--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/characters/shared/enums.lua.

---@enum UgCharactersEvent
UgCore.Enums.Events.Characters = {
    Created = 'ug-core:Characters:Created',
    Deleted = 'ug-core:Characters:Deleted',
    Loaded = 'ug-core:Characters:Loaded',
    Unloaded = 'ug-core:Characters:Unloaded',
}

---@enum UgCharactersHook
UgCore.Enums.Hooks.Characters = {
    BeforeCreate = 'Characters:BeforeCreate',
    BeforeDelete = 'Characters:BeforeDelete',
}
