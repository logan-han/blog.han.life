---
title: "Lets Encrypt nginx SSL certificate renewal via cron"
date: "2015-11-18"
---

Add below as a cron entry. \[code lang="bash"\] #!/bin/bash /path/letsencrypt/letsencrypt-auto --server https://acme-v01.api.letsencrypt.org/directory --renew-by-default -a webroot --webroot-path /webroot/ --email youremail --text --agree-tos --agree-dev-preview -d 7979.us -d www.7979.us auth /etc/init.d/nginx reload \[/code\]

Then configure nginx SSL like below. \[code\] listen 443 ssl; ssl\_certificate /etc/letsencrypt/live/7979.us/fullchain.pem; ssl\_certificate\_key /etc/letsencrypt/live/7979.us/privkey.pem; ssl\_protocols TLSv1 TLSv1.1 TLSv1.2; ssl\_prefer\_server\_ciphers on; ssl\_ciphers HIGH:!aNULL:!MD5:!3DES;

You may want to replace openssl default Diffie-Hellman (DH) key for enhanced security. /usr/bin/openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096

Then add below into nignx SSL config: ssl\_dhparam /etc/ssl/certs/dhparam.pem;

Q: What if I want to put SNI for all the domain including reverse proxy? A: Put conditional redirect in nginx for ACME to point the same path and add sni with -d switch

location /.well-known/acme-challenge { alias /weboot/.well-known/acme-challenge; } location / { return 301 https://$server\_name$request\_uri; } \[/code\] Remember this will expose your domain structure in certificate.
