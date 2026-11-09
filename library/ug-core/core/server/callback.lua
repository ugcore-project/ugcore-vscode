--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/server/callback.lua.

---Client-to-server callbacks, and server-to-client requests whose results are untrusted.
---Wire: request `__ugcb:<owner>:<name>` with `(callerResource, requestId, ...)`,
---response `__ugcb:res:<callerResource>` with `(requestId, ok, value)`.
---@class UgCore.Callback
UgCore.Callback = {}

---@class UgCallbackEntry : UgNetworkEntry
---@field handler fun(source: integer, ...: any): any

---@class UgPendingRequest
---@field source integer
---@field schema UgSchemaRule
---@field settle fun(ok: boolean, value: any, errorCode: UgErrorCode?)

---Registers `<resource>:<name>`. The handler gets `(source, ...)` with validated arguments and returns one value.
---
---Client: `Register(name, handler)`.
---@param name string
---@param options UgNetworkOptions
---@param handler fun(source: integer, ...: any): any
---@overload fun(name: string, handler: fun(...: any): any)
function UgCore.Callback.Register(name, options, handler) end

---Later requests get `not_found` and flag `UnknownCallback`.
---@param name string
---@return boolean removed
function UgCore.Callback.Unregister(name) end

---Asks a client. MUST run in a thread. The value is validated with `options.schema`.
---
---Client: `Await(name, ...)`.
---@param source integer
---@param name string full callback name, such as `ug-hud:GetSettings`
---@param options UgClientCallbackOptions
---@param ... any
---@return boolean ok
---@return any value
---@return UgErrorCode? errorCode
---@overload fun(name: string, ...: any): boolean, any, UgErrorCode?
function UgCore.Callback.Await(source, name, options, ...) end

---Callback form of Await. Runs in its own thread.
---
---Client: `Trigger(name, callback, ...)`.
---@param source integer
---@param name string
---@param options UgClientCallbackOptions
---@param callback fun(ok: boolean, value: any, errorCode: UgErrorCode?)
---@param ... any
---@overload fun(name: string, callback: fun(ok: boolean, value: any, errorCode: UgErrorCode?), ...: any)
function UgCore.Callback.Trigger(source, name, options, callback, ...) end
