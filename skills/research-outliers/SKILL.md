---
name: research-outliers
description: Find viral, breakout, over-performing videos ("outliers") on YouTube, TikTok and Instagram, videos that got many times their channel's average views, for a topic, a creator's @handle or profile URL, or a single video URL. Explain why a video took off with an AI breakdown, draft the user's own version for their accounts, and save the best to their ViewsMax library. Use when the user asks for video or post ideas, what's working or blowing up in a niche, viral or breakout videos, hidden gems from small channels, a competitor's best videos, hooks worth copying, or why a specific video took off. Needs only a ViewsMax login; no social accounts have to be connected, so never call list_connected_accounts for research.
allowed-tools:
  - mcp__plugin_viewsmax_viewsmax__list_outliers
  - mcp__plugin_viewsmax_viewsmax__search_outliers
  - mcp__plugin_viewsmax_viewsmax__fetch_outlier
  - mcp__plugin_viewsmax_viewsmax__get_outlier
  - mcp__plugin_viewsmax_viewsmax__get_outlier_breakdown
  - mcp__plugin_viewsmax_viewsmax__generate_outlier_breakdown
  - mcp__plugin_viewsmax_viewsmax__get_outlier_channel_ingest
  - mcp__plugin_viewsmax_viewsmax__list_saved_outliers
---

# Research outlier videos with ViewsMax

`outlier_score` is a video's views divided by its channel's average views. 50 means
50x the channel's norm. Scores above about 100 usually mean the channel's recorded
average is tiny, so always show `channel.average_views` next to the score.

Research needs only a ViewsMax login. Never call `list_connected_accounts` or ask the
user to connect social accounts for it. If invoked with arguments, `$ARGUMENTS` is the
topic, URL or @handle.

## Route the request

- A video URL: go to **Study one video**.
- A creator @handle or profile URL: go to **A creator's videos**.
- A topic or niche: go to **Find outliers for a topic**.
- Nothing specific ("show me outliers", "what's blowing up"): go to **No topic given**.

## Find outliers for a topic

1. Call `list_outliers` with `query` set to the topic, `sort_by: "score"` and
   `per_page: 20`. Add only the filters the user named: `platform`, `duration_type`
   (`long` or `shorts`), `min_views`, `min_subs`, `max_subs`, `published_after`,
   `countries`. Don't ask clarifying questions first; a first table beats a perfect
   query, and you can refine after.
2. If `status` is `queued` or `in_progress`, or fewer than about five usable rows came
   back:
   - If the user asked for TikTok or Instagram, don't call `search_outliers`; it
     searches YouTube only. Say so, and offer to pull in a creator's recent videos from
     their @handle or to analyse a pasted link.
   - Otherwise call `search_outliers` once with `term` set to the topic. Use
     `exact_match: true` only for names or exact phrases. Never start a second search
     for the same term in this conversation.
   - Show any rows the first call returned, labelled "Already indexed, more arriving".
   - End the turn with: "I've started a YouTube search for *<topic>*; results land in
     about 1 to 2 minutes. Say *check again*." Don't poll, sleep or loop inside the turn.
   - On "check again", call `list_outliers` once more with the same parameters. If
     `done`, present the results; if not, repeat the line once.
3. Present the results (see **Presenting results**).

## No topic given

Don't call `list_outliers` with no parameters: the bare feed is ordered newest-first and
includes videos that under-performed their channel. Don't use `featured: true` unless
the user asks for ViewsMax picks.

Ask one question: "What niche are you in?" with two or three examples (home workouts,
personal finance, woodworking), and add: "or say *anything* and I'll show the biggest
over-performers across ViewsMax's whole database." Then run **Find outliers for a topic**.

Only if the user chooses the browse, call `list_outliers` with `sort_by: "score"`,
`duration_type: "long"`, `min_views: 100000`, `min_subs: 10000`, `platform: "youtube"`,
`published_after` set to the ISO date 60 days ago, and `per_page: 30`. Don't use
`countries` as a language proxy. Skip titles not in the user's language and rows whose
comment count is implausibly low for their views. Title the table "Biggest
over-performers in ViewsMax's database, last 60 days" and say the database is built from
topics people have searched.

## Study one video

