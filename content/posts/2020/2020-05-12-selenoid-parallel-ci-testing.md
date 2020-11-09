---
title: "Selenoid Parallel CI testing"
date: "2020-05-12"
---

[Selenoid](https://github.com/aerokube/selenoid) is handy tool to manage test runner with minimum efforts.  
As it uses own dependent containers by itself, need to maintain single Selenoid run per build agent.

**docker-compose.yml**  
\[yaml\] services: e2e-test-runner: networks: selenoid: null depends\_on: - selenoid build: context: . dockerfile: unittest/Dockerfile volumes: - $PWD/unittest/build/reports:/app/unittest/build/reports - /var/run/docker.sock:/var/run/docker.sock

selenoid: image: aerokube/selenoid:latest-release networks: selenoid: null volumes: - "/tmp/selenoid/video:/opt/selenoid/video:delegated" - "/tmp/selenoid/logs:/opt/selenoid/logs:delegated" - "$PWD/end-to-end/selenoid:/etc/selenoid:delegated" - "/var/run/docker.sock:/var/run/docker.sock" expose: - "4444" environment: - OVERRIDE\_VIDEO\_OUTPUT\_DIR=/tmp/selenoid/video command: \["-conf", "browsers.json", "-video-output-dir", "/opt/selenoid/video", "-log-output-dir", "/opt/selenoid/logs","-save-all-logs","-disable-privileged", "-container-network", "selenoid"\] \[/yaml\]

**CI Pipeline (BK)**  
\[yaml\] agents: aws: instance-id: "$BUILDKITE\_AGENT\_META\_DATA\_AWS\_INSTANCE\_ID" \[/yaml\]

**first-step.sh**  
\[bash\] #!/bin/bash echo --- :docker: Prep Selenoid docker network create selenoid || true docker pull selenoid/video-recorder:latest-release docker pull selenoid/vnc\_chrome:79.0 mkdir -p /tmp/selenoid/video mkdir -p /tmp/selenoid/logs\[/bash\]

**last-step.sh**  
\[bash\] #!/bin/bash echo +++ :arrow\_up: Upload Selenoid Artifacts buildkite-agent artifact upload "/tmp/selenoid/\*\*/\*\*" echo +++ :dusty\_stick: Cleaning Up rm -rf /tmp/selenoid/logs rm -rf /tmp/selenoid/video docker-compose -f docker-compose.yml down\[/bash\]
