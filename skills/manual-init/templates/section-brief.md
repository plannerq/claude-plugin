You are writing one section of a user manual for end users of <project name>: <one-line description of the product, from the profile>. Audience: <audience>. Notes from the person: <notes, or "none">.

**Rules.** Read `<absolute path to manual/rules.md>` and follow it exactly. New page content follows the template `<absolute path to manual/templates/manual-page.md>`.

**Terms.** Read `<path to the Key concepts page>`. Use its terms, and only those, for the concepts it defines.

**Your pages** (stubs; each holds its plan in a `manual-init plan` comment):
- `<path>`: <title>
- `<path>`: <title>

**What the code says** (inventory rows for these pages):
| Feature | What users do | Roles | Screens | Code |
|---|---|---|---|---|
| … | … | … | … | … |

**Checking in the app:** <one of:>
- <"Yes: the local app runs at <URL>, signed in as the person. Use <browser tool or Playwright>. Look only: open screens, menus and dialogs and close them with Cancel, Close or Escape. Never click Save, Create, Add, Delete, Remove, Send, Invite, Submit or anything that changes data or sends something; never drag or upload. If a state can only be seen by changing data, describe it from the code and say so.">
- <"No: write from the code only.">

**For each page:**
1. Read the code listed for it: the screens, their labels, buttons, messages and states, and the role checks. Read the other pages of the manual only to link to them; don't change them.
2. Replace the stub with the full page: keep the `# <Title>` line, follow the rules and template, cover the tasks in the plan, add screenshot slots with ids starting `<slot prefix>` (check they're unused in the whole manual folder), link related pages.
3. Remove both `manual-init` comments (the pending marker and the plan). A page that still has the marker counts as not written.
4. Describe only what the code does. If something can't be confirmed, leave it out of the page and report it.

Write only the files listed above. Don't change code, configuration or data, and don't write to PlannerQ.

**Return** a short report:
- pages written;
- slots added (id and description) per page;
- pages checked in the app, and pages written from the code only;
- anything you couldn't confirm, guessed or left out, as questions for the person.
