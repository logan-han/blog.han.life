---
title: Extract TLD from string by bash
date: 2021-06-25
description: extract TLD when .com & .co.uk are mixed

---
Faced this interesting use case when I need to extract TLD from the provided hostname string. 

Realised simply slicing two bits from the last won't cut when the hostname comes with mixed `.com` and `.co.uk` 

Found a good solution from an old article: https://ubuntuforums.org/showthread.php?t=873034

TR;DL:

```bash
$ export DOMAIN_NAME="mydomain.com"
$ export MAIN_DOMAIN_NAME=$(awk -F. '{if ($(NF-1) == "co") printf $(NF-2)"."; printf $(NF-1)"."$(NF)"\n";}' <<< ${DOMAIN_NAME})
$ echo $MAIN_DOMAIN_NAME
mydomain.com

$ export DOMAIN_NAME="mydomain.co.uk"
$ export MAIN_DOMAIN_NAME=$(awk -F. '{if ($(NF-1) == "co") printf $(NF-2)"."; printf $(NF-1)"."$(NF)"\n";}' <<< ${DOMAIN_NAME})
$ echo $MAIN_DOMAIN_NAME
mydomain.co.uk
```