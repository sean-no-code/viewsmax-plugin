---
name: plan-content-calendar
description: Review, plan, or reshuffle the user's ViewsMax posting schedule — show what is scheduled for a period, spread new posts across days and platforms, move or cancel scheduled posts. Use for requests like "what's going out this week", "schedule these five posts across next week", or "move Tuesday's post to Friday".
---

# Plan a content calendar with ViewsMax

## 1. Set the window and time zone

Work out the date range the user means, such as "this week" or "next month".
If the user's time zone isn't clear from the conversation, ask. Send dates to
tools as ISO-8601, and show times to the user in their own time zone.

## 2. Show what's already planned

Call `list_posts` with `status: scheduled` and `from`/`to` set to the window,
and raise `limit` if the window is busy. Also check `status: draft` if the user
wants to schedule existing drafts.

Show a table sorted by time with these columns: date and time, platforms,
caption (first line), and post id. Point out empty days and days with several
posts on the same platform.

## 3. Propose a plan before changing anything

When the user wants new or moved posts, write out the proposed schedule first:
which post goes where and when. Account for gaps, the platforms the user
mentioned, and anything they said about cadence.

Only call `list_connected_accounts` if the plan includes platforms you haven't
confirmed are connected.

Change nothing until the user approves the plan.

## 4. Apply the approved plan

- **New posts:** follow the publish-post skill's media and platform-option rules
  (TikTok privacy level, YouTube privacy status, media requirements). Create
  each one with `create_post` and `status: scheduled` plus `scheduled_at`, or as
  a draft if details are still missing.
- **Moving a post:** call `update_post` with the post `id` and the new
  `scheduled_at`.
- **Cancelling a post:** either set it back to `draft` with `update_post`, or
  call `delete_post` if the user wants it gone. Confirm each deletion.

When you're done, call `list_posts` for the window again and show the final
calendar. Flag anything that failed validation and what it needs.

## Build a week from one idea

When the user gives one post, idea, link or outlier and asks for a week, or says
"more like this":

1. Call `list_connected_accounts`. Default to the text platforms (x, linkedin, threads,
   bluesky); include media platforms only if media is supplied.
2. Write 3 to 5 distinct posts (different hooks or angles, not rewordings), each within
   its platform limits (use `overrides`). Spread them over the user's window, one per
   day, at the times they gave or 9:00 in their time zone.
3. Show the proposed calendar and wait for approval. Then create each post with
   `create_post`, `status: "scheduled"` plus `scheduled_at`, or as drafts if the user
   prefers to review in the ViewsMax app under Posts.
4. Call `list_posts` for the window and show the final calendar.

## Make it a weekly habit

If the user wants this every week, suggest one of these; both run outside this plugin,
so don't set them up unless asked:

- Claude Code Desktop or Cowork: a local scheduled task, created by saying "every Monday
  at 9am, draft this week's ViewsMax posts for me to approve".
- claude.ai cloud routine (`/schedule` in Claude Code): the same prompt, running with
  the ViewsMax connector while the computer is off.

A routine must draft, not publish, unless the user has explicitly said otherwise and
asked you to remember it.

## Don't

- Don't set any post to `posted`. That publishes immediately and isn't part of
  calendar planning unless the user explicitly asks.
- Don't edit published posts. The tools refuse, so explain instead of retrying.
- Don't schedule or publish without the user's approval of the calendar, unless
  they have explicitly said not to ask in future.
