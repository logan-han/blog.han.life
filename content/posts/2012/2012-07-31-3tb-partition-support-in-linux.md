---
title: "3TB partition support in Linux"
date: "2012-07-31"
---

Make a GPT partition:

```sh
parted /dev/sda
mklabel gpt
unit TB
mkpart primary 0 -0
quit
```

Format with 1% root reservation:

`mkfs.ext4 -m1 /dev/sda1`

Note: HP Array controller may require firmware update for 3TB disk support.
