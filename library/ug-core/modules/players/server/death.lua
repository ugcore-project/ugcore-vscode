--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/players/server/death.lua.

---@class UgDeathRecord
---@field state UgDeathState
---@field injuries table<string, UgInjury>
---@field cause? UgCauseOfDeath
---@field token integer increments on every transition, so stale timers do nothing
---@field position? vector3 where the player went down
---@field flagged boolean

---@class UgRecentHit
---@field attacker integer
---@field weapon integer
---@field at integer

---Server only.
---@param source integer
---@return UgDeathState
function UgCore.Players.GetDeathState(source) end

---Server only.
---@param source integer
---@return boolean
function UgCore.Players.IsDead(source) end

---Server only.
---@param source integer
---@return boolean
function UgCore.Players.IsDowned(source) end

---Server only.
---@param source integer
---@return UgInjury[]
function UgCore.Players.GetInjuries(source) end

---Server only.
---@param source integer
---@return UgCauseOfDeath?
function UgCore.Players.GetCauseOfDeath(source) end

---Server only.
---@param source integer
---@param region? UgBodyRegion every region when nil
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Players.ClearInjuries(source, region) end

---Alive to Downed. `Players:BeforeDown` MAY cancel.
---
---Server only.
---@param source integer
---@param cause? UgCauseOfDeath
---@return boolean ok
---@return UgErrorCode? errorCode `not_found`, `invalid_args` from another state, `no_permission` when a hook cancelled
function UgCore.Players.Down(source, cause) end

---Alive or Downed to Dead.
---
---Server only.
---@param source integer
---@param cause? UgCauseOfDeath
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Players.Kill(source, cause) end

---Downed or Dead to Alive, in place. `Players:BeforeRevive` MAY cancel.
---
---Server only.
---@param source integer
---@param options? UgReviveOptions
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Players.Revive(source, options) end

---Downed or Dead to Alive at `coords`, or `respawn.coords` from config. Clears injuries. `Players:BeforeRespawn` MAY cancel.
---
---Server only.
---@param source integer
---@param coords? vector4
---@return boolean ok
---@return UgErrorCode? errorCode
function UgCore.Players.Respawn(source, coords) end
