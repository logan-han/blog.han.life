---
title: "Selenoid Parallel CI testing"
date: "2020-05-12"
description: "Selenium testing with built-in video recorder"
---

[Selenoid](https://github.com/aerokube/selenoid) is handy tool to manage test runner with minimum efforts.  
As it uses own dependent containers by itself, need to maintain single Selenoid run per build agent.

**docker-compose.yml**  
```yaml
services:  
  e2e-test-runner:
    networks:
      selenoid: null
    depends_on:
      - selenoid
    build:
      context: .
      dockerfile: end-to-end/Dockerfile
    environment:
      - BUILDKITE
      - NEXUS_USERNAME
      - NEXUS_PASSWORD
      - PAYLATER_VERSION
      - CHROME_PROFILE_DIR=/tmp/chrome_profile
      - SEL_JUP_SELENIUM_SERVER_URL=http://selenoid:4444/wd/hub/
      - GRADLE_USER_HOME=/app/.gradle
    volumes:
      - $PWD/end-to-end/build/reports:/app/end-to-end/build/reports
      - $PWD/build/reports:/app/build/reports
      - /var/run/docker.sock:/var/run/docker.sock


  selenoid:
    image: aerokube/selenoid:latest-release
    networks:
      selenoid: null
    volumes:
      - "/tmp/selenoid/video:/opt/selenoid/video:delegated"
      - "/tmp/selenoid/logs:/opt/selenoid/logs:delegated"
      - "$PWD/end-to-end/selenoid:/etc/selenoid:delegated"
      - "/var/run/docker.sock:/var/run/docker.sock"
    expose:
      - "4444"
    environment:
      - OVERRIDE_VIDEO_OUTPUT_DIR=/tmp/selenoid/video
    command: ["-conf", "/etc/selenoid/browsers.json", "-video-output-dir", "/opt/selenoid/video", "-log-output-dir", "/opt/selenoid/logs","-save-all-logs","-disable-privileged", "-container-network", "selenoid"]
```

**CI Pipeline (BK)**  
```yaml
agents:  
aws:
instance-id: "$BUILDKITE_AGENT_META_DATA_AWS_INSTANCE_ID"
```

**first-step.sh**  
```sh
#!/bin/bash
echo --- :docker: Prep Selenoid docker network create selenoid || true
docker pull selenoid/video-recorder:latest-release 
docker pull selenoid/vnc_chrome:79.0 
mkdir -p /tmp/selenoid/video
mkdir -p /tmp/selenoid/logs
```

**last-step.sh**  
```sh
#!/bin/bash
echo +++ :arrow_up: Upload Selenoid Artifacts 
buildkite-agent artifact upload "/tmp/selenoid/**/**"
echo +++ :dusty_stick: Cleaning Up 
rm -rf /tmp/selenoid/logs
rm -rf /tmp/selenoid/video
docker-compose -f docker-compose.yml down
```