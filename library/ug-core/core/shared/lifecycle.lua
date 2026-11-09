--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/lifecycle.lua.

---Boot state of ug-core. States only move forward. A skipped state is never reached.
---@class UgCore.Lifecycle
UgCore.Lifecycle = {}

---@class UgLifecycleEntry
---@field state UgLifecycleState
---@field at integer GetGameTimer value in ms
---@field elapsed integer ms spent in the previous state

---@return UgLifecycleState
function UgCore.Lifecycle.GetState() end

---@return boolean
function UgCore.Lifecycle.IsReady() end

---False for states not reached yet and for skipped states.
---@param state UgLifecycleState
---@return boolean
function UgCore.Lifecycle.HasReached(state) end

---Sticky: runs immediately when `state` was already reached. Never runs when `state` was skipped.
---@param state UgLifecycleState
---@param handler fun()
function UgCore.Lifecycle.On(state, handler) end

---Blocks the current thread until `state` is reached.
---@param state UgLifecycleState
---@param timeout? integer ms, waits forever when nil
---@return boolean reached false on timeout or when `state` was skipped
function UgCore.Lifecycle.Await(state, timeout) end
