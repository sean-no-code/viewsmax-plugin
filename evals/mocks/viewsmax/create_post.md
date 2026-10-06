---
expect:
  caption: string
  platforms: array
  status: [draft, scheduled, posted]
---

{
  "id": 999,
  "caption": "{{input.caption}}",
  "status": "{{input.status}}",
  "scheduled_at": null,
  "media": [],
  "targets": "one pending target per platform in the request",
  "publish_result": {
    "state": "{{input.status}}",
    "message": "Saved. Nothing has been published."
  }
}
