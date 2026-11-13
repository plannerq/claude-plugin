---
name: dev-docs
description: Creates or updates developer documentation in docs/dev (architecture, setup, modules, decisions, API) in a PlannerQ project, accurate to the code, one topic per file. Use when asked to document a module, an item's change or what changed on the branch for developers.
argument-hint: "[item ID, module, or \"branch\"]"
---

# PlannerQ: developer docs

Input: $ARGUMENTS

- An **item ID** → the pages its change affects.
- A **module** or area (a folder, a feature, "setup", "architecture") → its page.
- **"branch"** or nothing → what changed on the current branch compared with the default branch.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, say how to connect (`/mcp` → `plugin:plannerq:plannerq` → Authenticate). Docs can still be written from the code; skip the item comment.
3. **Docs folder.** Use the developer docs path the project context gives; otherwise `docs/dev`. PlannerQ mirrors this folder into the project's Docs view after each push to the default branch.

## Steps

1. **Read** the item (`get_item`) if given, the code involved, and the existing pages under the docs folder (`ls`, then read the relevant ones).
2. **Choose pages.** Update the page that already covers the topic. Create a new one only for a new topic, from `${CLAUDE_SKILL_DIR}/templates/dev-doc.md`, one topic per file. Kinds of page: architecture, setup, a module, a decision (why something is the way it is), API.
3. **File names** carry a numeric prefix for order and kebab-case words: `01-setup.md`, `02-architecture.md`, `10-module-billing.md`. Folders become sections (`modules/`, `decisions/`). Keep existing numbering; leave gaps for later pages. The first line is `# <Title>`: PlannerQ uses it as the page title.
4. **Write** for a developer new to the project: what it is, where it lives, how it works, how to change it safely. Link files by repository-relative paths (`[server.ts](../../src/server.ts)`). Describe the code as it is now; remove text that is no longer true.
5. **Decisions:** when the item made a choice between options, add or update a decision page: context, options, choice, consequences.
6. **Show** the changed and new pages (a diff for changed ones) before writing, unless the person asked for exactly this.

## Saving

- In the repository only (the mirror brings it into PlannerQ). The person commits, or ask before committing.
- If there is an item: `add_comment` listing the pages created and changed.

## Guardrails

- Accurate to the code: check every claim against it. If unsure, say so in the page rather than guess.
- No secrets, no environment variable values, no internal URLs that aren't in the profile.
- Developer docs only. End-user help goes in `docs/manual` (`/plannerq:manual`).

## Finish

One short summary: pages created and changed, and the item comment if one was added.
