---
name: profile
description: Builds or refreshes the PlannerQ project profile (summary, features, stack, environments, commands, repository layout, conventions, things not to touch) by reading the repository's manifests, configs, CI and deploy files, shows the diff and saves it. Use when asked to create, update or refresh the project profile, or when another PlannerQ skill finds the profile missing or out of date.
---

# PlannerQ: project profile

The profile is what every PlannerQ skill reads before working in this project: stack, commands, environments and conventions. It is Markdown stored on the project in PlannerQ, readable by the whole team.

## Start

1. **Project.** Call `get_project_context` with `repo_url` from `git remote get-url origin`: the link set in PlannerQ is the source of truth. Only if no project is linked to this repository (or it has no remote), use the `project` from `.plannerq.json` at the repository root. If the repository is linked and `.plannerq.json` names a different project, use the linked one and tell the person the file is out of date (offer to delete it). If neither finds a project, call `list_projects` and ask which project this repository belongs to; recommend that a workspace admin links the repository in the project's settings in PlannerQ (GitHub), and offer `.plannerq.json` (`{"project": "<project id>"}`, to be committed) only where linking isn't possible.
2. **Not connected?** If the PlannerQ tools are missing or ask for a login, tell the person: run `/mcp`, pick `plugin:plannerq:plannerq`, choose Authenticate, then run this command again. Stop.
3. The context's "Project profile" section is the **current profile** (or says there is none yet).

## Steps

1. **Read the repository** (only what exists):
   - manifests and workspaces: `package.json` files, `pnpm-workspace.yaml`, lock files, `pyproject.toml`, `requirements*.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, `composer.json`, `*.csproj`;
   - framework, build and test configs: `next.config.*`, `vite.config.*`, `tsconfig*.json`, `vitest.config.*`, `jest.config.*`, `playwright.config.*`, `pytest.ini`;
   - CI: `.github/workflows/*`, `.gitlab-ci.yml`; deploy: `vercel.json`, `netlify.toml`, `Dockerfile*`, `docker-compose*`, `fly.toml`, infrastructure folders;
   - database: migrations folder, ORM schema (`schema.prisma`, `supabase/`);
   - `.env.example` or `.env.sample`: **variable names only**;
   - `README.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `docs/`.
2. **Never read `.env`, `.env.local` or any other file holding real values**, and never copy a value of a variable, key, token or password into the profile, not even from `.env.example` (examples can be real).
3. **Draft** the profile from `${CLAUDE_SKILL_DIR}/templates/profile.md`:
   - Keep what people wrote by hand unless the repository shows it is now wrong; then change it and say so.
   - Commands are exact and runnable from the repository root (`pnpm --filter web test`, not "run the tests").
   - Environments: name, URL and purpose. Take URLs from the README, deploy configs and the current profile; ask for the ones you can't find rather than guess.
   - Fill gaps you can't settle from the repository with a question to the person; leave `<ask the team>` if they don't know.
4. **Show the diff:** write the current and the new profile to two files in a temporary folder outside the repository and show `diff -u` (or the whole draft when there is no profile yet). List the questions you couldn't answer.
5. **Save** after the person's yes: `update_project_profile` with the whole Markdown. If the server refuses text as a possible secret, find that line, remove the value (keep the name) and show the change before trying again. Delete the temporary files.

## Guardrails

- Profiles hold facts that help someone work on the project: no secrets, no personal data, no customer data.
- Don't put the date or the author in the profile; PlannerQ records who updated it and when.

## Finish

One short summary: sections added or changed, open questions left for the team.
