--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: core/shared/schema.lua.

---Bounded validators for untrusted input. Failure details are for server logs only.
---@class UgCore.Schema
UgCore.Schema = {}

---@class UgSchemaRule
---@field package kind string
---@field package optional boolean
---@field package check fun(value: any): boolean, any, string?

---@class UgSchema
---@field package rules UgSchemaRule[]
---@field package count integer

---Strings count UTF-8 characters. Invalid UTF-8 and control characters are rejected.
---@param options UgSchemaStringOptions
---@return UgSchemaRule
function UgCore.Schema.String(options) end

---Rejects NaN and infinity.
---@param options? UgSchemaNumberOptions
---@return UgSchemaRule
function UgCore.Schema.Number(options) end

---Rejects NaN and infinity. Integral floats such as `5.0` become integers.
---@param options? UgSchemaNumberOptions
---@return UgSchemaRule
function UgCore.Schema.Integer(options) end

---@param options? UgSchemaBooleanOptions
---@return UgSchemaRule
function UgCore.Schema.Boolean(options) end

---@param options? UgSchemaVectorOptions
---@return UgSchemaRule
function UgCore.Schema.Vector2(options) end

---@param options? UgSchemaVectorOptions
---@return UgSchemaRule
function UgCore.Schema.Vector3(options) end

---@param options? UgSchemaVectorOptions
---@return UgSchemaRule
function UgCore.Schema.Vector4(options) end

---@param values (string|number|boolean)[]
---@param options? UgSchemaEnumOptions
---@return UgSchemaRule
function UgCore.Schema.Enum(values, options) end

---Rejects holes and non-integer keys. Tables past `max` entries are rejected without scanning the rest.
---@param item UgSchemaRule
---@param options UgSchemaArrayOptions
---@return UgSchemaRule
function UgCore.Schema.Array(item, options) end

---Tables past `max` entries are rejected without scanning the rest.
---@param key UgSchemaRule string, integer, number, enum or boolean rule
---@param value UgSchemaRule
---@param options UgSchemaMapOptions
---@return UgSchemaRule
function UgCore.Schema.Map(key, value, options) end

---Strict by default: unknown keys are rejected. With `strict = false` they are dropped.
---@param fields table<string, UgSchemaRule>
---@param options? UgSchemaObjectOptions
---@return UgSchemaRule
function UgCore.Schema.Object(fields, options) end

---Allows nil. Optional arguments MUST be trailing in `Define`.
---@param rule UgSchemaRule
---@return UgSchemaRule
function UgCore.Schema.Optional(rule) end

---@param rules UgSchemaRule[]
---@return UgSchema
function UgCore.Schema.Define(rules) end

---Validates call arguments. Trailing nils are tolerated, extra values are rejected.
---@param schema UgSchema
---@param ... any
---@return boolean ok
---@return UgSchemaArgs? args
---@return string? detail
function UgCore.Schema.Validate(schema, ...) end

---Validates a single value.
---@param rule UgSchemaRule
---@param value any
---@return boolean ok
---@return any value
---@return string? detail
function UgCore.Schema.Check(rule, value) end
