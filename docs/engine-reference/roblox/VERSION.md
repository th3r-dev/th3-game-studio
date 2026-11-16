# Roblox — Version Reference

`engine.name: Roblox` is Roblox Studio plus a file toolchain. Studio updates
itself and cannot be pinned; the toolchain is pinned in the scaffold's
`rokit.toml`, and `engine.version` is Rojo's.

| Field | Value |
|-------|-------|
| **Engine** | Roblox Studio (evergreen) + Rojo, Selene, StyLua, Lune |
| **Engine Version** | Rojo 7.7.1 |
| **Installed at pin time** | PER PROJECT — `rokit install` installs `rokit.toml`'s pins; `rojo --version` reads it |
| **Project Pinned** | 2026-11-16 |
| **Last Docs Verified** | 2026-11-16 (every page in this folder) |
| **LLM Knowledge Cutoff** | May 2025 |

## Pinned versions

Each published at least two weeks before the pin date. The scaffold's
`rokit.toml` (`.claude/engines/roblox/scaffold/`) pins exactly these; when one
changes here, it changes there.

| Tool | Pinned | Published | What it does here |
|------|--------|-----------|-------------------|
| `rojo-rbx/rojo` | 7.7.1 | 2026-10-02 | `rojo serve` syncs `src/` into Studio; `rojo build` writes a place file |
| `Kampfkarren/selene` | 0.32.0 | 2026-10-01 | `selene src` — lint with Roblox's globals |
| `JohnnyMorganz/StyLua` | 2.6.0 | 2026-10-10 | `stylua --check src tests` — format |
| `lune-org/lune` | 0.11.1 | 2026-10-21 | `lune run tests/run` — the pure-Luau tests, headless |
| `rojo-rbx/rokit` (manager) | 1.2.0 | 2025-09-30 | installs the four above from `rokit.toml` |

Sources: each tool's GitHub "latest release" (`api.github.com/repos/<repo>/releases/latest`),
read 2026-11-16. **[S]** sourced; risk levels below are judgment **[J]**.

## Studio

- Install: create.roblox.com → Start creating; Windows and macOS. Free. **[S]**
  (create.roblox.com/docs/education/resources/getting-started-for-developers-education)
- macOS app: `/Applications/RobloxStudio.app`. **[S]** (create.roblox.com/docs/studio/mcp)
- No version to pin: a project records the toolchain, and checks that need Studio
  say "Studio as installed on <date>".

## Knowledge Gap Warning

May 2025 is a floor for every model the studio runs on. After it, Roblox shipped
an MCP server built into Studio (docs page updated 2026-11-14), which replaces the
separate `Roblox/studio-rust-mcp-server` plugin and community servers that older
guides and skills describe. Read `studio-mcp.md` before wiring an AI client.

## Post-Cutoff Version Timeline

| Item | When | Risk | Key change |
|------|------|------|------------|
| Studio built-in MCP server | docs updated 2026-11-14 | HIGH | Enabled in Studio's Assistant; tools for scripts, Luau in Edit/Server/Client, playtest, input, capture, asset generation; every call takes `studio_id` |
| Rojo 7.7.1 | 2026-10-02 | MEDIUM | Not read in detail: check its changelog before relying on a 7.5+ feature |
| Selene 0.32.0 | 2026-10-01 | LOW | Not read in detail |
| StyLua 2.6.0 | 2026-10-10 | LOW | Not read in detail |
| Lune 0.11.1 | 2026-10-21 | MEDIUM | Not read in detail: `require` paths and `@lune/*` modules have changed across 0.x; the scaffold's runner was not run at pin time |
