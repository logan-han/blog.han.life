---
title: "L2L VPN with ASA - Connection established but no packet coming from one side"
date: "2012-07-05"
description: "A site to site VPN on a Cisco ASA comes up but passes no packets one way, because the dynamic profile outranks the L2L one."
tags: ["cisco", "networking", "vpn"]
---

Symtom:

1\. Connection established.

2\. 0 en/decapsulated packet from one side.

Solution:

Seems like ASA pickup Dynamic VPN profile if it has higher priority than L2L.

Resolved after change dynamic profile priority.

Reference: https://supportforums.cisco.com/thread/227711
