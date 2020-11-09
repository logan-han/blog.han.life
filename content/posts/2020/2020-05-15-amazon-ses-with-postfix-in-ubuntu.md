---
title: "Amazon SES with Postfix in Ubuntu"
date: "2020-05-15"
description: "HOWTO Setup AWS SES in Ubuntu"
---

Was looking at https://docs.aws.amazon.com/ses/latest/DeveloperGuide/postfix.html but it's not really working as it's missing some key commands.

Install packages `apt install -y postfix libsasl2-modules\` select 'no configuration'

Config files 
```sh
cp /usr/share/postfix/main.cf.debian /etc/postfix/main.cf
```

in `/etc/postfix/main.cf`
```sh
smtp_tls_note_starttls_offer = yes 
smtp_tls_security_level = encrypt 
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd 
smtp_sasl_security_options = noanonymous 
relayhost = [email-smtp.us-west-2.amazonaws.com]:587 
smtp_sasl_auth_enable = yes 
smtp_use_tls = yes 
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt 
mydestination = 
```

in `/etc/postfix/sasl_passwd`
```sh
[email-smtp.us-west-2.amazonaws.com]:587 USERNAME:PASSWORD
```

Apply configs and restart the service
```sh
newaliases 
postmap hash:/etc/postfix/sasl_passwd 
systemctl restart postfix
```

(optional) Test
```sh
sendmail -f EMAIL@FROM.com EMAIL@TO.com 
From: test 
Subject: test 
. 
```
then check /var/log/mail.log for -snip- status=sent (250 Ok -snip- 