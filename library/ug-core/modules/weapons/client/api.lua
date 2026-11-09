--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/weapons/client/api.lua.

---The equipped weapon of the local player. The server gives and takes it. The client applies the tint,
---which has no server native, and reports its ammo count so shots wear the weapon.
---Actions MUST run in a thread and return `ok, errorCode`.
---@class UgCore.Weapons
UgCore.Weapons = {}
