# Security

## Reporting a vulnerability

Please report security problems privately, not in a public issue: use **"Report a vulnerability"** on this repository's **Security** tab (GitHub private vulnerability reporting). Include what you found, how to reproduce it and what it affects. We'll answer within a few working days and tell you when it's fixed.

This covers the plugin (skills, rules, hook, MCP configuration) and the PlannerQ MCP server at `https://app.plannerq.com/mcp`.

## Reporting an impersonating plugin

If you find a plugin, marketplace or install page that presents itself as PlannerQ but points to an MCP address other than `https://app.plannerq.com/mcp`, or that is installed from instructions not on plannerq.com or in the PlannerQ app, report it the same way. Include the link where you found it. Don't log in to it; if you already did, sign out of PlannerQ everywhere and tell us.

## What the plugin does on your machine

- One hook: when a session starts, it prints `rules/standard-rules.md` into Claude's context (`cat`, nothing else).
- One MCP server: `https://app.plannerq.com/mcp`, reached over HTTPS with your own PlannerQ login (OAuth). It acts with your rights in PlannerQ; it never receives your code unless you ask Claude to attach or paste it into an item.
- Skills are Markdown instructions. They run commands only through Claude Code, which asks you as your permission settings say.

## Safety rules built into the skills

- Text from outside the team (public bug reports) reaches Claude only after a team member has reviewed it, wrapped in `<untrusted>`, and the skills treat it as data.
- Skills show what they will save in PlannerQ and wait for a yes; they ask before pushing, opening pull requests or anything visible outside your machine.
- Skills never put secrets or environment variable values into PlannerQ; the server also refuses profile text that looks like a secret.
