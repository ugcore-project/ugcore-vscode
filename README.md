# UgCore IntelliSense

Types and snippets for [UgCore](https://github.com/ugcore-project), the FiveM framework. Write resources against `UgCore.*` with completion, hovers and type errors, and no setup.

- Every public function, enum, hook name and event name of ug-core, typed.
- `UgCore.Internal` is not in the types, like in the import proxy: using it is an error.
- Snippets for callbacks, net events, hooks, events, schemas, Guard checks and the manifest.

## Requirements

- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) by sumneko, installed with this extension.
- Recommended: [CfxLua IntelliSense](https://marketplace.visualstudio.com/items?itemName=overextended.cfxlua-vscode) for FiveM natives.

## How it works

The types are a LuaLS library generated from ug-core's source. On start, the extension adds it to your `Lua.workspace.library` setting:

- It appends one entry and keeps every other entry where it is, such as CfxLua's natives.
- The library lives in the extension's global storage, so the path stays the same across updates.
- With a `.code-workspace` file, the entry goes into the workspace file, like CfxLua does.

ug-core's own source declares the same types. When a workspace contains it, the library would declare everything twice and weaken type checking, so the extension turns the library off for that workspace only and tells you once.

### Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| `ugcore.typings` | `auto` | `auto`: on, except in ug-core's own source. `on`: always. `off`: removes the library entry. |

### Commands

- **UgCore: Apply typings** applies the setting again, for example after you edited `Lua.workspace.library` by hand.
- **UgCore: Show typings version** shows the ug-core version the types come from.

## Server and client

LuaLS cannot tell server files from client files. When ug-core defines a function on both sides with different arguments, such as `UgCore.Callback.Register`, the server form is the signature and the client form is an `---@overload`, so both type-check. Hovers say which side has what:

- `Client: Register(name, handler).` under the server form.
- `Server only.` or `Client only.` on functions that exist on one side.

## Snippets

| Prefix | Inserts |
| --- | --- |
| `ugmanifest` | An `fxmanifest.lua` with the import and `ugcore_version`. |
| `ugimport` | `shared_script '@ug-core/import.lua'`. |
| `ugcallback` | A server callback with a schema and a rate limit. |
| `ugnet` | A server net event with a schema and a rate limit. |
| `ugawait` | A client call to a server callback, with the error check. |
| `ugtrigger` | A client net event. |
| `ughook` | A hook, picked from the hook groups. |
| `ugon`, `ugemit` | An event handler, an event of your resource. |
| `ugready`, `ugawaitready` | Code that runs once ug-core is ready. |
| `ugschema`, `ugobject` | A schema, a strict object rule. |
| `ugnear` | A server-side distance check that flags `OutOfRange`. |
| `ugflag` | A Guard flag. |
| `ugplayer` | The player of `source`, or `not_loaded`. |
| `ugresult` | A call to a mutating function that passes its error code on. |
| `ugrate` | A rate limiter. |
| `uglog`, `ugversion`, `ugmodule` | Logger, version requirement, optional module check. |

Every Lua snippet is type-checked against the library in CI, with its default values.

## Uninstalling

Set `ugcore.typings` to `off` first. VS Code gives extensions no hook to clean settings on uninstall, so the library entry would stay in `Lua.workspace.library`, pointing at a removed folder.

## Development

```bash
npm install
npm run generate -- --core ../Base/resources/[ug]/ug-core
npm test
npm run check:types
npm run package
```

- `generate` rewrites `library/` from a ug-core checkout. CI regenerates it from a pinned ug-core and fails when the committed library differs.
- `check:types` runs lua-language-server 3.19.1 on `tests/luals/` and on every snippet. `positive/` MUST have no problems. Lines in `negative/` ending in `--! <code>` MUST raise that diagnostic.
- Press F5 in VS Code with this folder open to try the extension in an Extension Development Host.

## License

GPL-3.0-or-later, like ug-core: the library is generated from ug-core's source.
