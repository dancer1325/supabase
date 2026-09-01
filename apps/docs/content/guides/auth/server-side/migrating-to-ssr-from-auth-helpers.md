---
title: 'Migrating to the SSR package from Auth Helpers'
description: 'Step-by-step guide to migrating your app to the new SSR package'
sidebar_label: 'Migrating to SSR from Auth Helpers'
---

* goal
  * migrate from `auth-helpers` packages -- to -- `@supabase/ssr` package
    * steps
      * [replace Supabase packages](#replacing-supabase-packages)
      * [create a client](#creating-a-client)

* [`auth-helpers` packages](https://github.com/supabase/auth-helpers)
  * ⚠️NOW, deprecated⚠️

* [`@supabase/ssr` package](https://github.com/supabase/ssr)
  * allows
    * Auth Helpers are AVAILABLE | any server language OR framework

## Replacing Supabase packages

* steps
  * `npm uninstall @supabase/auth-helpers-<SSR_FRAMEWORK>`
    * _Examples:_
      * `npm uninstall @supabase/auth-helpers-nextjs`
      * `npm uninstall @supabase/auth-helpers-sveltekit`
      * `npm uninstall @supabase/auth-helpers-remix`
  * `npm install @supabase/ssr`

## Creating a client

* | `@supabase/ssr`,
  * ways to create a Supabase client
    * [`createBrowserClient()` | client](creating-a-client.md)
    * `createServerClient` | server

## Next steps

* [MORE](advanced-guide)
* [MORE](../../../troubleshooting/how-to-migrate-from-supabase-auth-helpers-to-ssr-package-5NRunM) 
