---
title: "Puppet Dell iDRAC control"
date: "2014-07-04"
---

```ruby
if $::manufacturer == 'Dell Inc.' {
    exec { 'Disable DRAC SNMP':
        command =>; 'racadm config -g cfgOobSnmp -o cfgOobSnmpAgentEnable 0',
        path =>; '/opt/dell/srvadmin/sbin:/bin',
        onlyif =>; '/usr/bin/test `/opt/dell/srvadmin/sbin/racadm getconfig -g cfgOobSnmp -o cfgOobSnmpAgentEnable` -eq 1',
    }
}
```
Yea, I think onlyif bit is not nice.
