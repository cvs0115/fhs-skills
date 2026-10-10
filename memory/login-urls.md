---
name: login-urls
description: "Login/start URLs for Toast and Restaurant365 used for payroll and scheduling (URLs only, no credentials)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 7ea7fc92-25d9-44aa-9b05-8ac214be32bf
  modified: 2026-10-08T01:19:37.845Z
---

User logs in themselves in the browser pane; never store or enter credentials.

- **Toast Web (labor reports):** https://www.toasttab.com/restaurants/admin/reports/home#labor-time-entries
  - Redirects to Toast sign-in. Store picker at top switches locations (store 122 = Cary 1, restaurant ID 366968).
- **Restaurant365 (R365):** https://identity.restaurant365.com/Account/Login
- **ADP RUN (payroll entry):** https://online.adp.com/signin/v1/?APPID=RUN&productId=80e309c3-70c3-bae1-e053-3505430b5495
- **R365 franchise site:** https://fhs4021089.restaurant365.com/ (Firehouse Subs instance; "fhs" = Firehouse Subs). User may add more R365 sites later.

Related: [[payroll-rules]]
