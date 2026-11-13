# Security checklist

Used for whole-repository reviews, and for changes when Claude Code's built-in security review is not available. Report only weaknesses with a concrete path to harm.

## Auth
- Every server route, API handler and server action checks the user before doing anything; there is no route that trusts a user id sent by the client.
- Session and token checks verify signature, issuer, audience and expiry.
- Admin-only actions check the role on the server, not only by hiding the button.

## Data access
- Every query is limited to what the user may see (tenant / workspace / owner), in the database (row-level security) or in every query.
- No mass assignment: request bodies can't set owner, role, workspace or price fields.
- No SQL, NoSQL or command injection: parameters, not string building.

## API routes and webhooks
- Webhooks verify their signature on the raw body before parsing.
- Public endpoints are rate-limited, validate input size and type, and return no internal errors.
- CORS and CSRF: cookies-based routes aren't callable cross-site; CORS doesn't allow any origin with credentials.
- Redirects only to allowed destinations (no open redirect).

## File uploads
- Size limits; type checked from the bytes, not the name or the declared type; no SVG or HTML served from the app's origin.
- Stored files are private unless meant to be public; download links are short-lived.

## Output
- User text is escaped when rendered (no raw HTML from users, no `dangerouslySetInnerHTML` with user input).
- Error messages and logs hold no secrets, tokens or personal data beyond what is needed.

## Secrets
- No keys, tokens, passwords or connection strings in the repository (also in tests, fixtures, docs and git history: `git log -p -S` for suspicious strings).
- Server-only keys never reach browser bundles (e.g. `NEXT_PUBLIC_` / `VITE_` prefixes on secrets).

## Dependencies
- Advisory check of the stack (`pnpm audit`, `npm audit`, `pip-audit`, …); only advisories reaching used code count.
- Lock file committed; no packages installed from unpinned URLs.

## By stack (apply what the profile lists)
- **Supabase / Postgres:** RLS enabled on every table in exposed schemas, with policies for each operation; `SECURITY DEFINER` functions set `search_path` and are revoked from `anon` and `authenticated` by name unless meant to be called; the service role key used only on the server; storage buckets private with policies.
- **Clerk (or another auth provider):** server routes call the provider's server check; webhooks verified (Svix); public routes listed deliberately in the middleware.
- **Next.js:** server actions and route handlers check the user; no secrets in client components; `headers()`/`cookies()` not trusted for identity without verification.
- **Public forms:** bot check (e.g. Turnstile) verified on the server, rate limit, input stripped of invisible and control characters, size limits.
- **AI features:** text from outside the team is treated as data (prompt injection), outputs aren't executed, tool use is limited.
- **Hosting (Vercel, Netlify, …):** preview deployments don't expose production data or secrets; environment variables are scoped per environment.
