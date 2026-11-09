--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/enums/violations.lua.

---@enum UgViolation
UgCore.Enums.Violations = {
    InvalidPayload = 'InvalidPayload',
    RateLimited = 'RateLimited',
    ConcurrencyExceeded = 'ConcurrencyExceeded',
    UnknownCallback = 'UnknownCallback',
    NotLoaded = 'NotLoaded',
    NoPermission = 'NoPermission',
    OutOfRange = 'OutOfRange',
    InvalidDeathState = 'InvalidDeathState',
    WeaponMismatch = 'WeaponMismatch',
}

---Guard score added per flag. Every violation MUST have a weight.
---@type table<UgViolation, integer>
UgCore.Enums.ViolationWeights = {
    [UgCore.Enums.Violations.InvalidPayload] = 5,
    [UgCore.Enums.Violations.RateLimited] = 1,
    [UgCore.Enums.Violations.ConcurrencyExceeded] = 2,
    [UgCore.Enums.Violations.UnknownCallback] = 3,
    [UgCore.Enums.Violations.NotLoaded] = 2,
    [UgCore.Enums.Violations.NoPermission] = 3,
    [UgCore.Enums.Violations.OutOfRange] = 5,
    [UgCore.Enums.Violations.InvalidDeathState] = 5,
    [UgCore.Enums.Violations.WeaponMismatch] = 5,
}

---Guard actions, mildest first. `Guard:BeforeAction` hooks MAY pick a milder one.
---@enum UgGuardAction
UgCore.Enums.GuardActions = {
    Warn = 'warn',
    Kick = 'kick',
    Ban = 'ban',
}
