---
title: "Amazon SES with Postfix in Ubuntu"
date: "2020-05-15"
---

Was looking at https://docs.aws.amazon.com/ses/latest/DeveloperGuide/postfix.html but it's not really working as it's missing some key commands.

1\. Install packages \[code\]apt install -y postfix libsasl2-modules\[/code\] \* select 'no configuration'

2\. Config files \[code\] cp /usr/share/postfix/main.cf.debian /etc/postfix/main.cf

\[/code\] in /etc/postfix/main.cf \[code\] smtp\_tls\_note\_starttls\_offer = yes smtp\_tls\_security\_level = encrypt smtp\_sasl\_password\_maps = hash:/etc/postfix/sasl\_passwd smtp\_sasl\_security\_options = noanonymous relayhost = \[email-smtp.us-west-2.amazonaws.com\]:587 smtp\_sasl\_auth\_enable = yes smtp\_use\_tls = yes smtp\_tls\_CAfile = /etc/ssl/certs/ca-certificates.crt mydestination = \[/code\] /etc/postfix/sasl\_passwd \[code\] \[email-smtp.us-west-2.amazonaws.com\]:587 USERNAME:PASSWORD \[/code\]

3.Apply configs and restart the service \[code\] newaliases postmap hash:/etc/postfix/sasl\_passwd systemctl restart postfix \[/code\]

4\. (optional) Test \[code\] sendmail -f EMAIL@FROM.com EMAIL@TO.com From: test Subject: test .

then in /var/log/mail.log -snip- status=sent (250 Ok -snip- \[/code\]
