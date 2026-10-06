---
name: start
description: First-run guide for ViewsMax in Claude. Checks which social accounts are connected, gets the user a result right away (a first post across their accounts, or outlier research for their niche plus the link to connect accounts), and sets up the next step. Use when the user has just installed or connected ViewsMax, asks what ViewsMax can do, asks how to get started, or wants to make their first post.
allowed-tools:
  - mcp__plugin_viewsmax_viewsmax__list_connected_accounts
  - mcp__plugin_viewsmax_viewsmax__list_brands
  - mcp__plugin_viewsmax_viewsmax__get_connect_url
  - mcp__plugin_viewsmax_viewsmax__list_outliers
  - mcp__plugin_viewsmax_viewsmax__get_post
---

# Start with ViewsMax

Goal: a real result in this turn, then one obvious next step toward posting across
accounts. Don't list features; do one thing.

1. Call `list_connected_accounts`. If no ViewsMax tools are available, or the call fails
   with an authentication error, give the sign-in steps below and stop.
2. **Accounts connected.** Say which accounts are connected in one line. Then: "Give me
   one idea, a link, or a video you liked and I'll write it for <connected text
   platforms> and post it to all of them at once." If `$ARGUMENTS` already holds the
   idea, go straight to the publish-post skill's fast path. If only TikTok, Instagram or
   YouTube are connected, say those need a video or image at a public URL, offer to
   connect X, LinkedIn, Threads or Bluesky for text posts (link below), and ask for the
   media URL.
3. **No accounts connected.** Offer two ways to start, in one short message, and do
   whichever they pick. If `$ARGUMENTS` already names a topic or contains a post, skip
   the question and do that one.
   - "Find what's working: tell me what you make content about and I'll show the videos
     that beat their channel's average in your niche." Then run the research-outliers
     topic flow and show the table.
   - "Write your first post: give me one idea and I'll draft it for X, LinkedIn, Threads
     and Bluesky. You can review it in the ViewsMax app under Posts before it goes live,
     and schedule it for a time after your accounts are connected." Then follow the
     publish-post fast path and save it as a draft, or scheduled if they give a time
     (remind them the accounts must be connected before that time). `create_post`
     needs `platforms` even for a draft: pass the platforms they named, or
     `["x", "linkedin", "threads", "bluesky"]` if they named none.
   In the same reply, call `get_connect_url` once and add: "To publish, connect your
   accounts here: <connect_page_url>. X, LinkedIn, Threads and Bluesky take about a
   minute each and need no media. Say *connected* when you're done and I'll post it (or
   turn #N into your first post) across all of them."
4. On *connected*, call `list_connected_accounts` again and continue with step 2.
5. After the first post publishes, offer exactly one next step: "Want me to plan the
   rest of the week? I'll draft 3 to 5 posts from this and spread them across your
   accounts for you to approve." That is the plan-content-calendar skill.

Publishing is public. Always show the post and wait for a yes before publishing or
scheduling, unless the user has explicitly told you not to ask in future.

## Sign-in steps

- Claude Code: run `/mcp`, choose viewsmax, select Authenticate, sign in with your
  ViewsMax account (free to start, no card), then run `/viewsmax:start` again.
- Claude Desktop and Cowork: open Settings, then Connectors, connect ViewsMax, then run
  `/viewsmax:start` again.
- claude.ai: Customize, Connectors, ViewsMax, Connect.
