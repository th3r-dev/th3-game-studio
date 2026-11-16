# Roblox — Deprecated APIs

Sourced entries only; an API missing here has not been checked, not cleared.

| Instead of | Use | Source |
|------------|-----|--------|
| `LocalScript` for client code | `Script` with `RunContext = Client` (recommended, not removed) | **[S]** create.roblox.com/docs/scripting/scripts, read 2026-11-16 |
| `Roblox/studio-rust-mcp-server` (separate install) | Studio's built-in MCP server (`StudioMCP` in the app) | **[S]** create.roblox.com/docs/studio/mcp; the repo describes itself as the standalone server |

Gaps to fill on the next `/setup-engine refresh`: the Engine API reference marks
deprecated members per class (`create.roblox.com/docs/reference/engine`); read the
classes the game uses.
