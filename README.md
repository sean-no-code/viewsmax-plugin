# ViewsMax for Claude

Post once and publish everywhere: YouTube, TikTok, X, LinkedIn, Threads, Instagram and Bluesky. Find the videos that massively outperformed their channel first, remake them for your niche, then plan the week, all from a conversation with Claude.

## Try it in 60 seconds

You need a ViewsMax account ([viewsmax.com](https://viewsmax.com), free to start, no card).

1. Install (see your app below) and sign in when Claude asks.
2. Say **"Start with ViewsMax"** (in Claude Code: `/viewsmax:start`). Claude checks your accounts and does one of two things:
   - **Accounts connected:** give it one idea. It writes the post for X, LinkedIn, Threads and Bluesky, shows you each version, and publishes to all of them after you say yes.
   - **Nothing connected yet:** pick one. Tell it what you make content about and it shows the videos that beat their channel's average in your niche. Or give it one idea and it drafts your first post for X, LinkedIn, Threads and Bluesky, which you can review in the ViewsMax app under Posts before it goes live. Either way it gives you the link to connect your accounts (about a minute each). Say *connected* and it publishes your first post everywhere.
3. Then say **"plan the rest of the week"** and approve the 3 to 5 posts it drafts.

Posting is public, so Claude always shows you the post and waits for a yes. Drafts can also be reviewed in the ViewsMax app under Posts.

## Make it a weekly habit

Ask Claude once a week: "Draft this week's ViewsMax posts from my best-performing post and my saved outliers, spread them across my accounts, and show me what to approve." To automate the reminder, Claude Code Desktop and Cowork can run that as a local scheduled task ("every Monday at 9am, ..."), and claude.ai Pro and Max can run it as a cloud routine with `/schedule`. Keep it on drafts; approve before anything publishes.

## Install

**claude.ai, Claude Desktop and Cowork:** add ViewsMax from the Claude plugin directory (Customize, then Plugins), or add the marketplace `sean-no-code/viewsmax-plugin` and install the ViewsMax plugin. Open the plugin's Connectors tab and select Connect. Plugins sync with your claude.ai account, so it also appears in Claude Code.

**Claude Code** (v2.1.275 or later), inside a session:

```
/plugin install viewsmax --marketplace sean-no-code/viewsmax-plugin
```

Older versions: `/plugin marketplace add sean-no-code/viewsmax-plugin` then `/plugin install viewsmax@viewsmax`. Then run `/mcp`, select viewsmax, and sign in. Skills appear as `/viewsmax:start`, `/viewsmax:publish-post`, and so on.

**Connector only (no skills):** in claude.ai, Customize, Connectors, Add custom connector, paste `https://api.viewsmax.com/api/mcp`, Connect.

### Already using the ViewsMax connector?

Nothing changes. The plugin uses the same server, so in claude.ai, Desktop and Cowork its Connectors tab already shows Connected and the skills work right away. In Claude Code you may see the plugin's own ViewsMax server listed as needing authentication in `/mcp`; the skills still work through your connector, and signing in to it once removes the notice. Don't also add the server with `claude mcp add`; that creates a duplicate that needs its own sign-in.

## What you need

| To do this | You need |
|---|---|
| Research outliers, get AI breakdowns, draft posts, save videos to your library | A ViewsMax account. Nothing else. |
| Publish or schedule posts, track offers, report performance | A ViewsMax account **and** the social accounts you post to, connected under **Dashboard, Connections**. X, LinkedIn, Threads and Bluesky post text with no media; TikTok, Instagram and YouTube need a video or image at a public URL. |

## What's included

**Connection:** one remote MCP server, `https://api.viewsmax.com/api/mcp`, which signs in with OAuth.

**Skills:**

| Skill | What it does |
|---|---|
| `start` | Checks your accounts, gets you a first result, and sets up your first cross-post. |
| `publish-post` | Writes, schedules, or publishes a post to your connected accounts and reports whether it published. |
| `plan-content-calendar` | Shows what's scheduled for a period, builds a week of posts from one idea, and moves or cancels scheduled posts. |
| `research-outliers` | Finds videos that far outperformed their channel's average, explains why, drafts your version, and saves them to your library. |
| `track-offer` | Creates an offer with its conversion goals and a tracked link for each place it's promoted. |
| `report-offer-performance` | Summarizes views, clicks, calls booked, email sign-ups, and sales for your offers. |

Outlier research covers YouTube by topic search; TikTok and Instagram videos are added individually by URL or creator handle. A topic that has never been searched takes 1 to 2 minutes the first time.

## Example prompts

- "Start with ViewsMax"
- "Post this to all my accounts: <your caption>"
- "Find outlier videos about <your niche> and draft my version for X and LinkedIn."
- "Plan and schedule this week's posts across my accounts."
- "Why did this video blow up? Break down the hook and structure: <link>"
- "Create an offer called Spring Sale for https://example.com/sale and give me a tracked link for my YouTube description."
- "How are my offers doing this month?"

## Troubleshooting

- **Claude says ViewsMax needs to sign in, or the tools aren't available:** in Claude Code run `/mcp`, select viewsmax, Authenticate; in claude.ai open Customize, Connectors, ViewsMax, Connect. Sign-in can't be completed in a non-interactive session.
- **Claude says an account isn't connected:** open [viewsmax.com/dashboard/connections](https://viewsmax.com/dashboard/connections), click Connect next to the platform, then tell Claude *connected*.
- **A platform isn't listed or a post can't go to it:** connect that account in ViewsMax under **Dashboard, Connections**, then ask again.
- **A post failed:** ask Claude "Did that post publish?" It shows the reason for each platform, such as an account that needs reconnecting.
- **Claude can't reach ViewsMax:** reconnect ViewsMax from Claude's connector settings and sign in again.
- **Plans and billing:** these are managed on [viewsmax.com](https://viewsmax.com), not through Claude.

## What it sends and where

- The plugin talks only to the ViewsMax server above, over HTTPS. It runs no local scripts, hooks, or commands.
- `plugin.json` and `mcp.json` at the repo root are the agent-plugins.org manifests read by ChatGPT and other AI agents; Claude reads `.claude-plugin/plugin.json` and `.mcp.json`. The plugin is Markdown and JSON only: no hooks, agents, scripts or executables.
- Each tool call acts on your own ViewsMax account. Claude asks before publishing, and asks you to choose privacy settings where a platform needs them.
- Posts you publish go from ViewsMax to the social accounts you connected.
- Every tool call is recorded in your ViewsMax activity log (**Settings, AI Assistant Access**).

## Development

Two checks run before changes go live, both from the repo:

- **Before every commit** (`.githooks/pre-commit`): `scripts/check.sh` validates the manifests, version agreement, skill frontmatter against the claude.ai allow-list, description lengths, and runs `claude plugin validate .`. No model calls.
- **Before every push** (`.githooks/pre-push`): `claude plugin eval . --tag smoke` runs the cases under `evals/` against a mocked ViewsMax server in `evals/mocks/viewsmax/`, so nothing is posted and no sign-in is needed. The `create_post` mock rejects any call without `platforms`, and graders check which tools each skill called and what it said. Each case is one model run on your account.

Install the hooks once with `scripts/setup-hooks.sh`. Skip a hook once with `SKIP_CHECKS=1` or `SKIP_EVALS=1`. The same checks run in GitHub Actions (`.github/workflows/check.yml`); the eval job needs an `ANTHROPIC_API_KEY` repository secret. Before a release, run the full comparison with `claude plugin eval .` (three runs per case, with and without the plugin) and open the HTML report under `evals/results/`.

## Privacy and support

- Privacy policy: [viewsmax.com/privacy](https://viewsmax.com/privacy)
- Setup guide: [viewsmax.com/ai](https://viewsmax.com/ai)
- Support: [admin@iclicksee.com](mailto:admin@iclicksee.com)

## License

MIT. See [LICENSE](LICENSE).
