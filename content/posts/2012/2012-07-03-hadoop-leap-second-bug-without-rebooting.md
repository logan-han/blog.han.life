---
title: "Fix Hadoop leap second bug without rebooting"
date: "2012-07-03"
description: "The 2012 leap second pinned Hadoop nodes at 100% CPU. Resetting the clock with date and restarting ntpd fixes it without a reboot."
tags: ["hadoop", "linux"]
---

Source: http://blog.wpkg.org/2012/07/01/java-leap-second-bug-30-june-1-july-2012-fix/

Applied our hadoop node having CPU usage issue. (CentOS)

```sh
service ntpd stop
date `date +”%m%d%H%M%C%y.%S”`
service ntpd start
```

Works like a charm!
