--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/enums/errors.lua.

---Codes returned by mutating functions as `ok, errorCode`. The only failure detail clients ever receive.
---@enum UgErrorCode
UgCore.Enums.Errors = {
    InvalidArgs = 'invalid_args',
    NotFound = 'not_found',
    NotLoaded = 'not_loaded',
    RateLimited = 'rate_limited',
    NoPermission = 'no_permission',
    InsufficientFunds = 'insufficient_funds',
    InsufficientItems = 'insufficient_items',
    CannotCarry = 'cannot_carry',
    Timeout = 'timeout',
    InternalError = 'internal_error',
}
