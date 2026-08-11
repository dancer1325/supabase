---
title: 'Rate limits'
subtitle: 'Rate limits protect your services from abuse'
---

* Supabase Auth
  * 💡| authentication endpoints, enforces rate limits💡 
    * Reason:🧠prevent abuse🧠
    * ways to configure
      * Supabase Dashboard > Choose your project > Authentication > Rate Limits
      * -- via -- Management API

## Rate limit behavior

TODO: 
Supabase Auth uses a token bucket algorithm for endpoint operations that are limited by IP address.

Each bucket has a maximum capacity of 30 requests
* When the bucket is full, brief bursts of up to 30 requests can be allowed in a short period
* Once the bucket empties, requests are rate limited until tokens refill
* The rate limit defines the rate at which the bucket is refilled.

This means a client that has been idle will tolerate a brief spike in traffic, but sustained request above the rate limit are denied
* When rate limits are exceeded, a **429 Too Many Requests** error is returned.

The table below shows the rate limit quotas and additional details for authentication endpoints.

<$Partial path="auth_rate_limits.mdx" />

## IP address forwarding

* == enforces rate limits / client's IP address
* steps
  * set the `Sb-Forwarded-For` header -- to the -- end-user IP address
  * make a request -- with a -- [secret API key](../getting-started/api-keys)
    * != 
      * ❌publishable API keys
      * legacy `anon`/`service_role` API keys❌

* ways to configure
  * Supabase Dashboard > Choose your project > Authentication > Rate Limits > IP Address Forwarding
  * -- via -- Management API
  
* how to use -- by -- SDK?
  * set the `Sb-Forwarded-For` header
