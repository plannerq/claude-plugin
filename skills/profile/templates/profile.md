## Summary

<Two or three sentences: what the product is, who uses it, what state it is in.>

## Main features

- <Feature>: <one line>

## Stack

- **Frontend:** <framework and version, UI library, state management>
- **Backend:** <framework or runtime, API style>
- **Database:** <engine, ORM or client, where migrations live>
- **Auth:** <provider and how sessions reach the backend>
- **Hosting:** <where each part runs>
- **Other services:** <email, storage, payments, monitoring, AI, …>

## Environments

| Name | URL | Purpose |
|---|---|---|
| local | <http://localhost:…> | Development |
| <staging> | <url> | <what it is for; whether tests may run against it> |
| production | <url> | Live. Never run tests or migrations against it without the team's say. |

**Test accounts (environment variable names only):** <e.g. `E2E_USER_EMAIL`, `E2E_USER_PASSWORD` for a member; `E2E_ADMIN_EMAIL`, … for an admin>

## Commands

Run from the repository root.

| What | Command |
|---|---|
| Install | <command> |
| Dev server | <command> |
| Unit tests | <command> |
| E2E tests | <command> (tests in `<folder>`, base URL from `<variable or config>`) |
| Typecheck | <command> |
| Lint | <command, or "none"> |
| Build | <command> |
| Database migrations | <how they are created and applied; who applies them to shared databases> |

## Repository layout

- `<folder>/`: <what lives there>

## Conventions

- **Branches and commits:** branch `<id>-<short-title>` (e.g. `pln-12-export-csv`); commit messages and PR titles start with the item ID.
- **Code:** <style rules, patterns to follow, where new code goes>
- **Tests:** <where unit and e2e tests live, naming, mocking style, test data>
- **Docs:** developer docs in `docs/dev`, user manual in `docs/manual`.

## Things not to touch

- <Generated files, vendored code, files owned by another team, production settings>
