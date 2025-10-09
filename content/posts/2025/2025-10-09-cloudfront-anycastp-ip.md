---
title: CloudFront Anycast IP
date: 2025-10-09
description: What is CloudFront Anycast IP really?
---

# CloudFront Anycast IP: A Closer Look

I recently worked with a new AWS product called **CloudFront Anycast IP**, which costs **$3,000/month**. After testing it, I found the offering to be quite misleading, so I’m sharing my findings here.

## TL;DR

This service simply restricts your CloudFront distribution to a small set of static IP addresses, marketed as “anycast” Despite AWS’s claims, it’s not true anycast in the traditional sense.

---

## What AWS Claims

AWS describes this product with phrases like:

- “High performance packet processing network”
- “Zero-rating support”
- “Global anycast IP”

These features sound impressive, but in reality, they’re mostly **marketing spin** designed to justify the high price tag.

---

## How It Actually Works

- You receive a list of either **21 or 3 static IP addresses**.
- You can associate the list to your CloudFront distribution.
- Then your usual CNAME alias (e.g., `abc.cloudfront.net`) is updated to use these IPs.
- These IP addresses are exclusive to the associated distributions, unlike normal CloudFront IP that can respond to any valid distribution host header.
- If a request hits an IP not associated with the distribution, it returns the error:  
  > _“The request landed on IP not associated with its distribution.”_
---

## Why 21 or 3 IPs?

I asked AWS about the odd choice. Their response:

- **21 IPs**: Recommended for non-APEX domain use cases.
- **3 IPs**: Intended for APEX domains.

Upon testing, I found that the **21 IPs are geographically distributed**. Instead of true anycast routing, AWS assigns a **dedicated IP per region** and calls it “anycast” The number 21 likely corresponds to the number of regions they’re covering.

---

## The Truth About Zero-Rating

AWS doesn’t offer any actual zero-rating service. Instead:

- The fixed IPs allow **customers to negotiate directly with ISPs**.
- This wasn’t possible with CloudFront’s default floating IP structure.
- So, “zero-rating support” is just **a capability**, not a feature.

---

## Final Thoughts

AWS has taken an unusual approach with this product—one that other CDN providers often offer **for free or at a much lower cost**. While it may serve niche use cases, the value proposition is questionable given the price and misleading marketing.
