---
title: "Foreman + Puppet autosign.conf doesn't work"
date: "2014-09-08"
---

Issue: 1. Foreman generates auto sign entry when /provision called first time. (boot loader hit) 2. Once OS is done and call puppet agent run, CSR doesn't get auto-signed. - stays in 'pending' status forever

Apache passenger log indicates: "GET /certificate/blah.com? HTTP/1.1" 404 4507 "-" "-" "GET /certificate\_request/blah.com? HTTP/1.1" 404 4507 "-" "-" "PUT /certificate\_request/blah.com HTTP/1.1" 400 4491 "-" "-" "GET /certificate/blah.com? HTTP/1.1" 404 4507 "-" "-" "GET /certificate\_request/blah.com? HTTP/1.1" 200 6043 "-" "-" "GET /certificate/blah.com? HTTP/1.1" 404 4507 "-" "-"

and this bit seems suspicious: "PUT /certificate\_request/blah.com HTTP/1.1" 400 4491 "-" "-"

Simulated the process from the shell:

curl -k -X PUT -H “Content-Type: text/plain” —data-binary @blah.csr https://blah:8140/production/certificate\_request/blah Permission denied - /var/lib/puppet/ssl/ca/serial

Turns out /var/lib/puppet/ssl/ca/serial doesn't have web user write permission as puppet keep overwrite its ownership permission and it doesn't match with apache paseenger runner.

Run again with permission you will see the result like:

\--- - !ruby/object:Puppet::SSL::CertificateRequest name: blah content: !ruby/object:OpenSSL::X509::Request {}

dn;tl solution: update puppet.conf to include serial = $cadir/serial { owner = service, group = service, mode = 664 } then it will change owner as passenger runner.
