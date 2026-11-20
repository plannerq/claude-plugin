You are writing the test cases of one feature area of <product>: <one-line description of the product, from the profile>. Project: <project key>. Notes and answers from the person: <notes and the outline's answers, or "none">.

**Rules.** Read `<absolute path to test-cases/rules.md>` and follow it exactly. Each case's description follows the template `<absolute path to test-cases/templates/test-case.md>`, with the **Covers** line naming the planned line and the **Source** line naming the code paths or manual page.

**Your area:** <area task ID> Test area: <area>, under <parent ID> Test cases: <product>. Its plan (also in its description):

<the area's plan: what users do, roles, screens, code, planned cases, notes, open questions>

**What the code says** (inventory rows for this area):
| Behaviour | Roles | Screens | Code | Already covered by |
|---|---|---|---|---|
| … | … | … | … | … |

**Sibling areas** (don't write cases for their behaviours; if a line of yours belongs there, report it):
- <ID> Test area: <area>: <its planned lines, one per line>

**Project facts:** checklist for tasks is <on | off: steps go in the description>. Environments: <from the profile; cases use <local or the test environment>>. Manual: <folder and terms page, or "none">.

**Steps:**
1. **Check the plan against the code.** Read the code listed. Add a line for each behaviour the code has that the plan misses; drop each line whose behaviour the code no longer has. Keep both lists for your report.
2. **Write the cases.** Turn every planned line at level `manual` or `automate` into a `Test:` case, or record why not ("merged into <ID> Test: …", "covered by `<test file>`", "dropped: no longer in the code"). Closely related lines share one case with more steps. Real labels from the code, concrete test data, preconditions with the role. Lines at level `unit/database test` get no case.
3. **Wrong-looking behaviour.** If the code does something that looks wrong (a missing permission check, a confusing message, data lost), don't write it as an expected result: leave that case or step out and report it as a question.
4. **Save each case** with `create_item`: `type: "task"`, `parent: "<area task ID>"`, `title: "Test: <one behaviour>"`, `description` from the template, `checklist` with one `<action> → <expected result>` entry per step (or the steps in the description if the checklist is off), `fields: { status: "backlog" }`.
5. **Rewrite the area task's description** with `update_item` (it replaces the old one): no pending marker; the wave and parent line; **What this area covers** (two or three lines); **Cases**, every case as `<ID> Test: <title> · manual | automate`; **Covered elsewhere**, every line without a case and its reason; **Open questions**. Do this last, once every case is saved: an area task that still has the marker counts as not written.

If a write is refused, stop at once: don't rewrite the area task's description, and report PlannerQ's error and the cases already created.

Write only to this area task and its cases. Don't change code, configuration or data, don't run the cases, and don't touch other items.

**Return** a short report:
- cases created: ID, title, automate yes or no;
- lines added (behaviour the code has that the plan missed) and lines dropped (behaviour no longer in the code);
- lines covered elsewhere and why;
- behaviour that looked wrong or couldn't be confirmed, as questions for the person;
- any write that failed, with PlannerQ's error.
