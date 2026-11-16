# Roblox — Studio MCP server

Source: create.roblox.com/docs/studio/mcp (page updated 2026-11-14), read 2026-11-16. **[S]**

Built into Studio; stdio transport; any MCP client. Enable: Assistant → `…` →
Manage MCP Servers → **Enable Studio as MCP server**. Quick connect lists Claude
Code, Claude Desktop, Codex CLI, Gemini CLI, Cursor, VS Code and Antigravity.

| Client config | Command |
|---------------|---------|
| macOS | `/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP` |
| Windows | `cmd.exe /c %LOCALAPPDATA%\Roblox\mcp.bat` |

Claude Code: `claude mcp add Roblox_Studio -- /Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`.

## Tools, by job

| Job | Tools |
|-----|-------|
| Scripts | `script_read`, `multi_edit`, `script_search`, `script_grep` |
| Explore the place | `search_game_tree`, `inspect_instance`, `subagent` (`explore`, `playtest`) |
| Run Luau | `execute_luau` (`datamodel_type`: Edit, Client or Server) |
| Playtest | `get_studio_state`, `start_stop_play`, `get_console_output`, `screen_capture` |
| Player input | `character_navigation`, `user_keyboard_input`, `user_mouse_input` |
| Assets | `search_asset`, `insert_asset`, `upload_image`, `store_image`, `generate_mesh`, `generate_material`, `generate_procedural_model`, `generate_animation`, `generate_avatar`, `wait_job_finished` |
| Docs | `http_get` (Roblox docs only), `skill` |
| Place | `save_place`, `list_roblox_studios` |

Every call takes a `studio_id`; `list_roblox_studios` lists them. Playtests work
across teleports within one experience.

## Rules for agents

- The server can change the open place. Edit `src/` files when Rojo is
  connected; use `multi_edit` only for a place without files.
- A playtest result is what `get_console_output` and `screen_capture` show, not
  what the script was meant to do.
- `save_place` writes a new version of a place opened from Roblox: ask first.
