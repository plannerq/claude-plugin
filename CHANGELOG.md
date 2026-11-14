# Changelog

Every change bumps `version` in `.claude-plugin/plugin.json` and gets an entry here, newest first.

## 0.2.0 (2026-11-14)

- New skill `release-notes` (`/plannerq:release-notes <release>`): drafts notes from a release's items and merged pull requests, saves them to the release in PlannerQ and to `CHANGELOG.md`. Needs PlannerQ's releases (the `get_release` and `set_release_notes` tools).
- `fix`: a bug's "Fixed in" is now a release; set it only when the person names one.
- README: `get_release` added to the read-only tools that can run without asking.

## 0.1.2 (2026-11-13)

- README: install for a project with one command (it writes the committed settings); try it alone with one command (local scope).

## 0.1.1 (2026-11-13)

- README: explains why the server is listed as `plugin:plannerq:plannerq`.

## 0.1.0 (2026-11-13)

First version.

- Skills: `story`, `pick`, `fix`, `test-cases`, `e2e`, `unit-tests`, `dev-docs`, `manual`, `profile`, `review`, `security-review`.
- Standard rules added to every session by a SessionStart hook.
- PlannerQ MCP server at `https://app.plannerq.com/mcp` (OAuth login with your PlannerQ account).
