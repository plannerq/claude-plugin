#!/usr/bin/env bash
# Checks run locally and in CI. Usage: scripts/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

OFFICIAL_MCP="https://app.plannerq.com/mcp"
SKILLS="pick fix story test-cases test-cases-init e2e unit-tests dev-docs manual manual-init release-notes profile review security-review"

# JSON files parse.
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json .mcp.json hooks/hooks.json; do
  node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$f" 2>/dev/null || err "$f is not valid JSON"
done

# The MCP server is the official address, and the only one.
node -e '
  const m = JSON.parse(require("fs").readFileSync(".mcp.json", "utf8"));
  const names = Object.keys(m);
  if (names.length !== 1 || names[0] !== "plannerq") { console.error("one server named plannerq expected"); process.exit(1) }
  if (m.plannerq.type !== "http" || m.plannerq.url !== process.argv[1]) { console.error("url must be " + process.argv[1]); process.exit(1) }
' "$OFFICIAL_MCP" || err ".mcp.json must hold only plannerq → $OFFICIAL_MCP"

# The version has a changelog entry.
version=$(node -p 'require("./.claude-plugin/plugin.json").version')
grep -q "^## ${version//./\\.} " CHANGELOG.md || err "CHANGELOG.md has no entry for $version"

# Standard rules stay short: they cost context in every session (hook output is capped at 10,000 characters).
chars=$(wc -m < rules/standard-rules.md)
[ "$chars" -le 4000 ] || err "rules/standard-rules.md is $chars characters (limit 4000)"

# Each skill: SKILL.md with a matching name and a description; referenced files exist.
for s in $SKILLS; do
  f="skills/$s/SKILL.md"
  [ -f "$f" ] || { err "$f missing"; continue; }
  head -1 "$f" | grep -qx -- '---' || err "$f: no frontmatter"
  grep -qx "name: $s" "$f" || err "$f: name is not $s"
  grep -q '^description: .\{40,\}' "$f" || err "$f: description missing or too short"
  for ref in $(grep -o '\${CLAUDE_SKILL_DIR}/[A-Za-z0-9_./-]*' "$f" | sed 's/^\${CLAUDE_SKILL_DIR}\///' | sed 's/[.]$//' | sort -u); do
    [ -f "skills/$s/$ref" ] || err "$f refers to $ref, which does not exist"
  done
done
for d in skills/*/; do
  s=$(basename "$d")
  case " $SKILLS " in *" $s "*) ;; *) err "skills/$s is not in the list in scripts/check.sh" ;; esac
done

# Typed-only skills: pick creates branches and opens PRs; manual-init writes a whole manual.
for s in pick manual-init; do
  grep -qx 'disable-model-invocation: true' "skills/$s/SKILL.md" || err "$s must have disable-model-invocation: true"
done

# Skills Claude must be able to pick by itself: test-cases-init is the route for projects with no stories.
for s in test-cases-init; do
  grep -q '^disable-model-invocation: true' "skills/$s/SKILL.md" && err "$s must not have disable-model-invocation: true"
done

# test-cases-init writes one wave at a time: the next wave waits until the earlier waves' cases are Done.
grep -q '^### 7.3 The gate' skills/test-cases-init/SKILL.md || err "skills/test-cases-init/SKILL.md has lost its wave gate (### 7.3 The gate)"

# The test case rules live in one file; other skills point to it instead of copying it.
for f in skills/*/SKILL.md; do
  grep -q '^- \*\*Title:\*\* `Test: <one behaviour>`' "$f" && err "$f copies the test case rules; point to skills/test-cases/rules.md instead"
done

# The manual rules live in one file; other skills point to it instead of copying it.
for f in skills/*/SKILL.md; do
  grep -q '^A slot is an HTML comment on its own line' "$f" && err "$f copies the manual rules; point to skills/manual/rules.md instead"
done

# Every skill names the official MCP login path, never another address.
if grep -rnoE 'https?://[A-Za-z0-9.-]*plannerq[A-Za-z0-9.-]*/mcp' --include='*.md' . | grep -v "$OFFICIAL_MCP" ; then
  err "an MCP address other than $OFFICIAL_MCP appears above"
fi

# Claude Code's own validator, when available.
if command -v claude >/dev/null 2>&1; then
  claude plugin validate . || err "claude plugin validate failed"
else
  echo "note: claude CLI not found; skipped 'claude plugin validate'"
fi

[ "$fail" -eq 0 ] && echo "All checks passed." || exit 1
