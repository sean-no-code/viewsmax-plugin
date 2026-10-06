---
expect:
  platform: string
---

{
  "platform": "{{input.platform}}",
  "connect_page_url": "https://viewsmax.com/dashboard/connections",
  "instructions": "Open this page in a browser, sign in if needed, and click Connect next to {{input.platform}}. Approval happens in a popup there; afterwards list_connected_accounts will show the new account."
}
