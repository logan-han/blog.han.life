---
title: "How to increase VM disk size without re-deploy the machine"
date: "2012-07-13"
---

Ref: http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT\_KB\_1\_1&externalId=1006371

\[root@demo ~\]# fdisk /dev/sda

\-Create a primary partition-

\[root@demo ~\]# fdisk -l

Device Boot Start End Blocks Id System /dev/sda1 \* 1 64 512000 83 Linux Partition 1 does not end on cylinder boundary. /dev/sda2 64 1306 9972736 8e Linux LVM /dev/sda3 1306 6527 41942367+ 83 Linux

\[root@demo ~\]# pvcreate /dev/sda3 \[root@demo ~\]# vgextend vg\_demo /dev/sda3

\[root@demo ~\]# vgdisplay vg\_demo | grep Free Free PE / Size 10239 / 40.00 GiB

\[root@demo ~\]# lvextend -L+40.00G /dev/vg\_demo/lv\_root

\[root@demo ~\]# resize2fs /dev/vg\_demo/lv\_root

Note: I wouldn't do this for any production system as it looks pretty inefficient way to extend volume size.
