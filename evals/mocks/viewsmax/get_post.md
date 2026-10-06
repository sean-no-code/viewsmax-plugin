---
expect:
  id: number
---

{
  "id": "{{input.id}}",
  "status": "draft",
  "scheduled_at": null,
  "media": [],
  "targets": [
    {
      "platform": "x",
      "status": "pending",
      "error": null
    },
    {
      "platform": "linkedin",
      "status": "pending",
      "error": null
    },
    {
      "platform": "threads",
      "status": "pending",
      "error": null
    }
  ],
  "publish_result": {
    "state": "draft",
    "message": "Saved as a draft. Nothing has been published."
  }
}
