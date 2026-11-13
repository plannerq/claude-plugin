---
name: test-cases
description: Writes test cases for a PlannerQ story as "Test:" subtasks, each with preconditions, test data, and steps with expected results in its checklist, covering the happy path, edge cases, permissions and error states, and marking which to automate. Use when asked for test cases or a test plan for a story in a PlannerQ project.
argument-hint: "<story ID, e.g. PLN-12>"
---

# PlannerQ: test cases

Story: $ARGUMENTS

If no ID was given, ask for one.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, tell the person: run `/mcp`, pick `plugin:plannerq:plannerq`, choose Authenticate, then run this command again. Stop.
3. **Profile.** Read the environments, roles and e2e setup from the profile. Never guess them.
4. **Types and fields.** Test cases are ordinary **tasks** (type `task`). If the checklist is off for tasks in this project, put the steps in the description as a numbered list and say so.

## How a test case looks

- **Title:** `Test: <one behaviour>` (e.g. `Test: member exports an empty project`).
- **Description** from `${CLAUDE_SKILL_DIR}/templates/test-case.md`. The first line is `Automate: yes` or `Automate: no`.
- **Checklist:** one entry per step, each with its expected result: `<action> → <expected result>` (e.g. `Click Export → a file named project.csv downloads`).
- **Parent:** the story.

## Steps

1. **Read the story** (`get_item`): description, acceptance criteria (checklist), notes for testing, linked items. List its existing `Test:` subtasks (`list_items` with `parent` = the story) and read them, so nothing is written twice.
2. **Map** each acceptance criterion to one or more cases: the happy path; edge cases (empty, limits, long text, duplicates); permissions (each role in the profile or story that should and shouldn't be able to); error states; mobile where the story mentions it. Skip cases that already exist; extend an existing case only if the person agrees.
3. **Automate or not.** `yes` for stable flows worth guarding in regression; `no` for one-off checks, visual judgement, or what can't be set up reliably. Say why in one line when it is `no`.
4. **Untestable criteria.** If a criterion can't be tested as written, say so and suggest a testable wording.
5. **Show** the list: each case's title, automate yes/no, the criteria it covers, and its steps. Revise until the person says yes.
6. **Save:** each case with `create_item` (`type: task`, `parent` = the story, `title`, `description`, `checklist`). Then `add_comment` on the story with the mapping:

   ```
   **Test cases**
   | Criterion | Cases |
   |---|---|
   | 1. Given … | PLN-40, PLN-41 |
   ```

   If a criterion couldn't be tested, the comment says so.

## Guardrails

- Every acceptance criterion is covered by at least one case, or the comment says why not.
- Write steps someone new to the product could follow: real screens, real button labels from the code, concrete test data.
- Don't tick checklist entries; the tester does when running the case.

## Finish

One short summary: cases created (IDs), how many to automate, criteria not covered. Suggest `/plannerq:e2e <story ID>` for the cases marked `Automate: yes`.
