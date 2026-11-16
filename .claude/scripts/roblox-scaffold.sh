#!/usr/bin/env bash
# roblox-scaffold.sh — copies the Roblox scaffold (.claude/engines/roblox/scaffold/)
# into a project for /setup-engine roblox, never overwriting a file, and prints per
# path whether it was created or already there; first, the tools found on PATH.
#
# EMITS OBSERVATIONS, NOT A VERDICT (CLAUDE.md, "Helpers in .claude/scripts/").
# It reports the tools, each path and what is still needed; whether to install,
# and what to tell the person, is the skill's call.
#
# Usage: bash .claude/scripts/roblox-scaffold.sh [--dry-run | --list] [--root DIR]
#          [--title TEXT] [--gitignore]
#   --dry-run     print what would be created (WOULD_CREATE), write nothing
#   --list        print the project-relative paths the scaffold creates, one per
#                 line and nothing else
#   --root DIR    the project; defaults to the repo this script is in
#   --title TEXT  the game's name, for default.project.json's "name"; default:
#                 the project folder's name
#   --gitignore   add the scaffold's .gitignore lines the project's own lacks
#   -h, --help    this text
#
# A project with a default.project.json is an existing Rojo project: nothing is
# copied (refused row, exit 3); /setup-engine roblox records it as it is.
#
# Output: TSV.
#   tool      <rokit|rojo|selene|stylua|lune>  <version line|->
#   studio    <path|->                          Roblox Studio's app, when found
#   mode      write|dry-run
#   refused   default.project.json  <why>       then nothing else (exit 3)
#   CREATED <path> | WOULD_CREATE <path> | EXISTS <path> | FAILED <path> <reason>
#   gitignore <line> <missing|added>
#   created (or would_create) <n>, exists <n> (and failed <n> when above 0)
#   NEEDS     <id> <what>                       rokit, rokit_install, studio
#
# Exit codes: 0 every path created or already there; 1 the root or the scaffold
# cannot be read; 2 usage error; 3 refused; 4 a file could not be created.
# Never prompts, never installs. bash 3.2 and BWK awk safe.

set -u
LC_ALL=C
export LC_ALL

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/../engines/roblox/scaffold"
usage() { echo "roblox-scaffold: $1 (try --help)" >&2; exit 2; }

MODE=write; ROOT_ARG=""; TITLE=""; TITLE_SET=0; GITIGNORE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) [ "$MODE" != list ] || usage "--list and --dry-run cannot be combined"; MODE=dry-run; shift ;;
    --list) [ "$MODE" != dry-run ] || usage "--list and --dry-run cannot be combined"; MODE=list; shift ;;
    --root) [ $# -ge 2 ] || usage "--root needs a value"; ROOT_ARG="$2"; shift 2 ;;
    --title) [ $# -ge 2 ] || usage "--title needs a value"; TITLE="$2"; TITLE_SET=1; shift 2 ;;
    --gitignore) GITIGNORE=1; shift ;;
    -h|--help) sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) usage "unknown argument: $1" ;;
  esac
done
[ "$TITLE_SET" = 0 ] || [ -n "$TITLE" ] || usage "--title needs a value"
[ -d "$SRC" ] || { echo "roblox-scaffold: the scaffold is missing: $SRC" >&2; exit 1; }

list_paths() { ( cd "$SRC" && find . -type f | sed 's|^\./||' | sort ); }
if [ "$MODE" = list ]; then list_paths; exit 0; fi

if [ -n "$ROOT_ARG" ]; then
  cd "$ROOT_ARG" 2>/dev/null || { echo "roblox-scaffold: cannot read root $ROOT_ARG" >&2; exit 1; }
else
  cd "$HERE/../.." 2>/dev/null || { echo "roblox-scaffold: cannot reach the repo root" >&2; exit 1; }
fi

# ----------------------------------------------------------------------- tools
HAVE_ROKIT=0
for t in rokit rojo selene stylua lune; do
  v=$("$t" --version 2>/dev/null | tr -d '\r' | head -1)
  [ "$t" = rokit ] && [ -n "$v" ] && HAVE_ROKIT=1
  printf 'tool\t%s\t%s\n' "$t" "${v:--}"
done
STUDIO=-
for s in "/Applications/RobloxStudio.app" "$HOME/Applications/RobloxStudio.app" \
         "${LOCALAPPDATA:-/nonexistent}/Roblox/Versions"; do
  [ -e "$s" ] && { STUDIO="$s"; break; }
