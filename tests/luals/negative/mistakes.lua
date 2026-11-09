-- Mistakes the typings MUST catch. Each line ending in `--! <code>` MUST raise that diagnostic.

local _ = UgCore.Internal --! undefined-field

UgCore.Playres.Get(1) --! undefined-field

local _ = UgCore.Enums.Errors.NotAnError --! undefined-field

UgCore.Guard.IsNear('one', vector3(0.0, 0.0, 0.0), 3.0) --! param-type-mismatch

UgCore.Guard.Flag(1, 'NotAViolation') --! param-type-mismatch

local _ = UgCore.Schema.String({ min = 1 }) --! missing-fields

local _ = UgCore.RateLimit.Create({ max = 5 }) --! missing-fields

UgCore.Events.Off() --! missing-parameter

UgCore.Lifecycle.Await('ready') --! param-type-mismatch
