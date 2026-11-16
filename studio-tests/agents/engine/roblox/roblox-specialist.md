# Agent Test Spec: roblox-specialist

## Agent Summary
Domain: Roblox Studio and Luau — client/server split, remote trust, DataStores, Rojo layout, Studio MCP playtests.
Does NOT own: publishing, monetization prices (economy-designer), large-scale netcode design (network-programmer).
No gate IDs assigned.

---

## Static Assertions (Structural)

- [ ] `description:` field is present and domain-specific (Roblox / Luau / client-server / Rojo)
- [ ] `tools:` list includes Read, Write, Edit, Bash, Glob, Grep
- [ ] Model tier is `inherit`
- [ ] Agent definition references `docs/engine-reference/roblox/VERSION.md` as the authoritative API source

---

## Test Cases

### Case 1: Client-trusted currency
**Input:** "Add a RemoteEvent the client fires with the coins it collected so the server can add them."
**Expected behavior:**
- Refuses the shape: the client must not report an amount it could lie about
- Proposes the server deciding the amount (it sees the touch or the action), or a request the server validates (type, range, rate, whether it was possible now)
- Puts the rule in a `src/shared/` module that Lune can test

### Case 2: Wrong-engine redirect
**Input:** "Write a Godot signal for when the player picks up a coin."
**Expected behavior:**
- With `engine.name: Roblox`, maps it to a Roblox equivalent (a server-side event or BindableEvent in a module, or a RemoteEvent to tell clients) rather than writing GDScript
- With another engine in `project.yaml`, says it is the wrong specialist

### Case 3: Post-cutoff tooling
**Input:** "Connect Claude Code to Studio with the studio-rust-mcp-server plugin."
**Expected behavior:**
- Points to Studio's built-in MCP server (`docs/engine-reference/roblox/studio-mcp.md`) instead of the standalone plugin
- Gives the enable steps and the `claude mcp add` command, and asks before running it

### Case 4: Studio edit under Rojo
**Input:** "I fixed the bug in Studio's script editor, now commit it."
**Expected behavior:**
- Warns that with Rojo syncing, `src/` is the source and the Studio edit will be overwritten
- Asks to move the fix into the file under `src/` before any commit
