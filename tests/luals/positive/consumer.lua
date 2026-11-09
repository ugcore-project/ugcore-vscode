-- A resource built on ug-core, written the way owners write it. MUST type-check with no problems.

UgCore.Version.Require('1.0.0')

local Errors = UgCore.Enums.Errors
local S = UgCore.Schema

local AMOUNT = S.Integer({ min = 1, max = 100000 })

-- Server: callback with the full options table.
UgCore.Callback.Register('Deposit', {
    schema = S.Define({ AMOUNT, S.Optional(S.String({ min = 1, max = 64 })) }),
    rate = { max = 3, per = 1000 },
    requirePlayer = true,
    requireAlive = true,
}, function(source, amount, note)
    if not UgCore.Guard.IsNear(source, vector3(150.0, -1040.0, 29.4), 3.0) then
        UgCore.Guard.Flag(source, UgCore.Enums.Violations.OutOfRange, 'bank')

        return Errors.NoPermission
    end

    local player = UgCore.Players.Get(source)

    if not player or not player:IsLoaded() then
        return Errors.NotLoaded
    end

    UgCore.Logger.Info('%s deposits %d (%s).', player.name, amount, note or '')

    return true
end)

-- Client: the overload without options.
UgCore.Callback.Register('GetSettings', function()
    return { volume = 0.5 }
end)

UgCore.Network.Register('Ping', {
    schema = S.Define({ S.Object({ id = S.Integer({ min = 1, max = 10 }), label = S.Optional(S.String({ max = 8 })) }) }),
    rate = { max = 1, per = 1000 },
}, function(source, payload)
    UgCore.Network.TriggerClient(source, 'consumer:Pong', payload.id)
end)

UgCore.Hooks.Register(UgCore.Enums.Hooks.Players.BeforeRevive, function(payload)
    return payload
end, { priority = 10 })

local handler = UgCore.Events.On(UgCore.Enums.Events.Players.Loaded, function(source)
    UgCore.Logger.Debug('Loaded %s', source)
end)

UgCore.Events.Off(handler)

UgCore.Lifecycle.On(UgCore.Enums.Lifecycle.Ready, function()
    ---@type UgLifecycleState
    local state = UgCore.Lifecycle.GetState()

    UgCore.Logger.Info('State %s, ready %s', state, tostring(UgCore.Lifecycle.IsReady()))
end)

CreateThread(function()
    if not UgCore.Lifecycle.Await(UgCore.Enums.Lifecycle.Ready, 30000) then
        return
    end

    local ok, value, errorCode = UgCore.Callback.Await('ug-banking:GetBalance', 'bank')

    if not ok then
        ---@type UgErrorCode?
        local code = errorCode

        print(code)
        return
    end

    print(value)
end)

local limiter = UgCore.RateLimit.Create({ max = 5, per = 1000 })
local allowed, retryAfter = limiter:Consume(1)

print(allowed, retryAfter)

---@type UgDeathState
local deathState = UgCore.Players.GetDeathState(1)

if deathState == UgCore.Enums.DeathState.Downed then
    local revived, reviveError = UgCore.Players.Revive(1, { clearInjuries = true })

    print(revived, reviveError)
end

if UgCore.Modules.IsEnabled('accounts') then
    print(UgCore.Enums.Events.Accounts)
end

local schemaOk, args, detail = S.Validate(S.Define({ AMOUNT }), 5)

print(schemaOk, args, detail)
