---
name: manual
description: Writes or updates user manual pages in docs/manual for end users of a PlannerQ project, in plain language with "How to…" tasks, numbered steps and screenshot slots the tester fills in PlannerQ. Use when asked to document a feature for users, update the user manual or help pages, or add screenshot placeholders.
argument-hint: "<item ID or topic>"
---

# PlannerQ: user manual

Input: $ARGUMENTS (an item ID or a topic). If nothing was given, ask.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, say how to connect (`/mcp` → `plugin:plannerq:plannerq` → Authenticate). Pages can still be written from the code; skip the item comment.
3. **Manual folder.** Use the user manual path the project context gives; otherwise `docs/manual`. PlannerQ mirrors it into the project's manual wiki, where the tester pastes the screenshots.

## Screenshot slots

A slot is an HTML comment on its own line, where the picture should appear:

```
<!-- screenshot: <slot-id> r<revision> | <what the picture must show> -->
```

Example: `<!-- screenshot: settings-integrations r2 | Settings → Integrations with Outlook connected and the Disconnect button visible -->`

- **Slot id:** kebab-case, unique in the whole manual, named after the screen and state (`export-dialog-empty-project`). Before adding one, search the manual folder for `screenshot: <id> ` to make sure it is unused. **Never reuse an id for a different picture**; a removed slot's id stays retired.
- **Revision:** starts at `r1`. **Bump it** (`r1` → `r2`) when the screen it shows changed in a way the picture would show (layout, labels, new or removed controls). Don't bump for changes the picture wouldn't show. PlannerQ then marks the old picture "outdated" so the tester replaces it.
- **Description:** what the tester must capture: the screen, its state, the data on it, what must be visible. Specific enough that two testers would take the same picture.
- Put a slot wherever a picture saves words: the starting screen of a task, a dialog, a result. Not for every step.

## Steps

1. **Read** the item (`get_item`) if given, and the UI code for the screens involved: labels, buttons, messages, states, who can see what. Read the existing pages under the manual folder.
2. **Choose pages.** Update the page that covers the feature; create one only for a new feature, from `${CLAUDE_SKILL_DIR}/templates/manual-page.md`. File names: numeric prefix and kebab-case (`03-exporting-projects.md`); folders become sections. The first line is `# <Title>`.
3. **Write for end users:** tasks first ("How to export a project"), numbered steps, the exact labels on screen in **bold**, what the user sees after each important step. No technical terms, no code, no internal names. Say who can do it (roles) and what to do when it goes wrong (the messages the user can see).
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

## Guardrails

- **Never invent features.** Describe only what the code does today. If the code and the item disagree, follow the code and tell the person.
- No secrets, test accounts or internal URLs in the manual.

## Finish

One short summary: pages created and changed, new and outdated slots, and the item comment if one was added.
