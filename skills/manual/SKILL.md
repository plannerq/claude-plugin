---
name: manual
description: Writes or updates user manual pages in docs/manual for end users of a PlannerQ project, in plain language with "How to…" tasks, numbered steps and screenshot slots the tester fills in PlannerQ. Use when asked to document a feature for users, update the user manual or help pages, or add screenshot placeholders.
argument-hint: "<item ID or topic>"
---

# PlannerQ: user manual

Input: $ARGUMENTS (an item ID or a topic). If nothing was given, ask.

**Read `${CLAUDE_SKILL_DIR}/rules.md` first.** It defines how pages, wording and screenshot slots work, and every page you write follows it.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, say how to connect (`/mcp` → `plugin:plannerq:plannerq` → Authenticate). Pages can still be written from the code; skip the item comment.
3. **Manual folder.** Use the user manual path the project context gives; otherwise `docs/manual`. PlannerQ mirrors it into the project's manual wiki, where the tester pastes the screenshots.
4. **No manual yet, or one being written?** If the folder has no pages and the person wants more than one feature documented, suggest `/plannerq:manual-init`, which plans and writes the whole manual. If any page contains `<!-- manual-init: pending -->`, a first manual is still being written: suggest running `/plannerq:manual-init` again to finish it, and don't edit the pending pages.

## Steps

1. **Read** the item (`get_item`) if given, and the UI code for the screens involved: labels, buttons, messages, states, who can see what. Read the existing pages under the manual folder.
2. **Choose pages.** Update the page that covers the feature; create one only for a new feature, from `${CLAUDE_SKILL_DIR}/templates/manual-page.md`.
3. **Write** by the rules: tasks first, exact labels in bold, roles, what to do when it goes wrong, the glossary's terms.
4. **Slots:** add new ones; bump the revision of existing slots whose screen changed (check the UI change in the diff).
5. **Show** the pages (a diff for changed ones) and the slot list before writing, unless the person asked for exactly this.

## Saving

- In the repository only. The person commits, or ask before committing.
- If there is an item: `add_comment` listing the pages changed and the slots the tester must capture:

  ```
  **Manual updated:** docs/manual/03-exporting-projects.md
  **Screenshots to capture**
  - New: `export-dialog-empty-project` r1 (Export dialog for a project without items)
  - Outdated: `project-menu` r3 (menu now has Export)
  ```

## Finish

One short summary: pages created and changed, new and outdated slots, and the item comment if one was added.
