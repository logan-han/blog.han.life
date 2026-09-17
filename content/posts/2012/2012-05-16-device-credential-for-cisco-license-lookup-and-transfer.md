---
title: "Device credential for Cisco license lookup and transfer"
date: "2012-05-16"
description: "Pulling the device credential off a Cisco box for licence lookup and transfer, and why SSH beats the serial console for it."
tags: ["cisco"]
---

  
https://tools.cisco.com/SWIFT/LicensingUI/LicenseAdminServlet/licenseLookup  
  
in CLI:  
```
license save credential flash0:/credentials.lic  
more flash0:/credentials.lic 
``` 
  
Try SSH if you can't get full strings from serial connection.
