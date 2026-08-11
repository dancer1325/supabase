---
id: introduction
title: introduction
hideTitle: true
---

# Management API

* allows
  * manage PROGRAMMATICALLY your 
    * Supabase organizations
    * Supabase projects

## Authentication

* Authorization header -- `Authorization Bearer <access_token>` --
  * required | ALL API requests
  * ways to generate an access token
    1. **Personal access token (PAT):**
       * PATs
         * == long-lived tokens /
           * you MANUALLY generate -- to -- access the Management API
           * use cases
             * automating workflows
             * developing against the Management API
           * 's privileges == your user account
       * steps to generate
         * Supabase Dashboard > Your profile > Account > Access Tokens
    2. **OAuth2:**
       * TODO: 
    OAuth2 allows your application to generate tokens on behalf of a Supabase user, providing secure and limited access to their account without requiring their credentials. Use this if you're building a third-party app that needs to create or manage Supabase projects on behalf of your users. Tokens generated via OAuth2 are short-lived and tied to specific scopes to ensure your app can only perform actions that are explicitly approved by the user.

        See [Build a Supabase Integration](/docs/guides/integrations/build-a-supabase-integration) to set up OAuth2 for your application.

```bash
  curl https://api.supabase.com/v1/projects \
  -H "Authorization: Bearer sbp_bdd0••••••••••••••••••••••••••••••••4f23"
```

All API requests must be authenticated and made over HTTPS.

## Rate limits 

* [here](../../../content/_partials/api_rate_limits.md)



The Management API is subject to our fair-use policy
* All resources created via the API are subject to the pricing detailed on our [Pricing](https://supabase.com/pricing) pages.

      </RefSubLayout.Details>

      <RefSubLayout.Examples>

        Additional links

        - [OpenAPI Docs](https://api.supabase.com/api/v1)
        - [OpenAPI Spec](https://api.supabase.com/api/v1-json)
        - [Report bugs and issues](https://github.com/supabase/supabase)

        </RefSubLayout.Examples>

  </RefSubLayout.EducationRow>
