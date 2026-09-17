---
title: "Ports for WDS"
date: "2015-03-31"
description: "The firewall ports Windows Deployment Services actually needs, which is more than the RPC and SMB pair every search result lists."
tags: ["windows", "networking"]
---

Ports for WDS

Google search said 'The following TCP ports need to be open for WDS to work across a firewall: 135 and 5040 for RPC and 137 thru 139 for SMB.'

Well.. it wasn't all.

After some f/w logging dive figured: SMB RPC TCP TFTP

and

tcp/5040 udp/4011
