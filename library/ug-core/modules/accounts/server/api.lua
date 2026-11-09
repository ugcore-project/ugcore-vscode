--[[

    ug-core - https://github.com/ugcore-project
    Copyright (C) 2026 UgCore Framework & Contributors
    Licensed under the GNU General Public License. See LICENSE for details.

]] --

---@meta

-- Generated from ug-core 1.0.0 by ugcore-vscode. Do not edit: run `npm run generate`. Source: modules/accounts/server/api.lua.

---Balances of loaded characters live in memory. Every change writes the balance and a ledger row in one transaction.
---Changes apply in memory first and revert when the write fails, so concurrent changes never spend the same money twice.
---Functions that change balances MUST run in a thread.
---@class UgCore.Accounts
UgCore.Accounts = {}

---@class UgLedgerEntry
---@field amount integer
---@field balanceAfter integer
---@field reason? string
---@field relatedCharacterId? integer
---@field createdAt integer Unix seconds

---Client: `GetBalance(account)`.
---@param source integer
---@param account string
---@return integer? balance nil when no character is loaded
---@overload fun(account: string): integer?
function UgCore.Accounts.GetBalance(source, account) end

---Client: `GetAll()`.
---@param source integer
---@return table<string, integer>? balances by account, nil when no character is loaded
---@overload fun(): table<string, integer>
function UgCore.Accounts.GetAll(source) end

---Server only.
---@param source integer
---@param account string
---@param amount integer
---@param reason? string stored in the ledger
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode
function UgCore.Accounts.Add(source, account, amount, reason) end

---Server only.
---@param source integer
---@param account string
---@param amount integer
---@param reason? string stored in the ledger
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode `insufficient_funds` unless the account allows negative balances
function UgCore.Accounts.Remove(source, account, amount, reason) end

---Sets an exact balance. The ledger records the difference.
---
---Server only.
---@param source integer
---@param account string
---@param balance integer
---@param reason? string stored in the ledger
---@return boolean ok
---@return integer? balance
---@return UgErrorCode? errorCode
function UgCore.Accounts.Set(source, account, balance, reason) end

---Moves money to another character, online or offline, in one transaction.
---
---Server only.
---@param source integer
---@param targetCharacterId integer
---@param account string
---@param amount integer
---@param reason? string stored in both ledgers
---@return boolean ok
---@return integer? balance of the sender
---@return UgErrorCode? errorCode
function UgCore.Accounts.Transfer(source, targetCharacterId, account, amount, reason) end

---Latest ledger entries of the loaded character, newest first.
---
---Server only.
---@param source integer
---@param account string
---@param limit? integer 1 to 100, defaults to 25
---@return boolean ok
---@return UgLedgerEntry[]? entries
---@return UgErrorCode? errorCode
function UgCore.Accounts.GetLedger(source, account, limit) end
