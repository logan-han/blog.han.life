---
title: "Lets Encrypt nginx SSL certificate renewal via cron"
date: "2015-11-18"
---

Add below as a cron entry. 
```sh
#!/bin/bash
/path/letsencrypt/letsencrypt-auto --server https://acme-v01.api.letsencrypt.org/directory --renew-by-default -a webroot --webroot-path /webroot/ --email youremail --text --agree-tos --agree-dev-preview -d 7979.us -d www.7979.us auth
/etc/init.d/nginx reload
```

Then configure nginx SSL like below. 
```sh
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/7979.us/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/7979.us/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers HIGH:!aNULL:!MD5:!3DES;
```

You may want to replace openssl default Diffie-Hellman (DH) key for enhanced security. 

`/usr/bin/openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096`

Then add below into nignx SSL config: 

`ssl_dhparam /etc/ssl/certs/dhparam.pem;`

Q: What if I want to put SNI for all the domain including reverse proxy? 

A: Put conditional redirect in nginx for ACME to point the same path and add sni with -d switch

```sh
location /.well-known/acme-challenge { alias /weboot/.well-known/acme-challenge; }
location / { return 301 https://$server_name$request_uri; }
```