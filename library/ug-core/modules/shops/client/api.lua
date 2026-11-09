--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/shops/client/api.lua.

---Shop positions for blips and markers, and the requests a shop UI makes. Prices always come from the server.
---Actions MUST run in a thread.
---@class UgCore.Shops
UgCore.Shops = {}

---What the shop sells now. Refused out of range or without access.
---
---Client only.
---@param name string
---@return boolean ok
---@return UgErrorCode? errorCode
---@return UgShopListing? listing
function UgCore.Shops.Open(name) end
