---
title: "Generate Bacula client cert/key pair via Puppet"
date: "2014-05-28"
---

`exec {'generate client key file': command => '/usr/bin/openssl genrsa -out /bacula/bacula-client.key 2048;chmod 600 /bacula/bacula-client.key', creates => '/bacula/bacula-client.key', require => Package['bacula-fd'], }

exec {'generate client cert file': command => '/usr/bin/openssl req -new -key /bacula/bacula-client.key -x509 -subj "/C=AU/ST=somewhere/L=somewhere/O=something/CN=something" -out /bacula/bacula-client.cert', creates => '/bacula/bacula-client.cert', require => [ Package['bacula-fd'], Exec['generate client key file'], ], }

exec {'combine client key and cert files': notify => Service["bacula-fd"], command => '/bin/cat /bacula/bacula-client.key /bacula/bacula-client.cert > /bacula/bacula-client.pem;chmod 600 /bacula/bacula-client.pem', creates => '/bacula/bacula-client.pem', require => [ Package['bacula-fd'], Exec['generate client key file'], Exec['generate client cert file'], ], }`

Would be nicer if I can send them to backup location but doesn't really matter as there's master key.
