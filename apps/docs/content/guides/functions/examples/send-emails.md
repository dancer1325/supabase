---
title: 'Sending Emails'
description: 'Sending emails from Edge Functions using the Resend API.'
tocVideo: 'Qf7XvL1fjvo'
---

* goal
  * | Edge Functions, send emails -- via .. [Resend API](https://resend.com/)

* Prerequisites
  * | Resend,
    - [Create an API key](https://resend.com/api-keys)
    - [Verify your domain](https://resend.com/domains)
  * install [Supabase CLI](../../cli.md)

* steps
  * `supabase functions new <FUNCTION_NAME>`
  * edit "supabase/functions/<FUNCTION_NAME>/index.tsx"
  * `supabase start`
  * configure ".env"
  * `supabase functions serve --no-verify-jwt --env-file .env`
  * [configure the secret](../secrets.md#production-secrets)
  * `supabase functions deploy <FUNCTION_NAME> --no-verify-jwt`

* _Example official:_ [here](https://github.com/resendlabs/resend-supabase-edge-functions-example)
