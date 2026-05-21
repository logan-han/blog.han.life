---
title: Why Sentry events silently vanished from our Node app
date: 2026-05-20
description: A debugging journey through DNS, Happy Eyeballs, and the unhelpful default behaviour of Node's HTTPS agent.
---

# Why Sentry events silently vanished from our Fargate Node app

## TL;DR

Sentry's Node SDK uses Node's native `https.Agent`, which in Node 18+ does Happy Eyeballs dual-stack connections by default. When DNS returns AAAA records but the host (e.g. an ECS Fargate ENI) has no IPv6 routing, the IPv6 connect attempts don't fail fast — they hang until the agent's default 2-second timeout, producing `AggregateError [ETIMEDOUT]` and silently dropping the event. `curl` from the same host works fine because curl falls back to IPv4 in milliseconds. The fix is one line: tell the Sentry transport to force IPv4 via a custom `httpModule`.

---

## The symptom

A long-running Node API on ECS Fargate. Sentry SDK initialised, DSN set, `Sentry.captureException` being called in the error handler. Logs confirmed the handler ran. Events never arrived in the dashboard.

CloudWatch showed the exception was caught and the SDK was loaded. The Sentry "Errors" page just stayed empty.

## What I ruled out first

The obvious things were ruled out one by one:

| Check | Result |
| --- | --- |
| DSN format / project ID matches dashboard | Correct |
| `Sentry.init` called before any error | Yes |
| `Sentry.captureException` actually called | Yes (logged just before) |
| Container image, env vars match between local and prod | Same image, same DSN, same `DEPLOY_ENV` |
| Local Docker run with the exact same image and DSN | Events arrived fine in the dashboard |

That last one was the kicker. Same image, same config, same SDK version. Worked locally, didn't work in Fargate.

So it had to be the environment.

## What I ruled out next

I started chasing the network:

- Security groups: egress 443 to `0.0.0.0/0` allowed
- NACLs: wide-open `0.0.0.0/0` both directions
- Route table: `0.0.0.0/0 -> NAT Gateway -> IGW`
- NAT gateway: healthy, public IP good
- DNS resolution: returns IPv4 addresses fine
- `curl` to the Sentry ingest endpoint from a bastion in the same VPC: HTTP 200 in 800ms

The smoking-gun test: I launched a one-shot Fargate task in the *exact same subnet and security group* as the API, running `curlimages/curl`. It POSTed a synthetic envelope to the Sentry endpoint. **HTTP 200, the event arrived in the dashboard.**

So the network was fine. The subnet could reach Sentry. Sentry would accept events from the NAT gateway's IP. It just wasn't working from the Node process.

## Turning on the SDK's debug mode

I had been guessing. Time to stop guessing.

I rebuilt the image with one extra line in `instrument.ts`:

```ts
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.DEPLOY_ENV,
  release: process.env.APP_VERSION,
  debug: process.env.SENTRY_DEBUG === 'true',
});
```

Pushed a debug image to a side ECR repo, swapped the task definition, set `SENTRY_DEBUG=true`, deployed. Fired the curl that triggers the captured error.

CloudWatch:

```
Sentry Logger [log]: Captured error event `<message>`
Sentry Logger [log]: Recording outcome: "network_error:error"
Sentry Logger [error]: Encountered error running transport request: AggregateError [ETIMEDOUT]:
Sentry Logger [error]: Error while sending envelope: AggregateError [ETIMEDOUT]:
```

The SDK was capturing the event. The transport was failing. Silently, because `errorHandler` in the transport just logs at debug level.

## Why `AggregateError`?

`AggregateError` is the signature of Node trying multiple destinations and failing on all of them. In Node 18+, `https.Agent` uses *autoSelectFamily* (Happy Eyeballs, RFC 8305) by default. When DNS returns both A and AAAA records, the agent races them — fires connect attempts to IPv6 and IPv4 in parallel, takes the first successful one.

The destination's DNS returned both. The ENI of an awsvpc Fargate task only has IPv4 connectivity by default. Here's the divergence:

- `curl`'s implementation: tries IPv6, gets `Cannot assign requested address` immediately (the OS knows there's no IPv6 interface to bind from), moves to IPv4 in milliseconds.
- Node's `https.Agent` with autoSelectFamily: queues both attempts, waits for either to succeed *or* for the family-selection timeout. The IPv6 attempt doesn't get an "immediate fail" — it waits for routing to time out, which on Fargate behaves more like a network timeout than an immediate refusal.

The IPv4 attempt may complete fine, but the agent's overall timeout elapses first. Both attempts get aborted. The error surfaced as `AggregateError [ETIMEDOUT]`.

This explains everything:

