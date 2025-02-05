---
title: CloudFront Functions with Dynamic Origin Pointing to Another CloudFront
date: 2025-02-05
description: Using CloudFront Functions to dynamically change the origin to another CloudFront distribution via updateRequestOrigin.

---
At re:Invent 2024, CloudFront Functions introduced new features, including the ability to dynamically change the origin host.

Previously, this wasn't possible as the Host header was read-only for CloudFront viewer requests.

To address this, they introduced the `updateRequestOrigin` function.

Then I encountered an issue where it worked fine for ALB or non-AWS endpoints, but when pointing to another CloudFront distribution, it caused a 400 Bad Request error.

It turns out that in this use case, the Host header for the origin request needs to be removed. Therefore, using `AllViewerExceptHostHeader` is required.