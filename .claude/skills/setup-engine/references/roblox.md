# /setup-engine — Roblox (Roblox Studio, Luau, Rojo)

> Part of `/setup-engine`. `SKILL.md` names when to read this file; the settings it
> resolved and the rules under its later headings still apply here.

Read when the engine is **Roblox** (`/setup-engine roblox`). For Roblox it replaces
Sections 3, 6, 7 and 7.5 and gives the values Sections 4, 5 and 5.5 write;
Sections 8, 9 and 12 still apply. Never load `godot-language-config.md`.

**In this file:** R1 An existing Roblox project · R2 Studio, Rokit and the versions ·
R3 The values to write · R4 The reference docs · R5 The scaffold · R6 Build, test
and look · R7 The Studio MCP server · R8 The specialist agent

Roblox is two halves (`docs/engine-reference/roblox/VERSION.md`):

- **Roblox Studio**, the editor and the only place a game runs and publishes. It
  updates itself and has no version to pin. Installing it and signing in are the
  person's to do: never script a download or a sign-in.
- **The file toolchain**, pinned in `rokit.toml`: Rojo (syncs `src/` into Studio and
  builds a place file), Selene (lint), StyLua (format) and Lune (runs the pure-Luau
  tests headless). The code lives in files under git; Studio reads it through Rojo.

`engine.version` is **Rojo's** version, as Web's is Vite's.

## R1. An existing Roblox project

A `default.project.json` (Rojo) at the project root means an existing project:
record it as it is and **change no file of the game**. R1 replaces R2 to R5 for it
(R6 to R8, and Sections 8 and 12, still apply).

1. Read `default.project.json`: the folders its `$path` entries name. The one
   mapped under `ServerScriptService` or holding `*.server.luau` / `*.server.lua`
   is the code root's server half; `engine.code_root` is their common parent
   (usually `src`). Ask when it is not plain.
2. Read `rokit.toml`, `aftman.toml` or `foreman.toml`, whichever is there, for the
   pinned Rojo version (`engine.version`) and which of Selene, StyLua and Lune it
   has. Aftman and Foreman are older managers: record them, never migrate unasked.
3. No `tests/run.luau`: the checks that run tests read `NOT ASSESSED — no tests`
   until the project has a test command. Say so, and offer the scaffold's runner
   as its own change (copy `tests/run.luau` only, on a yes).
4. Show the record and confirm it before writing (Sections 4, 5 and 5.5, with
   R3's shape and the project's values).

A place kept only in Studio (no files) is not a Rojo project yet. Say so: either
start the files with R5 next to it, or keep working in Studio alone through R7,
in which case nothing in `src/` is the game and the code checks read NOT ASSESSED.

## R2. Studio, Rokit and the versions (Section 3)

Probe, reading only: `command -v rokit rojo selene stylua lune` and, on macOS,
`/Applications/RobloxStudio.app` (`%LOCALAPPDATA%\Roblox\Versions` on Windows).
`bash .claude/scripts/roblox-scaffold.sh --dry-run` prints all of it (`tool` and
`studio` rows).

- **No Studio:** say it plainly and go on (the files and the tests do not need
  it): "Roblox Studio is free for Windows and macOS: create.roblox.com → Start
  creating. Install it, sign in, and open it once before R7."
- **No Rokit:** name the official install (github.com/rojo-rbx/rokit, "Installation")
  and stop that step. Never pipe an install script into a shell yourself.

The pins are `.claude/engines/roblox/scaffold/rokit.toml`'s, which
`VERSION.md`'s table must match. Never look up "latest" and never change one here.

## R3. The values to write (Sections 4, 5 and 5.5)

**CLAUDE.md** (Section 4), with the import line set to
`@docs/engine-reference/roblox/VERSION.md`:

```markdown
- **Engine**: Roblox Studio (evergreen), files synced with Rojo 7.7.1
- **Language**: Luau (`--!strict` in new modules)
- **Build System**: Rojo — `rojo serve` while working in Studio, `rojo build -o build/game.rbxl` for a place file
- **Asset Pipeline**: Roblox asset ids (uploaded in Studio or Creator Hub), each recorded in `assets/provenance.yaml`
```

**technical-preferences.md** (Section 5): Engine Roblox, language Luau, and the
Roblox style's naming: modules, classes and services PascalCase (`Rules`,
`CoinService`); functions and variables camelCase (`newState`); constants
SCREAMING_SNAKE (`MAX_COINS`); files named as the instance they become
(`Rules.luau`, `init.server.luau`). Specialist rows: Primary `roblox-specialist`.

**`project.yaml`** (Section 5.5), the four blocks:

