---
title: "Selenium test with docker-compose"
date: "2017-05-23"
---

Sample config file when using selenium standalone during test.

docker-compose YAML 
```yaml
version: '3'
  services:
    test:
      depends_on:
        - selenium
      environment:
        - E2ETEST_HOST=test
        - SELENIUM_PORT=4444
        - SELENIUM_HOST=selenium
      build:
        context: .
        dockerfile: Dockerfile
      ports:
        - 80
        - 443
      command: run_test.sh
    selenium:
      image: selenium/standalone-chrome
      ports:
        - 4444
```

nightwatch config sample 

```yaml
"test_settings": {
    "default": {
        "selenium_port"  : parseInt(process.env.SELENIUM_PORT) || 4444,
        "selenium_host"  : process.env.SELENIUM_HOST,
        "silent": true,
        "desiredCapabilities": {
            "browserName": "chrome",
            "javascriptEnabled": true,
            "acceptSslCerts": true,
            "chromeOptions" : {
                "args" : ["--no-sandbox"]
            }
        }
    }
```

run_test.sh

```yaml
docker-compose down
docker-compose up --force-recreate --build --abort-on-container-exit --exit-code-from test test
```