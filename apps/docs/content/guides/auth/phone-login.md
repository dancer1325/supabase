---
title: 'Phone Login'
description: 'Learn about logging in to your platform using SMS one-time passwords.'
---

* Phone Login 
  * == method of authentication /
    * enable
      * users can log in -- , WITHOUT using a password, -- | website OR application
        * WITHOUT using a password
          * == -- through -- a one-time password (OTP) / sent -- via -- a channel (SMS or WhatsApp)
            * WhatsApp
              * ⚠️limitations⚠️
                * ONLY | Twilio & Twilio Verify Providers

TODO: 
Users can also log in with their phones using Native Mobile Login with the built-in identity provider
* For Native Mobile Login with Android and iOS, see the [Social Login guides](/docs/guides/auth/social-login).

Phone OTP login can:

- Improve the user experience by not requiring users to create and remember a password
- Increase security by reducing the risk of password-related security breaches
- Reduce support burden of dealing with password resets and other password-related flows

* [cost](../../_partials/cost_warning.md)

## how to enable phone login?

* steps
  * -- based on -- Supabase stack 
    * | hosted projects,
      * Supabase dashboard > choose a project > auth > providers
    * | self-hosted projects OR local development,
      * set [`auth.sms`](../../../spec/cli_v1_config.md#aut.sms)
  * set up an SMS provider
    * [SUPPORTED](../../../components/AuthSmsProviderConfig)
      * MessageBird
      * Twilio
      * Vonage
      * TextLocal (community-supported)

TODO: 
By default, a user can only request an OTP once every <SharedData data="config">auth.rate_limits.otp.period</SharedData> and they expire after <SharedData data="config">auth.rate_limits.otp.validity</SharedData>.

## Signing in with phone OTP

* `supabase.auth.signInWithOtp(credentials)`
  * how does it work?
    * user receives an SMS / has 6-digit pin
    * user must verify it | 60"

## Verifying a phone OTP

* [`supabase.auth.verifyOtp()`](https://github.com/dancer1325/supabase-js/blob/master/packages/core/auth-js/src/GoTrueClient.md)
  * 's response
    * valid session

TODO: 
The access token can be sent in the Authorization header as a Bearer token for any CRUD operations on supabase-js
* See our guide on [Row Level Security](/docs/guides/auth#row-level-security) for more info on restricting access on a user basis.

## Updating a phone number

* ⚠️requirements⚠️
  * user MUST be logged in

* [`supabase.auth.updateUser()`](https://github.com/dancer1325/supabase-js/blob/master/packages/core/auth-js/src/GoTrueClient.md)
  * how does it work?
    * user receives an SMS -- with -- a 6-digit pin /
      * you must [verify](#verifying-a-phone-otp) | NEXT 60"
