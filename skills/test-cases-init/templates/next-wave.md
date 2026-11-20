# Wave <n> of <W>: <k> areas, <m> manual cases

Parent: <ID> Test cases: <product> · Wave size: about <30> manual cases · <a> to automate · <u> unit/database tests
<If the gate was overridden: "Written although <x> cases of earlier waves aren't Done, because you said to write anyway.">

Lines marked **new** are behaviour the code has now that the plan missed; lines marked **dropped** are behaviour the code no longer has. Everything else is the plan as it stands in the area task.

## <ID> Test area: <area> · <m> manual, <a> automate

- <behaviour> · manual
- <behaviour> · automate
- <behaviour> · unit/database test (covered by `<test file>` | not written yet)
- **new:** <behaviour> · manual (<code path>)
- **dropped:** <behaviour> (<why: e.g. the Export menu is gone from `components/board/toolbar.tsx`>)

## <ID> Test area: <area> · …

…

## Waves left after this one

| Wave | Area tasks | Manual |
|---|---|---|
| <n+1> | <ID> Test area: <area>, <ID> Test area: <area> | <n> |

<Or: "None: this is the last wave. When it's written, coverage of the planned areas is complete.">

## Approving writes

- The `Test:` cases of the <k> area tasks above, as their subtasks, in Backlog. Each area task's plan is replaced by its list of cases.
- <If anything moved or changed: the updated plans of <ID> Test area: <area>, … and the parent's Areas and waves table.>
- Nothing else: written areas and later waves stay as they are.

Write them? You can change lines or levels, move areas between waves, or change the wave size first.
