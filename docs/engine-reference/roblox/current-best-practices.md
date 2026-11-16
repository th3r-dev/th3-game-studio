# Roblox — Current Best Practices

Each item cites the page it was read from (2026-11-16). Anything not listed here
is a gap: read the Roblox docs (`create.roblox.com/docs/<page>.md`) or ask Studio's
MCP `http_get` tool, never memory.

## Scripts and where they run

- Scripts have a `RunContext`: `Legacy` (runs by its parent container, the
  default), `Server` or `Client`. Roblox recommends regular `Script`s with a
  `RunContext` over `LocalScript`s for client code. **[S]** scripting/scripts
- Scripts must sit in a container that runs them for their context (server,
  client, replicated). **[S]** scripting/scripts
- With Rojo, the file name decides the type: `*.server.luau` → Script,
  `*.client.luau` → LocalScript, other `*.luau` → ModuleScript; a folder with
  `init.server.luau` becomes that Script. **[J]** Rojo convention, not re-read
  this pin: check rojo.space/docs when it matters.

## Modules

- A `ModuleScript` returns exactly one value and runs once per Luau environment;
  later `require` calls return the same reference. **[S]** scripting/scripts
- Required from both server and client, a module gives each side its own copy.
  **[S]** scripting/scripts
- No circular requires: Studio errors `Requested module was required
  recursively`. **[S]** scripting/scripts
- Shared configuration belongs in a module, not in many `Configuration`/value
  objects. **[S]** scripting/scripts

## Project rules (this template)

- **The server owns state.** A client asks; the server checks and writes. Values a
  player can gain (currency, items, score) are never set from a client message.
  **[J]**
- **Rules without instances.** Game rules live in `src/shared/` modules that do
  not touch `game`, so `lune run tests/run` tests them headless. **[J]**
- **Files are the source.** With Rojo connected, edit `src/`, not Studio's copy:
  the next sync overwrites a Studio edit. **[J]**
- `--!strict` at the top of new modules. **[J]**
