# Review checklist (used when Claude Code's built-in code review is not available)

Read the whole diff and enough of the surrounding code to judge it. Report only real problems, each with a concrete case (input or state → wrong result). Skip style nits unless they break the project's conventions.

## Correctness
- Logic matches the item's description and acceptance criteria.
- Edge cases: empty, null or missing values, limits, duplicates, very long input, time zones, rounding.
- Error handling: failures are caught where they can be handled, reported to the user, not swallowed silently.
- Async: awaited promises, race conditions, stale state, double submits.
- Data changes: migrations safe to run on existing data and compatible with the code that is live while they run.

## Security
- Every server route and action checks who the user is and what they may do.
- Input from users is validated on the server; no injection (SQL, HTML, shell, paths).
- No secrets in code, logs or responses.

## Performance
- No queries in loops, unbounded lists, or large payloads where a page would do.

## Tests
- Unit tests for new logic; e2e tests for changed user flows; tests assert behaviour, not implementation.

## Docs
- `docs/dev` and `docs/manual` updated where behaviour changed; screenshot slots bumped where screens changed.

## Conventions
- The profile's conventions and "things not to touch" are respected.
