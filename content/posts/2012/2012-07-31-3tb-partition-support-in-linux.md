---
title: "3TB partition support in Linux"
date: "2012-07-31"
description: "Making a 3TB disk usable in Linux with a GPT label under parted and ext4 with 1% reservation, plus the HP array controller catch."
tags: ["linux", "storage"]
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
