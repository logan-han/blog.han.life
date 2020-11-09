---
title: "Convert .xva to .qcow2 (or raw)"
date: "2014-01-23"
---

Figured out while running below work.

Got the hint from: http://jolokianetworks.com/70Knowledge/Virtualization/Converting\_from\_Citrix\_XenServer\_to\_Xen\_open\_source/Xenmigrate.py And got modded .py from: http://pastebin.com/MK5Da8CB

1\. run tar -xvf {image}.xva

2. python xenmigrate.py  --convert=./Ref\\:directory\_here/ test.img

enmigrate 0.7.4 -- 2011.09.13 (c)2011 Jolokia Networks and Mark Pace -- jolokianetworks.com

convert ref dir : ./Ref:3660/ to raw file : test.img last file : 20484 disk image size : 20 GB

RW notification every: 1.0GB Converting: 1.0GBrw 2.0GBrw 3.0GBrw 4.0GBrw 5.0GBrw 6.0GBrw 7.0GBrw 8.0GBrw 9.0GBrw 10.0GBrw 11.0GBrw 12.0GBrw 13.0GBrw 14.0GBrw 15.0GBrw 16.0GBrw 17.0GBrw 18.0GBrw 19.0GBrw 20.0GBrw Successful convert

Then qemu-img convert -O qcow2 test.img test.qcow2