- Call `fetch_outlier` with `platform` and `url`. If `queued: true`, poll `get_outlier`
  (platform, video_id) about every 15 seconds until `status` is `ready`. YouTube and
  TikTok usually land within a minute; Instagram can take several minutes, so tell the
  user and keep going. An error means the fetch failed; report it.
- Show its row with the standard columns, then call `get_outlier_breakdown`:
  - `none`: call `generate_outlier_breakdown`, then check again.
  - `pending` or `processing`: wait, then check again.
  - `completed`: summarize the hook, structure, why it worked, and how the user could
    adapt it to their own channel.
  - `failed`: report the error.

## A creator's videos

Tell the user first that this also adds the creator to their ViewsMax competitor list.
Then call `add_outlier_channel` with `input` (and `platform` for a bare @handle). If
`status` is `done`, the channel was pulled in the last 24 hours; use its `channel.id`.
If `queued: true`, poll `get_outlier_channel_ingest` with the `ingest_id` every 5 to 10
seconds until `done` (10 to 60 seconds); on `failed`, report `error`. Then call
`list_outliers` with `channels: [channel.id]` and `sort_by: "score"` (add
`duration_type: "shorts"` for TikTok or Instagram). Present the results.

## Presenting results

- One table of long-form rows (`is_short` false), up to 8, in the order the API
  returned them. If Shorts are in the results, add a second table of up to 4. If the
  user asked for Shorts only, one table of up to 8. Offer page 2 instead of printing
  everything.
- Columns: #, Title (linked to `url`, with length from `duration`, such as "29 min" or
  "0:06"), Channel (subscribers), Views, Outlier, Posted. Add Platform only when rows mix
  platforms.
- Outlier cell: whole-number score with the channel average, such as "44x (avg 983k)".
  Write "no baseline" when `channel.average_views` is null and order those rows by views.
  Drop rows with a score under 1 and a non-null average, and say how many you dropped.
- Under the table, one caveat line only when triggered: scores above about 100x usually
  reflect a tiny recorded channel average, not a stronger video; name a row that looks
  like paid promotion when likes are near zero on a million-plus views.
  `engagement_rate` is already a percentage; 0 likes with 0 comments usually means
  hidden likes, not zero engagement.
- Patterns: up to three bullets on what the top rows share (hook wording, format,
  length, channel size). Label each as observed or inferred.
- Next: exactly three numbered options the user can answer with a number:
  1. Break down #N: hook, structure and why it beat the channel's average.
  2. Draft my own version of #N for my accounts and post it everywhere. (Hand off to
     the publish-post skill; it handles connecting accounts if none are connected.)
  3. Save #N to your ViewsMax library, tagged with the topic.
  If the user wants a different slice instead, offer one refinement that fits the data:
  small channels only (`max_subs: 50000`), Shorts or long-form only, last 90 days, or
  pull in the top channel's recent videos.

## Save to the library

- `save_outlier` bookmarks a video, with optional tags. Saving the same video again
  replaces its tags, so include existing tags the user wants to keep.
- `list_saved_outliers` shows the library, filtered by query, tags, platforms, or
  creator.
- `remove_saved_outlier` removes a saved item using its saved id. Confirm first.

## If ViewsMax tools are missing or a call fails with "not authorized"

ViewsMax signs in with OAuth the first time it is used. Don't retry blindly and never
ask for tokens, codes or callback URLs. Tell the user how to sign in where they are,
then retry once when they say so:

- Claude Code: run `/mcp`, choose viewsmax, select Authenticate, and sign in in the
  browser that opens. Then say *try again*. Non-interactive runs (`claude -p`, cloud
  sessions) can't complete sign-in; do it once in an interactive session.
- claude.ai, Claude Desktop, Cowork: open Settings, then Connectors (or the plugin's
  Connectors tab), choose ViewsMax, select Connect and approve access. Then say *try
  again*.
- No ViewsMax account yet: viewsmax.com. Free to start, no card, and no social accounts
  are needed for research.

If two ViewsMax servers are present (the plugin's and a claude.ai connector) and one
already works, use it and don't ask the user to sign in twice.

## Limits

`search_outliers`, `fetch_outlier`, `add_outlier_channel` and
`generate_outlier_breakdown` are rate-limited per hour; `list_outliers` is not. On a
limit error, name the action that is limited, show what you already have, and offer the
instant alternatives. Don't retry, don't loop, don't suggest upgrading or mention prices.
