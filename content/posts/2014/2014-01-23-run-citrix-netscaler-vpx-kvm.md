---
title: "Run Citrix NetScaler VPX from KVM"
date: "2014-01-23"
---

1\. Download Hyper-V image and extract .vhd

2\. Covert it via running: qemu-img convert -O qcow2 NSVPX-ESX-10.1-119.7\_nc-disk1.vhd NSVPX-XEN-10.1-119.7\_nc.qcow2

3\. Create a VM, mount the image.

4. Login via nsroot/nsroot and run 'config ns' for initial network setup. Oddly, this menu doesn't list routing option including default gateway. Add it manually via 'config add route 0.0.0.0 255.255.255.255 your\_gateway\_ip'

P.S: choose virtual interface type as 'virtio' seems like e1000 is not working for some reason P.S2: The 'Host ID' for license is mac address of the interface without :
