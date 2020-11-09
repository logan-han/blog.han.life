---
title: "Cisco Router config for ACME PACKET"
date: "2011-12-21"
---

`sip-ua`

 `authentication username` `-snip-` `password` `7` `-snip-`

 `registrar dns:realm.domain expires` `3600`

 `sip-server dns:`realm.domain

 `connection-reuse`

``

`voice service voip`

 `no ip address trusted authenticate`

 `allow-connections sip to sip`

 `no supplementary-service sip moved-temporarily`

 `fax protocol pass-through g711alaw`

 `modem passthrough nse codec g711alaw`

 `sip`

 `localhost dns:realm.domain`

 `outbound-proxy dns:sip-server`

Note: realm.domain doesn't have to be real(public) domain.

Each phone-dn will have own registration.

``
