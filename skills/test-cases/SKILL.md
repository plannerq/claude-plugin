---
name: test-cases
description: Writes test cases for a PlannerQ story as "Test:" subtasks, each with preconditions, test data, and steps with expected results in its checklist, covering the happy path, edge cases, permissions and error states, and marking which to automate. Use when asked for test cases or a test plan for a story in a PlannerQ project. For a feature area, the whole product, or a project that has no stories yet, use test-cases-init instead.
argument-hint: "<story ID, e.g. PLN-12>"
---

# PlannerQ: test cases

Story: $ARGUMENTS

**Read `${CLAUDE_SKILL_DIR}/rules.md` first.** Every case follows it. The case template is `${CLAUDE_SKILL_DIR}/templates/test-case.md`.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, tell the person: run `/mcp`, pick `plugin:plannerq:plannerq`, choose Authenticate, then run this command again. Stop.
3. **Which skill?**
   - **A story ID:** continue here.
   - **No ID:** check whether the project has stories (`list_items` with `type: ["story"]`, `limit: 1`). If it has **none**, say that this skill writes cases for a story and the project has no stories yet, then hand over to `/plannerq:test-cases-init` (invoke the `plannerq:test-cases-init` skill, passing on any notes the person gave). If it has stories, ask for a story ID, and mention `/plannerq:test-cases-init` for covering whole areas of the product.
   - **A feature area or the whole product** instead of a story (e.g. "test cases for the board", "test the whole app"): say so and hand over to `/plannerq:test-cases-init` the same way, passing the area as its scope notes.
   - **An ID that isn't a story** (an epic, a bug, a task): say what it is. For an epic, offer to write cases for each of its stories; for a bug, its steps to reproduce are the test.
4. **Profile.** Read the environments, roles and e2e setup from the profile. Never guess them.
5. **Types and fields.** Test cases are tasks. Check whether the checklist is on for tasks in this project (from the project context); if not, the steps go in the description (see the rules).

## Steps

1. **Read the story** (`get_item`): description, acceptance criteria (checklist), notes for testing, linked items. List its existing `Test:` subtasks (`list_items` with `parent` = the story) and read them, so nothing is written twice.
2. **Map** each acceptance criterion to one or more cases, covering what the rules list (happy path, edge cases, permissions, error states, mobile where the story mentions it). Skip cases that already exist; extend an existing case only if the person agrees. Behaviour a unit or database test proves better isn't written as a case (see the rules); note it for the comment.
3. **Automate or not** by the rules, with one line why when it is `no`.
4. **Untestable criteria.** If a criterion can't be tested as written, say so and suggest a testable wording.
5. **Show** the list: each case's title, automate yes/no, the criteria it covers, and its steps. Revise until the person says yes.
6. **Save:** each case with `create_item` (`type: task`, `parent` = the story, `title`, `description`, `checklist`, `fields: { status: "backlog" }`). Then `add_comment` on the story with the mapping, naming each case by ID and title:

   ```
   **Test cases**
   | Criterion | Cases |
   |---|---|
   | 1. Given … | PLN-40 Test: member exports an empty project, PLN-41 Test: viewer can't export |
   ```

   If a criterion couldn't be tested, or is covered by a unit or database test instead, the comment says so.

## Guardrails

- Every acceptance criterion is covered by at least one case, or the comment says why not.
- Everything in the rules' Guardrails applies: show before saving, don't tick entries, new cases in Backlog.

## Finish

One short summary: cases created (ID and title), how many to automate, criteria not covered. Say the cases are in Backlog. Suggest `/plannerq:e2e <story ID>` for the cases marked `Automate: yes`.
