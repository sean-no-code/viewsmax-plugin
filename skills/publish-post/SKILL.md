---
name: publish-post
description: Compose, schedule, or publish a social post to the user's connected social accounts (such as YouTube, TikTok, X, LinkedIn, Threads, Instagram, or Bluesky) through ViewsMax, and check whether it published. Use when the user wants to post, cross-post, schedule, or draft social content, or asks why a ViewsMax post failed.
---

# Publish a post with ViewsMax

Publishing to a social platform is public and can't be undone. Save a draft
unless the user has clearly asked to publish or schedule.

## Fast path: one caption, every text account

When the user gives a caption or idea and no targets, media or timing:

1. Call `list_connected_accounts`. Target every connected platform that needs no media
   (x, linkedin, threads, bluesky). Leave out TikTok, Instagram and YouTube unless the
   user named them or gave media.
2. Write the caption once, then `overrides` for any platform whose limit it exceeds
   (X 280, Bluesky 300, Threads 500, LinkedIn 3000). Keep the meaning, cut the length.
3. Show the per-platform text in one message and ask: post now, schedule, or save as a
   draft? One confirm, then `create_post`.
4. Call `get_post` and report per platform. Then offer one next step: plan the rest of
   the week (plan-content-calendar).

## 1. Check where the user can post

Call `list_connected_accounts`. If the user names a brand, also call
`list_brands` and use `brand_id` instead of `platforms`. Don't pass both.

If a requested platform isn't connected, call `get_connect_url` once and give the
user the link. Say that X, LinkedIn, Threads and Bluesky take about a minute each
and need no media, and ask them to say *connected* when done. Offer two things
meanwhile: save the post as a draft now (they can review it in the ViewsMax app
under Posts before it goes live) or research outliers for their niche. Don't call
`create_post` with `posted` for a platform that isn't connected; re-check
`list_connected_accounts` when they say *connected*.

## 2. Collect what the post needs

Ask only for what's missing:

- **Caption.** Stay within each platform's limit (listed in the `create_post`
  description). Use `overrides` when one platform needs a shorter or different
  caption, such as X's 280 characters.
- **Targets.** Platforms or a brand.
- **Timing.** Draft, publish now, or schedule. For a schedule, confirm the
  user's time zone and send `scheduled_at` as ISO-8601 with an offset, such as
  `2026-09-20T09:00:00-04:00`.
- **Media.** See the next step.

## 3. Prepare media

- The user's file has to be at a public https URL. Pass it to `upload_media`,
  then send the returned media entry to `create_post` unchanged.
- **YouTube** needs a video entry with a `path`, which only `upload_media`
  returns.
- **TikTok** needs a video with a `url` or one or more images (a photo
  slideshow).
- **Instagram** needs an image or video `url`.
- Never invent or guess a media URL. If the user only has a local file, ask
  them for a public link.

## 4. Platform options the user must choose

- **TikTok:** `options.tiktok.privacy_level` is required to publish or schedule
  and has no default. Ask the user to choose PUBLIC_TO_EVERYONE,
  MUTUAL_FOLLOW_FRIENDS, FOLLOWER_OF_CREATOR, or SELF_ONLY. Never choose it for
  them. Branded content can't be SELF_ONLY. Ask before turning on
  `auto_add_music` (photo slideshows only).
- **YouTube:** ask for `options.youtube.privacy_status` (public, unlisted, or
  private) if the user hasn't said.

## 5. Confirm, then create

Before publishing or scheduling, show the user:

- the accounts or brand,
- the caption per platform,
- the media,
- the time, and
- the privacy settings.

Wait for an explicit yes, unless the user has explicitly said not to ask in
future. If they say so, remember the preference (save it to memory when memory is
available) and apply it in later sessions, but still confirm the first post to any
platform they haven't posted to before. When in doubt, ask. Then call `create_post`
with `status` set to `posted`, `scheduled`, or `draft`.

## 6. Report the outcome

Publishing runs in the background. Call `get_post` with the returned id and
report each platform's status: pending, publishing, published, or failed. For a
failed target, pass on its error message in plain language and suggest the fix,
such as reconnecting the account or adding required media. If targets are still
pending, say so and offer to check again. End with one next step: plan the rest of
the week from this post (the plan-content-calendar skill).

## Editing and deleting

- `update_post` only works on draft or scheduled posts. A published post can't
  be edited.
- Setting `status` to `posted` in `update_post` publishes immediately, so
  confirm first.
- `delete_post` removes the post from ViewsMax only; content already live on a
  platform stays up. Tell the user that before deleting, and confirm.
- Drafts and scheduled posts can also be reviewed and edited in the ViewsMax app
  under Posts.

## Limits

If a tool reports a rate limit or a plan limit, explain it plainly and stop.
Don't retry in a loop, and don't recommend upgrading.
