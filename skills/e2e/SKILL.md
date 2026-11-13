---
name: e2e
description: Turns a PlannerQ story's "Test:" cases into Playwright regression tests tagged @regression, following the project's e2e setup, runs them and records the spec file and test name on each case. Use when asked to automate test cases or write e2e or regression tests for a story or test case in a PlannerQ project.
argument-hint: "<story ID, or one Test: task ID>"
---

# PlannerQ: e2e regression tests

Input: $ARGUMENTS

- A **story ID** → all its `Test:` subtasks marked `Automate: yes`.
- A **`Test:` task ID** → that one case.

If nothing was given, ask.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, tell the person: run `/mcp`, pick `plugin:plannerq:plannerq`, choose Authenticate, then run this command again. Stop.
3. **Profile.** Take the e2e command, base URL (environments), test folder and the **names** of the login environment variables from the profile. Never guess them; if one is missing, ask.

## Steps

1. **Read the cases** (`get_item` on each; for a story, `list_items` with `parent` = the story and read the `Test:` ones marked `Automate: yes`). Read the story too, for context.
2. **Read the existing setup:** `playwright.config.*`, the test folder, fixtures, helpers, page objects, and how existing tests log in. Follow their patterns. If the project has no Playwright yet, propose a minimal setup (config, folder, one script in the manifest) and wait for a yes before adding it.
3. **Login once.** Use a setup project that signs in and saves a storage state (e.g. `playwright/.auth/<role>.json`, git-ignored), reused by the tests. Credentials come only from the environment variables named in the profile (`process.env.E2E_USER_EMAIL`, …). Never write credentials into files, and never print them. If a needed variable isn't set, tell the person which one and stop.
4. **Write one spec per story**, one test per case. The test title carries the case ID and `@regression`, e.g. `test('PLN-40 member exports an empty project @regression', …)`, or Playwright's `tag` option if the project uses it. Steps follow the case's checklist; each expected result becomes an assertion.
5. **Write robust tests:**
   - Locators by role, label or text (`getByRole`, `getByLabel`, `getByText`), or `data-testid` where the project uses them. No brittle CSS or XPath chains.
   - No fixed waits (`waitForTimeout`). Use web-first assertions (`await expect(…).toBeVisible()`), which wait by themselves.
   - Each test creates the data it needs and doesn't depend on another test's order or leftovers. Clean up where the app allows.
6. **Run** them with the profile's e2e command (only the new spec first, then the whole `@regression` set if it is quick). Fix the tests until they pass.
7. **A test that fails because the app is wrong** is a finding, not a test to bend. Keep the assertion, mark the test `test.fail()` or `test.fixme()` only if the person agrees, and offer to file a bug (`create_item` with `type: bug`, linked `relates_to` the story) after showing it.

## Saving

- Code: in the repository (the person commits, or ask before committing).
- PlannerQ: `add_comment` on each case: `Automated in <spec file path> › "<test title>"`. Don't tick checklist entries; people tick them when they run the case.

## Guardrails

- **Never weaken an assertion to make a test pass**, never delete a failing case's check, and never skip a test silently.
- Never run tests against production unless the profile names that environment as safe for tests and the person confirms.

## Finish

One short summary: spec files, tests written (with case IDs), pass or fail for each, bugs offered or filed, and which cases still need manual testing.
