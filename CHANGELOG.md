# Changelog

Every change bumps `version` in `.claude-plugin/plugin.json` and gets an entry here, newest first.

## 0.4.0 (2026-11-20)

- New skill `test-cases-init` (`/plannerq:test-cases-init [scope notes]`): complete test coverage for a project that has code but no stories, or for whole feature areas. It inventories what users can do from the code (and `docs/manual` when there is one), shows the questions and an outline in one message (areas in risk order, every planned case as one line with its level, the areas grouped into waves of about 30 manual cases), and after approval creates an epic `Test cases: <product>` (a parent task when epics are off) with one `Test area: <area>` task per area, all in Backlog. Subagents write the first wave's `Test:` cases; later areas keep their planned cases as lines, marked `test-cases-init: pending`, until the previous wave's cases are Done. Behaviour that looks wrong becomes a question, never an expected result. Claude can pick it by itself. Writing later waves comes in a later version; for now a second run lists the pending areas and stops.
- `test-cases`: the case rules moved to `skills/test-cases/rules.md`, which `test-cases-init` uses too. New cases are now saved in Backlog (they went to To do), and items are named by ID and title together. Without a story ID in a project with no stories, or given an area or the whole product, it hands over to `test-cases-init`.
- Case template: a **Covers** line for both a story's acceptance criterion and an area's planned line, and a **Source** line for area cases.

## 0.3.2 (2026-11-19)

- `fix`: new Docs step. When a fix changes what users see or do, it updates the affected `docs/manual` page (and `docs/dev` where relevant), or says no docs change was needed. The PR body, the bug comment and the summary now list docs changed.

## 0.3.1 (2026-11-19)

- `story`: new stories (and any epic it creates) are always saved in Backlog, ready or not; it used to save ready stories in To do. A refined story keeps its status.

## 0.3.0 (2026-11-18)

- New skill `manual-init` (`/plannerq:manual-init [scope notes]`): writes a complete user manual for a project that has none. It inventories the features from the code, proposes an outline for approval, writes the sections with subagents, checks pages in the local app when it runs (looking only, never saving), and offers an epic with a task per section for review and screenshots (a parent task with subtasks when epics are off). An interrupted run resumes from the pages still marked pending. Runs only when typed.
- `manual`: its page, wording and screenshot slot rules moved to `skills/manual/rules.md`, which `manual-init` uses too. Behaviour is unchanged; it now also uses the Key concepts page's terms, points to `manual-init` when there's no manual yet, and leaves pages that a `manual-init` run hasn't finished alone.

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
