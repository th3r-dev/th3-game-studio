# Engine table

`engines.tsv` holds one row per engine `engine.name` can name: Godot, Unity,
Unreal, Web and Roblox. The hooks, helpers and skills read it instead of keeping their
own copy of each engine's folders.

| Column | What it is | Read by |
|---|---|---|
| `engine` | The `engine.name` value. Matched in any case; any name starting with "unreal" is the Unreal row | every reader |
| `code_root` | Where the game's code lives, unless `engine.code_root` says otherwise | `resolve_code_root` (`yaml-helper.sh`), `project-state.sh`, `write-guard.sh`, `content-count.sh` |
| `test_root` | Where the tests live, unless `engine.test_root` says otherwise | `resolve_test_root` (`yaml-helper.sh`) |
| `asset_root` | Where the assets live | `asset-scan.sh`, `content-count.sh` |
| `run`, `build`, `test`, `smoke` | The default commands. `-` where the command needs something only `/setup-engine` can ask for (the editor's path, a build target) | `test-run.sh` (`test`, when `commands.test` is unset) |

Skills read a row with `resolve_config --keys engine_row`. The files listed above
read the table through one reader, `.claude/scripts/engine-row.awk`.
`test-scaffold.sh` does not read it: it writes its own copy of each engine's test
paths, so a change to `test_root` here must also be made there.

**Format.** Tab-separated, LF line ends, a header row first. A `-` is an empty
cell; no cell is left blank. Read it with `awk -F'\t'`: a bash `IFS` read merges
empty fields.

## `web/`

The files a new web project starts from. `scaffold/` holds every file
`/setup-engine web` copies into the project root, through
`.claude/scripts/web-scaffold.sh` (which never overwrites a file); its
`playwright.config.ts` is also the one `/test-setup` writes
(`test-scaffold.sh web`). `web/README.md` says what each file is for.

## `roblox/`

The files a new Roblox project starts from. `scaffold/` holds every file
`/setup-engine roblox` copies into the project root, through
`.claude/scripts/roblox-scaffold.sh` (which never overwrites a file).

| File | What it is for |
|---|---|
| `default.project.json` | Rojo's map: `src/shared` → ReplicatedStorage.Shared, `src/server` → ServerScriptService.Server, `src/client` → StarterPlayerScripts.Client. `@TITLE@` becomes the game's name |
| `rokit.toml` | The pinned toolchain: Rojo, Selene, StyLua, Lune (`docs/engine-reference/roblox/VERSION.md`) |
| `src/shared/Wallet.luau`, `Pickup.luau` | Typed classes with no Roblox instance in them, so Lune tests them headless |
| `src/shared/PickupFactory.luau` | The one place pickups are made, from a frozen table of definitions |
| `src/server/PickupSpawner.luau` | Puts a pickup in the world as a Part; owns its connections, `destroy()` removes them |
| `src/server/init.server.luau` | The only server Script: a wallet per player, `leaderstats`, two spawners |
| `src/client/init.client.luau` | The client: a HUD that only shows the count |
| `tests/run.luau` | The Lune test runner and the rules' tests; its output is what `test-run.sh roblox` reads |
| `selene.toml`, `stylua.toml` | Lint with Roblox's globals; format |
| `assets/provenance.yaml` | Where each asset came from: a file or a Roblox asset id |
| `.gitignore` | Rojo's build output and lock files |
