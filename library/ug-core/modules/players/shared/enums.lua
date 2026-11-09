--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/players/shared/enums.lua.

---@enum UgDeathState
UgCore.Enums.DeathState = {
    Alive = 'Alive',
    Downed = 'Downed',
    Dead = 'Dead',
}

---`Unknown` covers bones without a known region.
---@enum UgBodyRegion
UgCore.Enums.BodyRegion = {
    Head = 'Head',
    Neck = 'Neck',
    Torso = 'Torso',
    LeftArm = 'LeftArm',
    RightArm = 'RightArm',
    LeftLeg = 'LeftLeg',
    RightLeg = 'RightLeg',
    Unknown = 'Unknown',
}

---@enum UgDamageCategory
UgCore.Enums.DamageCategory = {
    Gunshot = 'Gunshot',
    Stab = 'Stab',
    Blunt = 'Blunt',
    Explosion = 'Explosion',
    Fire = 'Fire',
    Fall = 'Fall',
    Vehicle = 'Vehicle',
    Drowning = 'Drowning',
    Animal = 'Animal',
    Unknown = 'Unknown',
}
