---
title: "rpmlib(FileDigests) / rpmlib(PayloadIsXz) is needed"
date: "2015-05-06"
---

This means you are attemping to install a RPM created in CentOS6+ from CentOS5.

For backward compatibility, rebuild rpm like: `rpmrebuild -e -p xyz.rpm`

Then add below: `%define _binary_filedigest_algorithm 1 %define _binary_payload w9.gzdio`

Not sure why all the guys in Google search results says it's not gonna work blah..
