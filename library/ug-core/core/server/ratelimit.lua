--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/ratelimit.lua.

---Token bucket rate limiting. Every limiter is reset for a player on drop and pruned periodically.
---@class UgCore.RateLimit
UgCore.RateLimit = {}

---@class UgRateLimiter
---@field private max integer
---@field private per integer
---@field private tokens table<integer|string, number>
---@field private updated table<integer|string, integer>
local Limiter = {}

---Server only.
---@param options UgRateLimitOptions
---@return UgRateLimiter
function UgCore.RateLimit.Create(options) end

---Takes one token. When refused, `retryAfter` is the wait in ms until a token is available.
---
---Server only.
---@param key integer|string usually the player source
---@return boolean allowed
---@return integer retryAfter
function Limiter:Consume(key) end

---MUST run on player drop. ug-core does this for every limiter.
---
---Server only.
---@param key integer|string
function Limiter:Reset(key) end

---Drops buckets that are full again. Behavior is unchanged, since a missing bucket starts full.
---
---Server only.
---@return integer pruned
function Limiter:Prune() end

---Server only.
function Limiter:Clear() end
