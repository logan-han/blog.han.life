---
title: "Hue with LDAP doesn't start up after Cloudera Manager upgrade"
date: "2015-02-03"
---

Latest Cloudera Manager omit ldap\_username\_pattern entry from hue.ini build process.

Paste below into safety valve as a workaround.

`[desktop] [[ldap]] ldap_username_pattern="username=,ou=user,dc=7979,dc=us"`

P.S: Had some weird experience without ""
