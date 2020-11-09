---
title: "Disable msi with minimal interruption"
date: "2013-10-14"
---

ifconfig eth0 down rmmod bnx2 modprobe bnx2 disable\_msi=1 ifconfig eth0 up route add -net default netmask 0.0.0.0 gw \[default gw here\] eth0

For bonding interface:

ifconfig bond0 up ifenslave bond0 eth0 ifenslave bond0 eth1
