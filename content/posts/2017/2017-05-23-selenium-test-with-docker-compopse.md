---
title: "Selenium test with docker-compose"
date: "2017-05-23"
---

In case using selenium standalone during test.

docker-compose YAML \[bash\] version: '3' services: test: depends\_on: - selenium environment: - E2ETEST\_HOST=test - SELENIUM\_PORT=4444 - SELENIUM\_HOST=selenium build: context: . dockerfile: Dockerfile ports: - 80 - 443 command: run\_test.sh selenium: image: selenium/standalone-chrome ports: - 4444 \[/bash\]

nightwatch config sample \[bash\] "test\_settings": { "default": { "selenium\_port" : parseInt(process.env.SELENIUM\_PORT) || 4444, "selenium\_host" : process.env.SELENIUM\_HOST, "silent": true, "desiredCapabilities": { "browserName": "chrome", "javascriptEnabled": true, "acceptSslCerts": true, "chromeOptions" : { "args" : \["--no-sandbox"\] } } } \[/bash\]

run\_test.sh \[bash\] docker-compose down docker-compose up --force-recreate --build --abort-on-container-exit --exit-code-from test test \[/bash\]
