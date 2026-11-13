---
name: unit-tests
description: Writes unit tests in a PlannerQ project for changed or named code, using the project's test framework and existing patterns, covering behaviour, the item's edge cases and error paths, and runs them. Use when asked for unit tests for an item, files, functions or the current branch.
argument-hint: "[item ID, files or functions, or \"branch\"]"
---

# PlannerQ: unit tests

Input: $ARGUMENTS

- An **item ID** → the logic that item changes (its branch, or the code its description names).
- **Files or functions** → those.
- **"branch"** or nothing → what changed on the current branch compared with the default branch.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, say how to connect (`/mcp` → `plugin:plannerq:plannerq` → Authenticate). Without an item this skill can still run from the code alone; say that the profile wasn't read.
3. **Profile.** Take the unit test command and framework from the profile. Never guess them; if missing, read the manifests and test config, then confirm with the person.

## Steps

1. **Find the logic:** for an item, `get_item` (acceptance criteria and edge cases) and the diff of its branch; for the branch, `git diff <default branch>...HEAD`; for files or functions, those. Leave out generated code, configuration and pure layout.
2. **Read the existing tests** near that code: framework, file naming, location, helpers, factories, mocking style. Follow them.
3. **Cover:**
   - the behaviour each function or module promises (inputs → outputs, state changes);
   - edge cases from the item and the code: empty, limits, invalid input, duplicates, time zones, rounding;
   - error paths: what is thrown or returned, and what is not done when it fails.
4. **Write** the tests next to the existing ones, in the project's style. One behaviour per test, with a name that says it.
5. **Run** them with the profile's command. Fix the tests until they pass. If a test fails because the code is wrong, keep the test and tell the person (offer to file a bug in PlannerQ, or fix it if it is in scope).

## Guardrails

- Test behaviour, not implementation details: no assertions on private functions or call counts unless that is the behaviour.
- No snapshot tests unless the project already uses them for this kind of code.
- Mock only at the boundaries the project already mocks (network, time, database), and the way it mocks them.
- Never weaken an assertion to make a test pass.

## Saving

Tests go in the repository. PlannerQ: nothing by default; a comment on the item (`add_comment`) listing the test files and what they cover, if the person asks.

## Finish

One short summary: test files, what they cover, the run result, and anything that looks like a bug.
