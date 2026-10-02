---
name: research-outliers
description: Find and study outlier videos on YouTube, TikTok, and Instagram — content that massively beat its channel's average views — for a topic or a specific video, get an AI breakdown of the hook and structure, and save the best ones to the user's ViewsMax library. Use when the user wants video ideas, wants to know what's working in a niche, or asks why a video took off.
---

# Research outlier videos with ViewsMax

`outlier_score` is a video's views divided by its channel's average views. The
higher the score, the more the video beat its channel's norm.

## Find outliers for a topic

1. Call `list_outliers` with `query` set to the topic. Add filters the user
   mentions: platform, minimum score or views, subscribers, publish date,
   duration (`long` or `shorts`), or country.
2. If the response `status` is `queued` or `in_progress`, or the results are
   thin, call `search_outliers` with the same query. Use `exact_match` for
   exact phrases. Tell the user it takes a minute or two, then call
   `list_outliers` again until `status` is `done`.
3. Present the top results as a table with these columns: title, channel,
   platform, views, outlier score, and publish date. Point out patterns you can
   see in the titles and formats. Keep them separate from anything you infer.

## Study one video

- If the user gives a video URL, call `fetch_outlier`. If it comes back
  `queued: true`, call `get_outlier` with the returned platform and video_id
  until it's available.
- Call `get_outlier_breakdown`:
  - `none`: call `generate_outlier_breakdown`, then check again.
  - `pending` or `processing`: wait, then check again.
  - `completed`: summarize the hook, structure, why it worked, and how the user
    could adapt it to their own channel.
  - `failed`: report the error.

## Save to the library

- `save_outlier` bookmarks a video, with optional tags. Saving the same video
  again replaces its tags, so include existing tags the user wants to keep.
- `list_saved_outliers` shows the library, filtered by query, tags, platforms,
  or creator.
- `remove_saved_outlier` removes a saved item using its saved id. Confirm
  first.

## Limits

Searches, fetches, and breakdowns are rate-limited per hour. If a tool reports
a limit, say so and don't retry in a loop.