done
printf 'studio\t%s\n' "$STUDIO"
printf 'mode\t%s\n' "$MODE"

if [ -e default.project.json ]; then
  printf 'refused\tdefault.project.json\tan existing Rojo project is here: it is recorded as it is, and nothing is copied over it\n'
  exit 3
fi

# ----------------------------------------------------------------------- title
[ "$TITLE_SET" = 1 ] || TITLE=$(basename "$(pwd)")
# The title goes into a JSON string: \ and " are escaped, control characters dropped.
TITLE_JSON=$(printf '%s' "$TITLE" | tr -d '\000-\037' | sed 's/\\/\\\\/g; s/"/\\"/g')
fill() {
  T="$TITLE_JSON" awk '{ while ((i = index($0, "@TITLE@")) > 0) $0 = substr($0, 1, i - 1) ENVIRON["T"] substr($0, i + 7); print }' "$1"
}
write_new() { # write_new <path> <scaffold file> -- fails, writing nothing, if the path exists
  mkdir -p "$(dirname "$1")" 2>/dev/null || return 1
  case "$1" in
    default.project.json) ( set -C; fill "$2" > "$1" ) 2>/dev/null ;;
    *) ( set -C; cat "$2" > "$1" ) 2>/dev/null ;;
  esac
}

# ------------------------------------------------------------------------- run
NCREATE=0; NEXIST=0; NFAIL=0
while IFS= read -r p; do
  [ -n "$p" ] || continue
  # The project's own .gitignore stays; its missing lines are handled below.
  if [ "$p" = .gitignore ] && [ -f .gitignore ]; then printf 'EXISTS\t%s\n' "$p"; NEXIST=$((NEXIST + 1)); continue; fi
  if [ -e "$p" ] || [ -L "$p" ]; then
    printf 'EXISTS\t%s\n' "$p"; NEXIST=$((NEXIST + 1)); continue
  fi
  if [ "$MODE" = dry-run ]; then printf 'WOULD_CREATE\t%s\n' "$p"; NCREATE=$((NCREATE + 1)); continue; fi
  if write_new "$p" "$SRC/$p"; then printf 'CREATED\t%s\n' "$p"; NCREATE=$((NCREATE + 1))
  else printf 'FAILED\t%s\tcould not create the folder or the file\n' "$p"; NFAIL=$((NFAIL + 1)); fi
done <<EOF
$(list_paths)
EOF

if [ -f .gitignore ] && [ -f "$SRC/.gitignore" ]; then
  _miss=$(tr -d '\r' < "$SRC/.gitignore" | while IFS= read -r l; do
    [ -n "$l" ] || continue
    tr -d '\r' < .gitignore | grep -qxF "$l" || printf '%s\n' "$l"
  done)
  if [ -n "$_miss" ]; then
    if [ "$GITIGNORE" = 1 ] && [ "$MODE" = write ]; then
      { [ -z "$(tail -c 1 .gitignore)" ] || echo; echo; echo '# === Roblox: Rojo build output ==='; printf '%s\n' "$_miss"; } >> .gitignore
      printf '%s\n' "$_miss" | while IFS= read -r l; do printf 'gitignore\t%s\tadded\n' "$l"; done
    else
      printf '%s\n' "$_miss" | while IFS= read -r l; do printf 'gitignore\t%s\tmissing\n' "$l"; done
    fi
  fi
fi

if [ "$MODE" = dry-run ]; then printf 'would_create\t%d\n' "$NCREATE"; else printf 'created\t%d\n' "$NCREATE"; fi
printf 'exists\t%d\n' "$NEXIST"
[ "$NFAIL" -eq 0 ] || printf 'failed\t%d\n' "$NFAIL"

[ "$HAVE_ROKIT" = 1 ] || printf 'NEEDS\trokit\tinstall Rokit (github.com/rojo-rbx/rokit): it installs rokit.toml'"'"'s pinned tools\n'
command -v rojo >/dev/null 2>&1 || printf 'NEEDS\trokit_install\trokit install (downloads the pinned tools from GitHub: ask first)\n'
[ "$STUDIO" != - ] || printf 'NEEDS\tstudio\tinstall Roblox Studio from create.roblox.com and sign in (by hand)\n'

[ "$NFAIL" -eq 0 ] || exit 4
exit 0
