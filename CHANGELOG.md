# Changelog

Every change bumps `version` in `.claude-plugin/plugin.json` and gets an entry here, newest first.

## 0.9.0 (2026-11-20)

- `test-cases-init`: the next wave skips behaviour that story cases already test. When it refreshes the next wave's planned lines, it also reads the project's story `Test:` cases (any status: the gate still counts area cases only). In the next-wave message a line a story case tests is marked **covered by** that case and its story (ID and title) and gets no area case; a line a story case tests only in part is **narrowed** to what is missing, and the message says which case covers the rest. Other lines are planned as before. The marks are saved in the area task's plan when you approve; when the area is written, its **Covered elsewhere** section lists those lines with the story case, and each story case is linked `relates_to` the area task. Story cases are never moved or changed.

## 0.8.0 (2026-11-20)

- `test-cases` reuses area cases. In a project where `test-cases-init` wrote a `Test cases:` epic, it looks for area cases that already test the story's behaviour: in the areas whose screens the story touches, and by searching titles for each criterion's key words. In the list it shows, each criterion is marked **covered by** an area case (ID and title, no new case), **extends** an area case (the proposed extra steps, applied only if you agree; otherwise a new case covers the rest) or **new**. Several area cases that each cover part of a criterion are all listed, with a new case for what is missing. If the story changes behaviour an area case tests, it proposes updating that case, shown first, and says its automated test (`Automated in` comment) may need updating too. Changes to area cases keep their title and warn when someone has already ticked steps. Reused, extended and updated area cases are linked `relates_to` the story, and the story's mapping comment lists them next to the new cases. With no `Test cases:` epic it works as before. Area task descriptions are never changed.
- Test case rules: changing an existing case needs a yes with its steps before → after, keeps the title, warns about ticked steps and names its automated test.

## 0.7.0 (2026-11-20)

- `e2e` automates a test area. Besides a story or one `Test:` case, it takes a `Test area:` task from `test-cases-init` (its cases marked `Automate: yes`, with the area task read for context) or a `Test cases:` epic, where it lists the areas and asks which to automate. Each area gets one spec named after it (e.g. `e2e/board.spec.ts`); an existing spec gets the new tests added. Cases that already have an `Automated in` comment are skipped unless you ask to rewrite them. An area with no cases to automate, or still pending, is reported and nothing is written; any other kind of ID gets the list of inputs it accepts.
- `e2e` moves passing cases to Done. After the run it lists the cases whose tests passed and asks once; on yes, exactly those move to Done, for story and area cases alike. Cases whose tests failed, were flaky, or are marked `test.fail()`, `test.fixme()` or `test.skip()` stay open. This lets automated area cases count toward the `test-cases-init` wave gate; if you say no, the summary says the next wave stays blocked. Bugs it offers are linked `relates_to` the story or the area task.
- `test-cases-init`: the hand-off points to `/plannerq:e2e <area task or epic ID>`.

## 0.6.0 (2026-11-20)

- `test-cases-init` checks expected results in the local app. Before writing a wave (or finishing a half-written area) it asks once per run whether to check on screen at the profile's local dev URL or write from the code only. It never uses a staging or production URL and says why. It starts the dev server if it isn't running; if the server can't run, you choose to set it up now, continue from the code only, or stop. You sign in yourself in the browser; it never asks for a password or token. In the app it looks only: it opens screens, menus and dialogs and closes them with Cancel, Close or Escape, and never saves, creates, deletes, sends, drags or uploads. Where the browser shows network requests, it checks that none wrote data, and stops checking if one did. Labels on screen win over the code, and a behaviour difference becomes a question. Areas checked through one shared browser run one at a time. Each area case gets a **Checked:** line (`in the app` or `from the code`), and the hand-off lists per area which cases were checked where, the roles needed for screens it couldn't open, and the labels taken from the screen.
- Case template: a **Checked:** line for area cases (story cases leave it out).

## 0.5.0 (2026-11-20)

- `test-cases-init` writes the next wave. Run again on a project that already has a `Test cases:` epic, it first finishes any area a run left half-written (creating only the missing cases, none twice), then checks the gate: if any `Test:` case under the written areas isn't Done, it lists the open cases per area and writes nothing, unless you explicitly say "write it anyway" (the hand-off notes the override). Otherwise it shows the next wave's areas with their planned lines refreshed against the current code (new and dropped lines marked) and asks for a yes; you can move areas between waves or change the wave size first. Written areas and their cases are never changed. After the last wave it says coverage of the planned areas is complete; with nothing pending it says so and writes nothing. Two `Test cases:` epics: it asks which one to continue.

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
