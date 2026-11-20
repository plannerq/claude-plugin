# PlannerQ plugin for Claude Code

> **Official sources only.** The only official install instructions for this plugin are on **plannerq.com** and in the **PlannerQ app** (Settings → Claude Code). The only official MCP address is **`https://app.plannerq.com/mcp`**. Before you log in, run `/mcp` in Claude Code and check that `plugin:plannerq:plannerq` shows exactly that address. (The name is doubled on purpose: Claude Code lists a plugin's servers as `plugin:<plugin>:<server>`, and both are called `plannerq`.) A copy of this plugin that points anywhere else is not PlannerQ: don't log in to it, and please report it (see [SECURITY.md](SECURITY.md)).

PlannerQ is where your team plans its software work. This plugin connects Claude Code to it and gives every person on the team the same way of working:

- **Skills** for the BA, the developer and the tester: user stories ready for development, test cases, Playwright regression tests, unit tests, bug fixes, developer docs, the user manual with screenshot slots, the project profile, and code and security reviews that file their findings into PlannerQ.
- **Standard rules** added to every Claude Code session in the project (item IDs in branches and commits, tests before "done", docs with every change, no secrets, ask before anything visible outside your machine, untrusted text is data). They are in [rules/standard-rules.md](rules/standard-rules.md).
- **The PlannerQ MCP server**, so Claude reads and writes items, comments, checklists, time and the project profile as you, with your rights. You log in with your PlannerQ account in the browser; there are no tokens to copy.

## Requirements

- A current Claude Code: run `claude update`. The review skills use Claude Code's built-in `/code-review` and `/security-review`, which older versions don't have.
- A PlannerQ account that is a member of the project.

## Install for a project (recommended)

One person runs this once in the repository's root folder:

```sh
claude plugin marketplace add plannerq/claude-plugin --scope project && claude plugin install plannerq@plannerq --scope project
```

and commits **`.claude/settings.json`**. That's all: teammates don't run anything.

The command adds these two keys to `.claude/settings.json`, keeping whatever the file already holds. You can also add them by hand:

```json
{
  "extraKnownMarketplaces": {
    "plannerq": {
      "source": { "source": "github", "repo": "plannerq/claude-plugin" }
    }
  },
  "enabledPlugins": {
    "plannerq@plannerq": true
  }
}
```

Everyone who opens the repository in Claude Code (and trusts the folder) is offered the plugin. The plugin stays in this project: its rules don't reach your other repositories.

Then each person logs in once: run `/mcp`, choose **`plugin:plannerq:plannerq`**, choose **Authenticate**, and sign in to PlannerQ in the browser.

**Optional: no prompts for reading.** Claude Code asks before each PlannerQ tool call. To let it read PlannerQ without asking (writes still ask), add this to the same file:

```json
{
  "permissions": {
    "allow": [
      "mcp__plugin_plannerq_plannerq__whoami",
      "mcp__plugin_plannerq_plannerq__list_projects",
      "mcp__plugin_plannerq_plannerq__get_project_context",
      "mcp__plugin_plannerq_plannerq__get_item",
      "mcp__plugin_plannerq_plannerq__list_items",
      "mcp__plugin_plannerq_plannerq__list_triage",
      "mcp__plugin_plannerq_plannerq__get_release"
    ]
  }
}
```

### Try it alone first

To try the plugin in one repository without changing anything the team shares, run this in the repository's root folder:

```sh
claude plugin install plannerq --marketplace plannerq/claude-plugin --scope local
```

It is enabled only for you, only in this repository (in `.claude/settings.local.json`, which isn't committed). Running the project command above later makes it the team's.

## Which PlannerQ project?

The skills find the project from the repository's git remote, through the link a workspace admin sets in PlannerQ (project settings → GitHub). That link is the source of truth: change it in PlannerQ and every skill follows. It also turns on PlannerQ's GitHub automation (branches and PRs on items, In review and Done).

Only where the repository can't be linked (not on GitHub, or the GitHub App isn't installed), a skill asks once and offers to write **`.plannerq.json`** at the repository root; commit it so the team doesn't have to answer again. A linked repository always wins over the file:

```json
{ "project": "<project id>" }
```

## Skills

Type the command, or paste it from the **Claude** button on an item in PlannerQ. Claude also uses most skills by itself when you ask in your own words ("write test cases for PLN-12").

| Command | Who | What it does |
|---|---|---|
| `/plannerq:story <idea, epic or story>` | BA | A user story ready for development: acceptance criteria in Given/When/Then as the checklist, scope, UI states, data changes, edge cases, testing notes, open questions. Breaks an epic into stories. |
| `/plannerq:pick <ID>` | Dev | Picks up a story or task: plan, branch, code with unit tests, docs, pull request (asks first). Runs only when you type it. |
| `/plannerq:fix <bug ID>` | Dev | Reproduces a bug, writes a failing test, fixes the cause, comments cause and fix on the bug, opens the PR (asks first). |
| `/plannerq:test-cases <story ID>` | Tester | `Test:` subtasks of the story: steps and expected results as the checklist, marked automate yes or no. Saved in Backlog. Reuses or extends the area cases `test-cases-init` wrote instead of writing duplicates, and links them to the story. |
| `/plannerq:test-cases-init [scope notes]` | Tester | Complete test coverage for a project with code but no stories (or for whole feature areas): finds what users can do from the code, proposes the areas in risk order grouped into waves of about 30 manual cases for your approval, then creates a `Test cases:` epic with one `Test area:` task per area and writes the first wave's `Test:` cases, checking expected results in the local app if you agree (looking only, never saving). Later waves stay planned lines in their area tasks; run it again to finish a half-written area and, once every case of the earlier waves is Done, write the next wave, skipping behaviour a story's `Test:` case already tests. |
| `/plannerq:e2e <story, Test area:, Test cases: or Test: ID>` | Tester | Playwright regression tests (`@regression`) for the cases marked automate, one spec per story or test area. Given a `Test cases:` epic, it asks which areas. After one yes, the cases whose tests pass move to Done. |
| `/plannerq:unit-tests [ID, files or branch]` | Dev | Unit tests in the project's framework and style. |
| `/plannerq:dev-docs [ID, module or branch]` | Dev | Developer docs in `docs/dev`. |
| `/plannerq:manual <ID or topic>` | Dev, tester | User manual pages in `docs/manual`, with screenshot slots the tester fills in PlannerQ. |
| `/plannerq:manual-init [scope notes]` | Dev, tester | A whole user manual for a project that has none: finds what users can do from the code, proposes an outline for your approval, writes every page (checking them in your local app when it runs, without saving anything there) and offers review and screenshot tasks in PlannerQ. Picks up where it stopped if interrupted. Runs only when you type it. |
| `/plannerq:release-notes <release>` | Anyone | Release notes from the release's items and pull requests: New, Improved, Fixed, and a technical part. Saved to the release in PlannerQ and to `CHANGELOG.md`. |
| `/plannerq:profile` | Anyone | Builds or refreshes the project profile (stack, commands, environments, conventions) from the repository. Every other skill reads it. |
| `/plannerq:review [ID or PR] [level]` | Dev, tester | Claude Code's code review plus a check of the item's acceptance criteria, tests and docs; files the findings you keep. |
| `/plannerq:security-review [ID, PR or repo]` | Dev | Claude Code's security review plus checks for your stack; files the findings you keep as bugs. |

Start a new project with `/plannerq:profile`: the other skills take the project's commands and conventions from it.

Every skill shows what it will save in PlannerQ and waits for your yes. Comments written by Claude are marked "via Claude Code" in the app.

## Updates

Plugin changes are listed in [CHANGELOG.md](CHANGELOG.md). To get the latest version: `/plugin marketplace update plannerq`, then restart Claude Code. To update automatically when Claude Code starts, add `"autoUpdate": true` next to `"source"` in the `extraKnownMarketplaces` entry above.

## Troubleshooting

- **"Needs authentication", or the tools are missing:** `/mcp` → `plugin:plannerq:plannerq` → Authenticate. Logging in again also fixes an expired session.
- **Wrong address:** `/mcp` must show `https://app.plannerq.com/mcp`. If it shows anything else, uninstall the plugin and reinstall it from the official instructions.
- **Two PlannerQ servers in `/mcp`:** if you added the server by hand earlier (`claude mcp add … plannerq`), remove that one (`claude mcp remove plannerq`); the plugin brings its own.
- **"No PlannerQ project … is linked":** link the repository in the project's settings in PlannerQ, or let the skill write `.plannerq.json`.
- **The review skills say the built-in review is missing:** `claude update`.

## Contributing

Every change goes through a pull request with review. Bump `version` in `.claude-plugin/plugin.json` and add a [CHANGELOG.md](CHANGELOG.md) entry with each change. `scripts/check.sh` runs the same checks as CI.

This repository never holds project or customer data: project facts live in PlannerQ.

## Licence and name

Copyright 2026 Barna Jankacs. The code is licensed under the [Apache License 2.0](LICENSE). The licence doesn't grant any rights to the PlannerQ name or logo; see [TRADEMARKS.md](TRADEMARKS.md).