- Why `curl` from the same subnet worked (different connect logic)
- Why local Docker worked (my laptop has IPv6 and routes it, so the IPv6 attempt actually succeeds — or fails fast enough)
- Why events occasionally trickle through (when timing happens to favour IPv4 completion before the 2s timeout)

## Things I tried that didn't work

Before figuring out the real cause, I tried a few env-var fixes:

```bash
NODE_OPTIONS="--dns-result-order=ipv4first"
NODE_OPTIONS="--dns-result-order=ipv4first --no-network-family-autoselection"
UV_THREADPOOL_SIZE=16
```

None helped. Why:

- `--dns-result-order=ipv4first` only changes the *order* of DNS results returned by `dns.lookup`. The connect logic still races families.
- `--no-network-family-autoselection` disables Happy Eyeballs at the `net.Socket` level, but the Sentry SDK creates its own `https.Agent` instance that doesn't pick up this flag the way you'd expect — it goes through code paths that still attempt dual-stack via Node's address resolver before reaching the socket flag.
- `UV_THREADPOOL_SIZE` was a theory about libuv DNS lookups being blocked by other concurrent calls. The debug logs proved that wasn't the issue.

## The fix

The Sentry Node transport accepts an `httpModule` override — anything that exposes `.request(options, callback): ClientRequest`. Wrapping native `https` and injecting `family: 4` does the job:

```ts
import * as https from 'node:https';
import * as Sentry from '@sentry/node';

const ipv4HttpsModule = {
  request: (options: any, callback?: any) =>
    https.request({ ...options, family: 4 }, callback),
};

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.DEPLOY_ENV,
  release: process.env.APP_VERSION,
  transportOptions: {
    httpModule: ipv4HttpsModule as any,
  },
});
```

`family: 4` forces IPv4-only DNS resolution and connect at the request level. Skip AAAA, skip Happy Eyeballs, go straight to A record.

Redeploy, fire the test request, watch the event land in the dashboard. Done.

## Why this and not VPC-level dual-stack?

The cleanest architectural fix would be to enable IPv6 at the VPC level: add an IPv6 CIDR, IPv6 subnet ranges, egress-only IGW for private subnets, IPv6 entries in security groups and NACLs. Then dual-stack would actually work end-to-end.

But:

- Blast radius is the whole VPC and every workload in it
- Most outbound traffic in a typical AWS setup is to IPv4-only destinations (RDS, internal services, S3 endpoints, etc.) — IPv6 helps only the rare third-party that has AAAA records
- Each library that uses dual-stack would need re-verifying
- Requires platform/network team involvement

For a single one-line workaround in the SDK that already had a clean extension point, the trade-off was obvious. If VPC IPv6 gets enabled later, this line becomes harmless and can be removed.

## Why not /etc/gai.conf or a DNS sidecar?

Other container-level approaches I considered:

| Approach | Why I didn't pick it |
| --- | --- |
| Custom `/etc/gai.conf` precedence | Only changes resolution *order*, not which families are tried |
| `--require` preload that monkey-patches `dns.lookup` | More files in the image, more surface to maintain |
| `dnsmasq` sidecar filtering AAAA records | Heavy ops burden for one third-party endpoint |
| Run own DNS resolver via task def `dnsServers` | Same heavy burden, plus breaks internal AWS DNS resolution |

The SDK-level fix is targeted, reversible, self-documenting in the file that already configures Sentry.

## Lessons

1. **The SDK debug flag is the most underused field in Sentry's options.** I should have flipped it on much earlier. The investigation jumped forward instantly once it was on.

2. **`curl` is not Node.** I'd been treating successful `curl` from the subnet as proof that the same connection from Node would work. They use different connect implementations. Happy Eyeballs handling differs.

3. **`AggregateError` from Node is shorthand for "tried multiple destinations".** Whenever I see it from an outbound request library, it's worth asking whether dual-stack resolution is happening when only one stack is reachable.

4. **`netstack` / `routing` differences between Fargate and local Docker matter.** Local Docker for Mac generally has IPv6 routing through the host. Fargate awsvpc ENIs default to IPv4-only. The same image will behave differently across these.

5. **When a third-party returns AAAA records, IPv4-only environments need explicit family pinning.** This isn't just a Sentry problem — it'll show up for any HTTP-talking library that uses Node's default agent in an IPv4-only network.

## The whole fix

Final diff:

```diff
+import * as https from 'node:https';
 import * as Sentry from '@sentry/node';

+const ipv4HttpsModule = {
+  request: (options: any, callback?: any) =>
+    https.request({ ...options, family: 4 }, callback),
+};
+
 Sentry.init({
   dsn: process.env.SENTRY_DSN,
   environment: process.env.DEPLOY_ENV,
   release: process.env.APP_VERSION,
+  transportOptions: {
+    httpModule: ipv4HttpsModule as any,
+  },
 });
```

A nine-line change. Hours of investigation behind it.
