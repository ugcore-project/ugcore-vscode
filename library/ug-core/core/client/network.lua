--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/client/network.lua.

---Server-to-client net events. Clients only receive net events from the server.
---@class UgCore.Network
UgCore.Network = {}

---The server validates and rate limits every event.
---
---Client only.
---@param name string full event name, such as `myresource:Deposit`
---@param ... any
function UgCore.Network.TriggerServer(name, ...) end
