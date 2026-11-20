---
name: e2e
description: Turns PlannerQ "Test:" cases into Playwright regression tests tagged @regression, following the project's e2e setup, runs them, records the spec file and test name on each case and, after one yes, moves the cases whose tests pass to Done. Takes a story, a "Test area:" task from test-cases-init, a "Test cases:" epic (it asks which areas) or one Test: case. Use when asked to automate test cases or write e2e or regression tests for a story, a test area or a test case in a PlannerQ project.
argument-hint: "<story ID, Test area: task ID, Test cases: epic ID, or one Test: task ID>"
---

# PlannerQ: e2e regression tests

Input: $ARGUMENTS

- A **story ID** → all its `Test:` subtasks marked `Automate: yes`.
- A **`Test area:` task ID** (an area task from `/plannerq:test-cases-init`) → all its `Test:` subtasks marked `Automate: yes`.
- A **`Test cases:` epic ID** (or the `Test cases:` parent task, when epics are off) → it lists the areas and asks which to automate (step 1).
- A **`Test:` task ID** → that one case.

If nothing was given, ask. **Anything else** (a bug, another task or epic, an ID that doesn't exist): say it accepts a story, a `Test area:` task, a `Test cases:` epic or one `Test:` task, and stop.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, tell the person: run `/mcp`, pick `plugin:plannerq:plannerq`, choose Authenticate, then run this command again. Stop.
3. **Profile.** Take the e2e command, base URL (environments), test folder and the **names** of the login environment variables from the profile. Never guess them; if one is missing, ask.

## Steps

1. **Read the cases** (`get_item` on the given ID, then on each case). The **parent** below is the story or area task the cases belong to.
   - **Story:** `list_items` with `parent` = the story; read the `Test:` ones marked `Automate: yes`, and the story for context.
   - **Area task:** `list_items` with `parent` = the area task; read the `Test:` ones marked `Automate: yes`. Read the area task for context instead of a story: what users do, roles, screens, code paths and its planned lines.
   - **`Test cases:` epic:** `list_items` with `parent` = the epic gives the `Test area:` tasks. List them by ID and title in the epic's order, with how many cases each has marked `Automate: yes`; areas still marked `test-cases-init: pending` have no cases yet, so list them apart as pending. Ask which to automate: all, or some. Then treat each chosen area as above, one spec per area.
   - **One `Test:` case:** read it and its parent for context.
   - **Already automated:** a case with an `Automated in …` comment is skipped, unless the person asks to rewrite it. Say which cases were skipped. If such a case is still open, its existing test still runs in step 6, so it can move to Done in step 8.
   - **Nothing to automate:** if the area (or story) has no `Test:` case marked `Automate: yes`, say so and stop. An area task still marked `test-cases-init: pending` has no cases yet: say so, point to `/plannerq:test-cases-init` to write its wave, and stop. If every such case is already automated and Done, say so and stop.
2. **Read the existing setup:** `playwright.config.*`, the test folder, fixtures, helpers, page objects, and how existing tests log in. Follow their patterns. If the project has no Playwright yet, propose a minimal setup (config, folder, one script in the manifest) and wait for a yes before adding it.
3. **Login once.** Use a setup project that signs in and saves a storage state (e.g. `playwright/.auth/<role>.json`, git-ignored), reused by the tests. Credentials come only from the environment variables named in the profile (`process.env.E2E_USER_EMAIL`, …). Never write credentials into files, and never print them. If a needed variable isn't set, tell the person which one and stop.
4. **Write one spec per story or area**, one test per case.
   - **An area's spec is named after the area**, in the project's test folder and naming style: `Test area: Board` → `e2e/board.spec.ts`. If that spec already exists, add the new tests to it; don't rewrite the tests already there.
   - The test title carries the case ID and `@regression`, e.g. `test('PLN-40 member exports an empty project @regression', …)`, or Playwright's `tag` option if the project uses it.
   - Steps follow the case's checklist; each expected result becomes an assertion.
5. **Write robust tests:**
   - Locators by role, label or text (`getByRole`, `getByLabel`, `getByText`), or `data-testid` where the project uses them. No brittle CSS or XPath chains.
   - No fixed waits (`waitForTimeout`). Use web-first assertions (`await expect(…).toBeVisible()`), which wait by themselves.
   - Each test creates the data it needs and doesn't depend on another test's order or leftovers. Clean up where the app allows.
6. **Run** them with the profile's e2e command (only the new or changed specs first, then the whole `@regression` set if it is quick). Fix the tests until they pass. Read each test's result from the run's report: passed, failed, flaky (passed only on a retry), skipped, or expected to fail (`test.fail()`).
7. **A test that fails because the app is wrong** is a finding, not a test to bend. Keep the assertion, mark the test `test.fail()` or `test.fixme()` only if the person agrees, and offer to file a bug (`create_item` with `type: bug`, linked `relates_to` the case's parent: the story or the area task) after showing it.
8. **Move passing cases to Done.** After the last run, list the cases whose tests **passed**, by ID and title, and ask **once**: "<n> cases pass. Move them to Done?" On yes, move exactly those cases to Done (`update_item` with `status: "done"`); the `Automated in` comment is the record. This applies to story cases and area cases alike. These cases stay open:
   - a test that failed, was flaky, or didn't run;
   - a test marked `test.fail()`, `test.fixme()` or `test.skip()`;
   - a case already Done (leave it as it is).

   On no, nothing moves. For area cases, say that the next wave of `/plannerq:test-cases-init` stays blocked until every case of the earlier waves is Done; running this command again on the area offers the passing cases again.

## Saving

- Code: in the repository (the person commits, or ask before committing).
- PlannerQ: `add_comment` on each case automated this run: `Automated in <spec file path> › "<test title>"`. Don't tick checklist entries; people tick them when they run a case by hand. Statuses change only in step 8, after the yes.

## Guardrails

- **Never weaken an assertion to make a test pass**, never delete a failing case's check, and never skip a test silently.
- **A case moves to Done only when its test passed in this run and the person said yes.** Never move a case whose test failed, was flaky or is marked to fail, fix or skip.
- Never run tests against production unless the profile names that environment as safe for tests and the person confirms.

## Finish

One short summary: spec files, tests written (with case IDs), pass or fail for each, cases skipped as already automated, **cases moved to Done** and cases left open (and why), bugs offered or filed, and which cases still need manual testing. For area cases left open, say that the next wave waits until they are Done.
