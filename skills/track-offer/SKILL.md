---
name: track-offer
description: Set up ViewsMax tracking for a sponsorship, affiliate deal, product, or lead magnet — create the offer with its conversion goals and a tracked link for each place it will be promoted. Use when the user wants to know how many clicks, calls booked, email sign-ups, or sales a promotion drives.
---

# Track an offer with ViewsMax

An offer is a promotion the user wants to measure. Tracked links send visitors
to the offer, and goals record what counts as a conversion.

## 1. Avoid duplicates

Call `list_offers`. If an offer with the same landing page already exists,
offer to add links to it instead of creating a new one.

## 2. Create the offer

Collect:

- `offer_url`: the landing page. Required.
- `name`: a short label the user will recognise.
- `goals` (optional): one entry per conversion the user cares about.
  - `event_type`: for example `conversion`, `call booked`, or `email-signup`.
  - `conversion_url`: the thank-you or confirmation page that proves the
    conversion happened.
  - `conversion_value`: the value in the user's currency, if they know it.

Call `create_offer`. If it fails because of the user's plan offer limit, tell
the user and stop. Don't suggest upgrading or mention prices.

## 3. Create a link per placement

Ask where the offer will be promoted, then call `create_tracking_link` once per
placement with `tracking_event_id` set to the offer id.

- Valid `placement` values: `video`, `email`, `x`, `linkedin`, `podcast`,
  `blog`, `website`, `tiktok`, `ad`, `instagram`, `beehiiv`, `other`.
- For a specific YouTube video, pass `youtube_video_id`. The placement is set
  automatically.
- For a Beehiiv newsletter post, pass `beehiiv_post_id`.
- Give each link a `name` that identifies where it lives, such as
  "March newsletter" or "Bio link".

## 4. Hand back the links

Show a table with these columns: placement, name, and tracked URL. Tell the
user to use each link only in its own placement, so results stay separable.

If the user also wants to post about the offer now, use the publish-post skill.
Tracked links can go in captions, or pass `shorten_links: true` to
`create_post` to shorten any URL in the caption.

## Changes

- `update_offer` changes the name, landing page, or goals. Passing `goals`
  replaces the whole goal list, so include the existing goals the user wants to
  keep.
- `delete_offer` stops tracking and removes the offer. Confirm first, because
  its links stop being tracked.
