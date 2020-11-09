---
title: "F5 AAM Cache for app generated pages"
date: "2015-11-16"
---

Dynamic content requires cache-control(max-age) and/or expires header to be cached.

The headers also need to be honoured from AAM policy which is not enabled by default.

Debug header decode: `wainfodecode [X-WA-INFO header content]`

Force cache clean up: `wa_clear_cache`

Check cache stats: `tmsh show ltm profile web-acceleration [iapp name].app/[iapp name]_optimized-acceleration`

Reset stats: `tmsh reset-stats ltm profile web-acceleration [iapp name].app/[iapp_name]_optimized-acceleration`
