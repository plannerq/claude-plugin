## Goal

Complete test coverage of <product>, written by `/plannerq:test-cases-init` from the code<, the user manual> on <date>. Every area is covered in full; the areas are written in waves so the tester's queue stays small. The next wave is written only when every case of the previous wave is Done.

## Areas and waves

In risk order. An area task with `test-cases-init: pending` at the top of its description isn't written yet; its planned cases are lines in it. Running `/plannerq:test-cases-init` again writes the next wave; this table is updated when areas move between waves.

| Wave | Area task | Manual | Automate | Unit/database |
|---|---|---|---|---|
| 1 | <ID> Test area: <area> | <n> | <n> | <n> |
| 2 | <ID> Test area: <area> | <n> | <n> | <n> |

Wave size: about <30> manual cases.

## Decisions

- Scope: <whole product | the person's scope notes>.
- <Answers to the outline's questions, one line each>
- Kept, already covered by existing cases: <areas with their cases by ID and title | none>.
- Left out: <feature (why), … | nothing>.
- Behaviour a unit or database test proves better is noted in its area task, not written as a `Test:` case.

## Open questions

<Questions that affect more than one area | None.>
