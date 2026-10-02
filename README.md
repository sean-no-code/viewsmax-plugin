# ViewsMax for Claude

ViewsMax lets you publish and schedule social posts, track offers with tracked links, report on clicks and revenue, and research outlier videos, all from a conversation with Claude.

## What you need

- A ViewsMax account at [viewsmax.com](https://viewsmax.com).
- The social accounts you want to post to, connected in ViewsMax under **Dashboard → Connections**. Posting is available for YouTube, TikTok, X, LinkedIn, Threads, Instagram, and Bluesky.

The first time Claude uses a ViewsMax tool, you sign in to ViewsMax and approve access.

## What's included

**Connection:** one remote MCP server, `https://api.viewsmax.com/api/mcp`, which signs in with OAuth.

**Skills:**

| Skill | What it does |
|---|---|
| `publish-post` | Writes, schedules, or publishes a post to your connected accounts and reports whether it published. |
| `plan-content-calendar` | Shows what's scheduled for a period, and plans, moves, or cancels scheduled posts. |
| `track-offer` | Creates an offer with its conversion goals and a tracked link for each place it's promoted. |
| `report-offer-performance` | Summarizes views, clicks, calls booked, email sign-ups, and sales for your offers. |
| `research-outliers` | Finds videos that far outperformed their channel's average, explains why, and saves them to your library. |

## Example prompts

- "What social accounts do I have connected on ViewsMax?"
- "Post this video to YouTube and TikTok with the caption 'New workout tips': https://example.com/video.mp4"
- "Schedule 'Weekly tips' to Bluesky for tomorrow at 10am my time."
- "Create an offer called Spring Sale for https://example.com/sale and give me a tracked link for my YouTube description."
- "How are my offers doing this month?"
- "Find outlier videos about home workouts."

## Troubleshooting

- **A platform isn't listed or a post can't go to it:** connect that account in ViewsMax under **Dashboard → Connections**, then ask again.
- **A post failed:** ask Claude "Did that post publish?" It shows the reason for each platform, such as an account that needs reconnecting.
- **Claude can't reach ViewsMax:** reconnect ViewsMax from Claude's connector settings and sign in again.
- **Plans and billing:** these are managed on [viewsmax.com](https://viewsmax.com), not through Claude.

## What it sends and where

- The plugin talks only to the ViewsMax server above, over HTTPS. It runs no local scripts, hooks, or commands.
- Each tool call acts on your own ViewsMax account. Claude asks before publishing, and asks you to choose privacy settings where a platform needs them.
- Posts you publish go from ViewsMax to the social accounts you connected.
- Every tool call is recorded in your ViewsMax activity log (**Settings → AI Assistant Access**).

## Privacy and support

- Privacy policy: [viewsmax.com/privacy](https://viewsmax.com/privacy)
- Setup guide: [viewsmax.com/ai](https://viewsmax.com/ai)
- Support: [admin@iclicksee.com](mailto:admin@iclicksee.com)

## License

MIT. See [LICENSE](LICENSE).
