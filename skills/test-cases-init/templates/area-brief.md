You are writing the test cases of one feature area of <product>: <one-line description of the product, from the profile>. Project: <project key>. Notes and answers from the person: <notes and the outline's answers, or "none">.

**Rules.** Read `<absolute path to test-cases/rules.md>` and follow it exactly. Each case's description follows the template `<absolute path to test-cases/templates/test-case.md>`, with the **Covers** line naming the planned line and the **Source** line naming the code paths or manual page.

**Your area:** <area task ID> Test area: <area>, under <parent ID> Test cases: <product>. Its plan (also in its description):

<the area's plan: what users do, roles, screens, code, planned cases, notes, open questions>

**What the code says** (inventory rows for this area):
| Behaviour | Roles | Screens | Code | Already covered by |
|---|---|---|---|---|
| … | … | … | … | … |

**Cases already written** (only when finishing an area a run left half-written; otherwise "none"):
- <ID> Test: <title> (<status>)

**Sibling areas** (don't write cases for their behaviours; if a line of yours belongs there, report it):
- <ID> Test area: <area>: <its planned lines, or for a written area its cases by ID and title, one per line>

**Project facts:** checklist for tasks is <on | off: steps go in the description>. Environments: <from the profile; cases use <local or the test environment>>. Manual: <folder and terms page, or "none">.

**Checking in the app:** <one of:>
- <"Yes: the local app runs at <local dev URL>, signed in as <role> by the person. Use <browser tool, or Playwright with the saved session <storage state path> and screenshots in <scratchpad path>>. You are the only one using the browser now. Look only: open screens, menus and dialogs, read labels, messages and empty states, and close dialogs with Cancel, Close or Escape (a button that names an action, like "Cancel invite", is not a close). Never flip a switch or checkbox, edit a field in place or type into a form that may save as you go. Never click Save, Create, Add, Delete, Remove, Send, Invite, Submit or anything that changes data or sends something; never drag; never upload; never open any URL other than the local app. If the browser tool shows network requests, look at them after each screen you open: a request that creates, changes or deletes data (reads, session refreshes and analytics don't count) means stop checking at once and report it.">
- <"No: write from the code only, because <the person chose it | the dev server can't run | no browser>.">

**Steps:**
1. **Check the plan against the code.** Read the code listed. Add a line for each behaviour the code has that the plan misses; drop each line whose behaviour the code no longer has. Keep both lists for your report.
2. **Check on screen** (only when checking in the app is Yes). For each planned line, open the screens it covers and read what is there: labels, button names, messages, empty states, what each menu and dialog offers. Steps that need a data change (saving, creating, deleting, moving) are written from the code. When the words on screen differ from the code, use the words on screen. When behaviour differs (a step leads elsewhere, a message the code shows doesn't appear), leave that step out (and the case, if it hangs on that step) and report it as a question. If the app stops answering, write the rest from the code and say so. A screen the signed-in role can't open is written from the code; note the role it needs.
3. **Write the cases.** If cases are already written, read each one first (`get_item`): a planned line whose behaviour an existing case tests (its **Covers** line names the line, or its title tests the same behaviour) is covered by it. Create cases only for the lines still uncovered, never a case whose title matches an existing one, and don't change the existing cases. Turn every planned line at level `manual` or `automate` into a `Test:` case, or record why not ("merged into <ID> Test: …", "covered by `<test file>`", "dropped: no longer in the code"). Closely related lines share one case with more steps. Real labels (from the screen where you checked it, else from the code), concrete test data, preconditions with the role. Each case's **Checked:** line says `in the app` or `from the code`; a case checked on screen whose later steps change data names them, e.g. `in the app; steps 3–4 from the code (they save data)`. Lines at level `unit/database test` get no case.
4. **Wrong-looking behaviour.** If the code does something that looks wrong (a missing permission check, a confusing message, data lost), don't write it as an expected result: leave that case or step out and report it as a question.
5. **Save each case** with `create_item`: `type: "task"`, `parent: "<area task ID>"`, `title: "Test: <one behaviour>"`, `description` from the template, `checklist` with one `<action> → <expected result>` entry per step (or the steps in the description if the checklist is off), `fields: { status: "backlog" }`.
6. **Rewrite the area task's description** with `update_item` (it replaces the old one): no pending marker; the wave and parent line; **What this area covers** (two or three lines); **Cases**, every case (existing ones too) as `<ID> Test: <title> · manual | automate`; **Covered elsewhere**, every line without a case and its reason; **Open questions**. Do this last, once every case is saved: an area task that still has the marker counts as not written.

If a write is refused, stop at once: don't rewrite the area task's description, and report PlannerQ's error and the cases already created.

Write only to this area task and its cases. Don't change code, configuration or data, don't run the cases, and don't touch other items.

**Return** a short report:
- cases created: ID, title, automate yes or no (and, when finishing an area, the existing cases kept);
- lines added (behaviour the code has that the plan missed) and lines dropped (behaviour no longer in the code);
- lines covered elsewhere and why;
- checked in the app: the cases checked on screen and those from the code only (by ID); screens the signed-in role couldn't open and the role they need; labels you took from the screen because the code said otherwise; any request that changed data, if one was sent;
- behaviour that looked wrong, differed between the screen and the code, or couldn't be confirmed, as questions for the person;
- any write that failed, with PlannerQ's error.
