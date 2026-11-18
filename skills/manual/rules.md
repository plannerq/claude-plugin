# User manual rules

The rules every page in the user manual follows. Both `/plannerq:manual` (one feature at a time) and `/plannerq:manual-init` (a whole manual from scratch) write by these rules; this file is the only place they are defined.

## Pages

- One Markdown file per page in the manual folder. Folders become sections.
- File names: numeric prefix and kebab-case (`03-exporting-projects.md`, `04-board/01-moving-cards.md`). PlannerQ sorts pages and sections by name, comparing numbers as numbers, so the prefixes set the order in the wiki and the print view.
- The first line is `# <Title>`, in the words users use.
- New pages start from the page template (`templates/manual-page.md` beside this file).

## Writing for end users

- **Tasks first**: "How to export a project", with numbered steps.
- The exact labels on screen in **bold**: buttons, menus, fields, tabs.
- After each important step, what the user sees.
- Say who can do it (roles), and what to do when it goes wrong: the messages the user can see and what they mean.
- No technical terms, no code, no internal names (tables, components, routes, field keys).
- **Glossary:** when the manual has a key concepts page (a page whose title is "Key concepts" or that defines the product's terms), use its terms and only those for the same things. Don't introduce a second name for a concept it defines.

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

## Guardrails

- **Never invent features.** Describe only what the code does today. If the code and the item disagree, follow the code and tell the person.
- No secrets, test accounts or internal URLs in the manual.
