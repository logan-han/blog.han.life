---
title: "Using additional public ip address over pppoe nat with cisco router"
date: "2011-09-30"
---

To allocate router a non-NAT IP (for AWS VPC etc etc)

1\. Create a loopback interface and put given ip & subnet 2. profit!

Otherwise,

ip nat inside source route-map NONAT interface Dialer1 overload ip nat inside source static 192.168.?.? PUBLIC\_IP\_HERE
