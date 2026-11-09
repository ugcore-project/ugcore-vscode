--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/client/callback.lua.

---Calls server callbacks, and answers server requests.
---Wire: request `__ugcb:<owner>:<name>` with `(callerResource, requestId, ...)`,
---response `__ugcb:res:<callerResource>` with `(requestId, ok, value)`.
---@class UgCore.Callback
UgCore.Callback = {}
