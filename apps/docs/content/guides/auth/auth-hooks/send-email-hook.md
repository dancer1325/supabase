---
id: 'send-email-hook'
title: 'Send Email Hook'
subtitle: 'Use your own email service to send authentication emails.'
---

* Send Email Hook
  * == replacement of Supabase's built-in email sending
  * allows
    * Send emails -- via -- your OWN email provider
    * Add internationalization OR custom logic
    * set up MULTIPLE email providers
      * if primary one fails -> fall back to ANOTHER provider 
  * 's [input schema](https://github.com/supabase/auth/blob/master/internal/hooks/v0hooks/v0hooks.go#L244)
    
    | Field   | Type                                | Description                                    |
    | ------- |-------------------------------------| ---------------------------------------------- |
    | `user`  | [`User`](../users.md#user-object)   | The user account taking the action             |
    | `email` | `object`                            | Metadata specific to the email sending process |

  * 's outputs
    * ❌NO required❌

## Email sending behavior

* Email sending behavior
  * -- depends on -- 
    * Email Provider
    * Auth Hook status

| Email Provider | Auth Hook | Email sending behavior                                                |
| -------------- | --------- |-----------------------------------------------------------------------|
| Enabled        | Enabled   | Auth Hook handles email sending (SMTP not used)                       |
| Enabled        | Disabled  | SMTP handles email sending (custom if configured, default otherwise)  |
| Disabled       | Enabled   | Email signups disabled                                                |
| Disabled       | Disabled  | Email signups disabled                                                |

## Email change behavior & token hash mapping

* if `email_data.email_action_type: email_change` -> hook payload 
  * can include 
    * 1 OR 2 OTPs (EVEN their hashes) -- depending on -- Secure Email Change

* Secure Email Change
  * Supabasa Dashboard > Authentication > Providers
  * if Secure Email Change is 
    * enabled -> 
      * generate 2 OTPs
        * 1 OTP / CURRENT email (== `user.email`)
          * `user.email` -- associated with -- `email_data.token` & `email_data.token_hash_new`
        * 1 OTP / NEW email (== `user.new_email`)
          * `user.new_email` -- associated with -- `email_data.token_new` & `email_data.token_hash`
      * you MUST send 2 emails
    * disabled ->
      * generate 1 OTP / NEW email (== `user.new_email`)
        * `user.new_email` -- associated with -- `email_data.token` & `email_data.token_hash`
          * ❌!= enabled association❌
      * you MUST send 1! email

### What to send

* ways
  * -- via -- SQL
  * -- via -- HTTP

#### SQL

* Queue Email Messages
  * == send emails in batches -- via -- a job queue
    * == queue the messages + send them | intervals  
    * ❌!= send messages IMMEDIATELY❌
  * Reason:🧠better performance🧠
  * steps
    * create a table | store jobs
    * create the hook
    * create a function / periodically run & dequeue ALL jobs
    * [enable `pg_cron`](../../cron.md)
    * configure `pg_cron` / run the job | an interval

#### HTTP

##### Use Resend -- as -- an email provider

* [Resend](https://resend.com/)
  * benefits
    * Resend's developer-friendly APIs
    * email templates -- through -- [React Email](https://react.email/) 
      * [tutorial](../../functions/examples/auth-send-email-hook-react-email-resend)
  * 👀ways to use Resend | Supabase👀
    * -- via -- Supabase Resend integration
      * [here1](https://resend.com/docs/knowledge-base/getting-started-with-resend-and-supabase)
      * [here2](https://resend.com/docs/send-with-supabase-edge-functions)
      * [here3](https://resend.com/docs/knowledge-base/how-do-i-maximize-deliverability-for-supabase-auth-emails)
    * -- via -- Send Email Hook + Resend API

* Send Email Hook + Resend API
  * steps
    * generate `SEND_EMAIL_HOOK_SECRET`
      * Supabase Dashboard > choose project > Authentication > Auth Hooks > Send Email Hook
    * | ".env"

      ```ini
      RESEND_API_KEY="your_resend_api_key"
      SEND_EMAIL_HOOK_SECRET="v1,whsec_<base64_secret>"
      ```
    * `supabase secrets set --env-file .env`
      * set the secrets | your Supabase project
    * `supabase functions new send-email`
      * create a NEW edge function
    * `supabase functions deploy send-email --no-verify-jwt`
      * deploy your edge function

##### Add Internationalization for Email Templates

* steps
  * | ".env", configure

      ```ini
      POSTMARK_SERVER_TOKEN=<POSTMARK_SERVER_TOKEN>
      SEND_EMAIL_HOOK_SECRET="v1,whsec_<base64_secret>"
      ```

##### Add Backup Email Provider

* _Example:_ -- through -- Postmark & Sengrid

* steps
  * | ".env", configure

      ```ini
      POSTMARK_SERVER_TOKEN=<POSTMARK_SERVER_TOKEN>
      SENDGRID_API_KEY=<SENDGRID_API_KEY>
      SEND_EMAIL_HOOK_SECRET="v1,whsec_<base64_secret>"
      ```
