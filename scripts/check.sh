#!/usr/bin/env bash
# Structural checks for the ViewsMax plugin. Fast, no model calls.
# Run directly, from the pre-commit hook, or in CI.
set -u
cd "$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
fail=0
say() { printf '%s\n' "$*"; }
bad() { say "FAIL: $*"; fail=1; }

say "== JSON manifests =="
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json plugin.json .mcp.json mcp.json; do
  if python3 -m json.tool "$f" >/dev/null 2>&1; then say "ok   $f"; else bad "$f is not valid JSON"; fi
  [ -n "$(tail -c1 "$f")" ] && bad "$f has no trailing newline"
done

say "== versions agree =="
v1=$(python3 -c 'import json;print(json.load(open(".claude-plugin/plugin.json"))["version"])')
v2=$(python3 -c 'import json;print(json.load(open("plugin.json"))["version"])')
v3=$(python3 -c 'import json;print(json.load(open(".claude-plugin/marketplace.json"))["plugins"][0].get("version",""))')
[ "$v1" = "$v2" ] && [ "$v1" = "$v3" ] && say "ok   $v1" || bad "versions differ: plugin.json=$v1 root plugin.json=$v2 marketplace=$v3"

say "== skills frontmatter (claude.ai allow-list) =="
python3 - <<'PY' || fail=1
import pathlib, re, sys
allowed = {"name", "description", "allowed-tools", "license", "compatibility", "metadata"}
ok = True
for p in sorted(pathlib.Path("skills").glob("*/SKILL.md")):
    s = p.read_text()
    m = re.match(r"^---\n(.*?)\n---\n", s, re.S)
    if not m:
        print(f"FAIL: {p}: no frontmatter"); ok = False; continue
    keys = [l.split(":", 1)[0] for l in m.group(1).splitlines() if l and not l[0] in " -\t"]
    extra = set(keys) - allowed
    if extra: print(f"FAIL: {p}: fields not accepted by claude.ai: {sorted(extra)}"); ok = False
    if "description" not in keys: print(f"FAIL: {p}: missing description"); ok = False
    name = re.search(r"^name:\s*(.+)$", m.group(1), re.M)
    if name and name.group(1).strip() != p.parent.name:
        print(f"FAIL: {p}: name '{name.group(1).strip()}' differs from directory '{p.parent.name}'"); ok = False
    d = re.search(r"^description:\s*(.*)$", m.group(1), re.M)
    n = len(d.group(1)) if d else 0
    if n > 1536: print(f"FAIL: {p}: description is {n} chars (limit 1536)"); ok = False
    if len(s.splitlines()) > 500: print(f"FAIL: {p}: over 500 lines"); ok = False
    print(f"ok   {p} ({n} chars)")
sys.exit(0 if ok else 1)
PY

say "== no top-level bin/ (claude.ai refuses to install it) =="
[ -d bin ] && bad "top-level bin/ directory present" || say "ok   none"

say "== claude plugin validate =="
if command -v claude >/dev/null 2>&1; then
  out=$(claude plugin validate . 2>&1); rc=$?
  printf '%s\n' "$out" | tail -5
  [ $rc -eq 0 ] || bad "claude plugin validate exited $rc"
else
  say "skip (claude CLI not installed)"
fi

[ $fail -eq 0 ] && say "All structural checks passed." || say "Structural checks FAILED."
exit $fail
