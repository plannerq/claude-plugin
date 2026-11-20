---
name: test-cases
description: Writes test cases for a PlannerQ story as "Test:" subtasks, each with preconditions, test data, and steps with expected results in its checklist, covering the happy path, edge cases, permissions and error states, and marking which to automate. Where test-cases-init already wrote area cases, it reuses or extends them instead of writing duplicates. Use when asked for test cases or a test plan for a story in a PlannerQ project. For a feature area, the whole product, or a project that has no stories yet, use test-cases-init instead.
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
6. **Area cases.** Look for coverage written by `/plannerq:test-cases-init`: `list_items` with `text: "Test cases:"` and type `epic` (or `task` when epics are off), keeping only items whose title starts with `Test cases:`. Under each, its area tasks are the subtasks whose title starts with `Test area:` (`list_items` with `parent` = it). **If there is none, skip every step about area cases: the skill works as before.**

## Steps

1. **Read the story** (`get_item`): description, acceptance criteria (checklist), notes for testing, linked items. List its existing `Test:` subtasks (`list_items` with `parent` = the story) and read them, so nothing is written twice.
2. **Find area cases** (only when step 6 found a `Test cases:` epic). Area cases are the `Test:` subtasks of the area tasks.
   - **Areas the story touches:** read the area tasks' descriptions (what the area covers, its screens and code, its cases) and keep those whose screens or behaviour the story's criteria touch.
   - **Search by words:** for each criterion, `list_items` with `text` set to its key words (the screen, the action, the label) and `type: ["task"]`, keeping `Test:` items whose parent is an area task. This finds cases in areas the first pass missed.
   - **Read each candidate** (`get_item`): its **Covers** line, preconditions, steps, which checklist entries are ticked, its status, and its comments. An `Automated in <spec> › "<test>"` comment means an e2e test runs it.
   - Planned lines of area tasks that aren't written yet (marked `test-cases-init: pending`) are not cases: don't reuse them or count them as cover.
3. **Map** each acceptance criterion to one or more cases, covering what the rules list (happy path, edge cases, permissions, error states, mobile where the story mentions it). Skip cases that already exist under the story; extend one of them only if the person agrees. Behaviour a unit or database test proves better isn't written as a case (see the rules); note it for the comment. Where area cases were found, mark each criterion:
   - **covered by** `<ID> Test: <title>`: an area case already tests the criterion's behaviour as the story describes it. No new case is proposed for it; the area case is linked to the story when saved.
   - **extends** `<ID> Test: <title>`: an area case tests part of it, and a few more steps (or another test data value) would cover the rest. Propose the change to that case's steps. If the person says no, a new case under the story covers the missing part instead.
   - **new:** a case under the story, as when there are no area cases.
   - **Several area cases each cover part** of one criterion: list them all, and propose a new case (or an extension) for what none of them covers.
   - **The story changes behaviour an area case tests**, so its expected results would be wrong once the story ships: propose an **update** of that case (the changed steps and expected results). If it has an `Automated in` comment, say that this test (spec and test name) may need updating too. Say that the case describes the new behaviour from then on, so it fails if run before the story ships.
4. **Automate or not** by the rules, with one line why when it is `no`. Reused area cases keep their own `Automate:` line.
5. **Untestable criteria.** If a criterion can't be tested as written, say so and suggest a testable wording.
6. **Show** the list. When area cases are changed, show those first: each **update** and **extends** with the case's ID and title, why it changes, its steps before → after, and the warnings the rules ask for (ticked entries, an automated test). Then each criterion with its mark (covered by, extends, new) and the cases it maps to, and each new case's title, automate yes/no, the criteria it covers, and its steps. Revise until the person says yes. A change to an area case is applied only if the person agrees to it; they can approve the rest without it.
7. **Save.**
   - **New cases:** each with `create_item` (`type: task`, `parent` = the story, `title`, `description`, `checklist`, `fields: { status: "backlog" }`).
   - **Agreed changes to area cases** (extends, update): `update_item` with the changed description (preconditions, test data, a **Covers** line that also names this story's criterion) and `set_checklist` with the case's full list of steps. Keep the title, the parent and the status. Entries whose text is unchanged keep their ticks.
   - **Links:** `add_link` from each area case marked covered by, extended or updated, `relates_to` the story (`ref` = the area case, `other` = the story), unless that link is already there.
   - **Comment:** `add_comment` on the story with the mapping, naming each case by ID and title. A reused area case is marked `(area case, reused)`, an extended one `(area case, extended)`; new cases have no mark:

   ```
   **Test cases**
   | Criterion | Cases |
   |---|---|
   | 1. Given … | PLN-40 Test: member exports an empty project, PLN-41 Test: viewer can't export |
   | 2. Given … | PLN-17 Test: export a project to CSV (area case, reused) |

   **Area cases updated for this story:** PLN-18 Test: export shows the file size: now expects the size in KB. Automated in `e2e/export.spec.ts` › "export shows the file size", which may need updating.
   ```

   If a criterion couldn't be tested, or is covered by a unit or database test instead, the comment says so. Leave out the "Area cases updated" line when none was updated.

## Guardrails

- Every acceptance criterion is covered by at least one case (the story's own or an area case), or the comment says why not.
- Area cases change only with the person's yes, case by case. Never change an area task's description, and never move cases between a story and an area.
- Everything in the rules' Guardrails applies: show before saving, don't tick entries, new cases in Backlog.

## Finish

One short summary: cases created (ID and title), how many to automate, area cases reused, extended or updated (ID and title), and criteria not covered. Say the new cases are in Backlog. Suggest `/plannerq:e2e <story ID>` for the new cases marked `Automate: yes`, and name updated area cases whose automated test may need updating (`/plannerq:e2e <case ID>` rewrites it when asked).
