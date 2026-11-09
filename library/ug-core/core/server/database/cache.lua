--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/database/cache.lua.

---@class UgCache
---@field private name string
---@field private writer fun(key: any, value: any): boolean
---@field private interval integer
---@field private lastFlush integer
---@field private entries table<any, any>
---@field private dirty table<any, boolean>
---@field private owners table<any, integer>
local Instance = {}

---The cached value itself, not a copy. Edit it in place, then call MarkDirty.
---
---Server only.
---@param key any
---@return any
function Instance:Get(key) end

---Stores a value already in the database, such as a row just loaded. It is not flushed.
---
---Server only.
---@param key any
---@param value any
---@param owner? integer player source whose drop evicts this entry
function Instance:Put(key, value, owner) end

---Stores a value and marks it dirty.
---
---Server only.
---@param key any
---@param value any
---@param owner? integer player source whose drop evicts this entry
function Instance:Set(key, value, owner) end

---Server only.
---@param key any
---@return boolean marked false when the key is not cached
function Instance:MarkDirty(key) end

---Server only.
---@param key any
---@return boolean
function Instance:IsDirty(key) end

---Server only.
---@private
---@param key any
---@return boolean ok
function Instance:writeEntry(key) end

---Writes dirty entries. Failed entries stay dirty and retry on the next flush.
---
---Server only.
---@param key? any one entry, every dirty entry when nil
---@return boolean ok false when any write failed
function Instance:Flush(key) end

---Flushes the entry, then removes it. A failed flush keeps it cached.
---
---Server only.
---@param key any
---@return boolean removed
function Instance:Evict(key) end

---Server only.
---@return UgCacheStats
function Instance:GetStats() end

---Server only.
---@param now integer
function Instance:FlushIfDue(now) end

---Server only.
---@param source integer
function Instance:EvictOwner(source) end