```yaml
engine:
  name: "Roblox"
  version: "7.7.1"
  language: "Luau"
  rendering: "Roblox Studio"
  physics: "Roblox"

specialists:
  code: "roblox-specialist"
  shader: "technical-artist"
  ui: "roblox-specialist"
  additional: []

naming:
  classes: PascalCase
  variables: camelCase
  constants: SCREAMING_SNAKE
  signals: PascalCase
  files: PascalCase
  scenes: PascalCase

commands:
  build: "rojo build -o build/game.rbxl"
  test: "lune run tests/run"
  run: "rojo serve"
```

- `Roblox` with the capital: the check is case-sensitive.
- No `engine.code_root`: `src` comes from the engine table
  (`.claude/engines/engines.tsv`), and so do the commands.
- `run` is Rojo's live sync server, for the person to work in Studio while it
  runs. It never exits, so no check runs it.
- No `smoke`: a smoke run is a Studio playtest (R7), not a command.

## R4. The reference docs (Sections 6 and 7)

The knowledge gap is **HIGH** for the toolchain and for Studio's AI features
(`VERSION.md`, "Post-Cutoff Version Timeline"). The reference ships in
`docs/engine-reference/roblox/`: compare its pinned table with the scaffold's
`rokit.toml`; when they differ, stop and name each tool that differs. Engine API
questions go to the Roblox docs (`create.roblox.com/docs`, each page also at
`<url>.md`), or through R7's `http_get` tool, never to memory.

## R5. The scaffold (Section 7.5)

1. Show what would be made:
   `bash .claude/scripts/roblox-scaffold.sh --dry-run --title "<the game's name>"`
   — the brief's working title, else the project folder's name. Each
   `WOULD_CREATE` row is a file; each `gitignore … missing` row is a line the
   project's `.gitignore` lacks.
2. Ask: "May I create these files and add the missing lines to `.gitignore`?"
   On a yes, run it again without `--dry-run`, with `--gitignore`. It never
   overwrites a file. A `refused` row is R1's case.
3. Show `rokit install` and ask before running it: it downloads the four pinned
   tools from GitHub releases into Rokit's own folder and needs the network.
   Declined or offline: the files are there, and the build, lint and tests wait
   for it.

What the scaffold is: one coin above the spawn that pays a coin when touched,
counted by the **server** in `leaderstats`, with a client HUD that only shows it.
The rules (`src/shared/Rules.luau`) hold no Roblox instance, so Lune tests them.

## R6. Build, test and look

After `rokit install`, run each and report its command, exit code and result:

1. `rojo build -o build/game.rbxl`: the place file. A failure names the
   `default.project.json` path it could not read.
2. `selene src` and `stylua --check src tests`: report what each prints; neither
   fixes anything unasked.
3. `bash .claude/scripts/test-run.sh roblox`: Lune on `tests/run.luau`
   (`rule` row: `roblox:pass`, `roblox:failed`, `roblox:zero-tests`, …).
4. **Look:** open Studio, then `rojo serve` and connect the Rojo plugin (Studio →
   Plugins → Rojo → Connect). Without R7 this is the person's step: ask them to
   press Play and say whether the coin pays and the HUD counts. With R7, step 4
   of R7 does it.

`/test-setup` and `/smoke-check` read Roblox from the engine table; a Studio
playtest is the smoke check, by hand or through R7.

## R7. The Studio MCP server

Roblox Studio has its own MCP server built in (create.roblox.com/docs/studio/mcp,
read 2026-11-16). It lets an AI client read the place's tree, edit scripts, run
Luau in Edit, Server or Client, start and stop a playtest, drive the character,
read the output log and capture the viewport. It works with any client that
speaks MCP over stdio: Claude Code, Codex CLI, Gemini CLI, Cursor, VS Code and
others.

1. **In Studio** (the person's step): Assistant → `…` → Manage MCP Servers → turn
   on **Enable Studio as MCP server**. Studio's Quick connect then lists the
   clients it found and wires each with one switch.
2. **Or by config**, for a client Quick connect does not list. The server is a
   binary inside Studio: `/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`
   on macOS, `cmd.exe /c %LOCALAPPDATA%\Roblox\mcp.bat` on Windows. For Claude
   Code, show and ask before running:
   `claude mcp add Roblox_Studio -- /Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`.
   Never write a client's global config unasked.
3. **Check:** Studio shows a green dot with the number of connected clients;
   in the client, `list_roblox_studios` returns the open place. Every tool call
   names its `studio_id`.
4. **Playtest loop** (the smoke check): `start_stop_play` → `character_navigation`
   to the coin → `get_console_output` and `screen_capture` → `start_stop_play`
   again. Report what the output and the capture show; never call a playtest a
   pass from the script alone.

The MCP server can change the open place: it is the same trust as handing someone
the keyboard. Code still lives in `src/`: with Rojo connected, edit the files,
not the scripts in Studio, or the next sync overwrites the Studio edit.

## R8. The specialist agent (Section 9)

Roblox has one engine specialist, `roblox-specialist`. Section 9's Version
Awareness section is already in it; check it is there and say so in one line.
