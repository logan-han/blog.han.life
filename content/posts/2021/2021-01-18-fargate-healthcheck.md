---
title: "fargate container healthcheck"
date: "2021-01-18"
description: "configuring healthcheck in a fargate task definition"
---

Long story in short, unlike what https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_HealthCheck.html suggests, fargate doesn't have curl.

For some reason it does have wget, so `"command": [ "CMD-SHELL", "wget -q -O - ${healthcheck_endpoint} || exit 1" ]` works as expected.

Also when used in terraform, vars in template_file data need to be encoded using `jsonencode` when used for secrets & environment

whereas json encoded value will cause `Error decoding JSON: invalid character` error when used in healthcheck.
