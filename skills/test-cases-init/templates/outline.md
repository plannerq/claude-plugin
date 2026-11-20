# Test coverage outline: <product>

Project: <project key and name> · Scope: <whole product | the person's scope notes> · <N> areas in <W> waves · <M> manual cases, <A> to automate, <U> unit/database tests

## Questions

1. **Wave size:** about 30 manual cases per wave. Keep it, or change it?
2. <Question whose answer changes the cases, with the options and your recommendation>

## Areas, in risk order

Levels: `manual` (a `Test:` case, `Automate: no`), `automate` (a `Test:` case, `Automate: yes`), `unit/database test` (no case; noted in the area task).

### 1. <Area> · wave 1

- **What users do:** <one or two lines>
- **Roles:** <roles> · **Screens:** <screens>
- **Planned cases:**
  - <behaviour> · manual
  - <behaviour> · automate
  - <behaviour> · unit/database test (covered by `<test file>` | not written yet)

### 2. <Area> · wave 1

…

## Waves

| Wave | Areas | Manual | Automate |
|---|---|---|---|
| 1 | <Area>, <Area> | <n> | <n> |
| 2 | <Area>, <Area> | <n> | <n> |

## Kept: already covered

| Area | Existing cases |
|---|---|
| <area> | <ID> Test: <title>, <ID> Test: <title> |

## Left out

| Feature | Why |
|---|---|
| <feature> | <behind a feature flag / unfinished / dev tooling / out of the requested scope> |

## Approving creates

- An epic **Test cases: <product>** (<or: a parent task, because epics are off>), in Backlog.
- <N> area tasks **Test area: <area>**, in Backlog, each holding its wave and planned cases.
- The <n> `Test:` cases of **wave 1** only, as subtasks of their area tasks, in Backlog. Later waves stay planned lines until their wave is written.
