---
id: 'storage-s3-authentication'
title: 'S3 Authentication'
description: 'Authentication'
subtitle: 'Learn about authenticating with Supabase Storage S3.'
sidebar_label: 'S3'
---

* Supabase Storage S3
  * ways to authenticate
    - [S3 access keys](#s3-access-keys) 
    - [Session Token](#session-token)

## S3 access keys

* steps
  * Supabase Dashboard > Storage > Settings > S3 > New access key
  * copy
    * S3' endpoint
      * | [local development](../../local-development.md),
        * http://127.0.0.1:54321/storage/v1/s3
    * S3' region
      * | [local development](../../local-development.md),
        * "local"
    * S3' access key

* allows
  * FULL access | ALL S3 operations | ALL buckets 
    * bypass RLS policies

* recommendations
  * use ONLY | the server

![](../../../../public/img/storage/s3-credentials.png)

* direct storage hostname
  * _Example:_
    * replace https://project-id.supabase.co -- by -- https://project-id.storage.supabase.co
  * allows
    * | upload large files, OPTIMAL performance
      * ways
        * AWS SDK

          ```js
          import { S3Client } from '@aws-sdk/client-s3';

          const client = new S3Client({
            forcePathStyle: true,
            region: 'project_region',
            endpoint: 'https://project_ref.storage.supabase.co/storage/v1/s3',
            credentials: {
              accessKeyId: 'your_access_key_id',
              secretAccessKey: 'your_secret_access_key',
            }
          })
          ```

        * AWS Credentials

          ```
          # ~/.aws/credentials

          [supabase]
          aws_access_key_id = your_access_key_id
          aws_secret_access_key = your_secret_access_key
          endpoint_url = https://project_ref.storage.supabase.co/storage/v1/s3
          region = project_region
          ```

## Session token

* == JWT token
* provide
  * limited -- , via RLS, -- access | ALL S3 operations
* use case
  * | initialize the S3 client | server / scoped -- to -- a specific user
  * use the S3 client | client side

TODO: 
To authenticate with S3 using a Session Token, use the following credentials:

- access_key_id: `project_ref`
- secret_access_key: `anonKey` (`publishableKey` is [not yet supported](https://github.com/supabase/storage/issues/750))
- session_token: `valid jwt token`

For example, using the `aws-sdk` library:

<Admonition type="note">

Typically we advise against using `getSession`, because the session is read from local storage and 
you can't trust its claims for auth decisions
* In this case however, the code only needs the raw access token string to forward as a credential to the S3 service, 
which validates the token server-side
* Since no client-side auth decision is made based on the session data, `getSession` is appropriate here.

</Admonition>

```javascript
import { S3Client } from '@aws-sdk/client-s3'

const {
  data: { session },
} = await supabase.auth.getSession()

const client = new S3Client({
  forcePathStyle: true,
  region: 'project_region',
  endpoint: 'https://project_ref.storage.supabase.co/storage/v1/s3',
  credentials: {
    accessKeyId: 'project_ref',
    secretAccessKey: 'anonKey',
    sessionToken: session.access_token,
  },
})
```

<Admonition type="note">

- On self-hosted Supabase, the `accessKeyId` is the `STORAGE_TENANT_ID` environment variable defined in the `.env` file
* Refer to the [self-hosted S3 guide](/docs/guides/self-hosting/self-hosted-s3#session-token) for more details.
- On [local development](/docs/guides/local-development), use the following values:
  - `region`: `local`
  - `endpoint`: IP and port e.g. `http://127.0.0.1:54321/storage/v1/s3`
  - `accessKeyId`: `stub`
  - `secretAccessKey`: use `ANON_KEY` value from `supabase status -o env`

</Admonition>
