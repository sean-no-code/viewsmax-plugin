---
name: report-offer-performance
description: Summarize how the user's ViewsMax offers and tracked links are performing — video views, clicks, calls booked, email sign-ups, sales revenue, and daily click and revenue trends for a date range. Use for questions like "how did my offers do last month", "which offer made the most money", or "is traffic going up".
---

# Report offer performance from ViewsMax

## 1. Pin down the window

Use the dates the user gives. If they don't give any, use the last 28 days and
say so. Send `from`/`to` as ISO-8601 dates.

## 2. Pull the numbers

1. Call `get_offer_stats` for the window to get totals: video views, clicks,
   calls booked, email sign-ups, and sales revenue.
2. Call `get_stats_timeseries` for the same window to get daily clicks and
   attributed revenue. Add `event_id` when the user asks about one offer.
3. Call `list_offers` when the user wants a per-offer or per-link breakdown.
   Its results include each offer's links and stats.

## 3. Present it

Lead with a short answer to the user's question, then show:

- **Totals** for the window.
- **Top offers or links**, ranked by the metric the user cares about. If they
  didn't say, rank by revenue, then by clicks.
- **Trend:** compare the first and second half of the window, or week over
  week. Name the best and worst days.
- **Next step:** one or two concrete suggestions that follow from the numbers,
  such as moving a high-converting link to a busier placement.

## Accuracy rules

- Report only metrics the tools returned. If you calculate a rate, such as
  revenue per click, show the formula and label it as calculated.
- Zero-filled days in the time series mean no recorded activity. They don't
  mean missing data.
- If every metric is empty, say tracking may not be installed or links may not
  be live yet, and point the user to the track-offer skill. Don't guess why.
