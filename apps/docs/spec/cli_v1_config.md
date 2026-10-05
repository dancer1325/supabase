* "supabase/config.toml"
  * == 💡your locally running project's settings💡 /
    * generated AFTER running `supabase init`
  * how to make effective the modifications?
    * `supabase stop`
    * `supabase start`

# parameters
## `storage.buckets.bucket_name.public`
* enable
  * public access -- to -- the bucket

## `storage.buckets.bucket_name.file_size_limit`
* == MAXIMUM file size ALLOWED

## `storage.buckets.bucket_name.allowed_mime_types`
* == bucket's objects' ALLOWED MIME types 

## `storage.buckets.bucket_name.objects_path`
* == local directory | upload objects | bucket

## `project_id`
* == unique identifier -- for -- this project
  * | same host, distinguishes different Supabase projects
  * default: working directory name | running `supabase init`

## `api.enabled`
* enable the local PostgREST service

## `api.port`
* port -- for -- the API URL

## `api.schemas`
* schemas -- to -- expose | your API
  * tables, views, functions -> get API endpoints
  * `public` & `storage` always included

## `api.extra_search_path`
* extra schemas -- to -- add | search_path of every request
  * `public` always included

## `api.max_rows`
* MAXIMUM number of rows -- returned from -- view / table / function
  * limits payload size for accidental or malicious requests

## `db.port`
* port -- for -- the local database URL

## `db.shadow_port`
* port -- for -- the local shadow database

## `db.major_version`
* database major version
  * ⚠️ must == your remote database's⚠️
  * check: `SHOW server_version;` | remote database

## `db.pooler.enabled`
* enable the local PgBouncer service

## `db.pooler.port`
* port -- for -- the local connection pooler

## `db.pooler.pool_mode`
* specifies when a server connection can be reused by other clients
  * supported modes: `transaction`, `session`

## `db.pooler.default_pool_size`
* number of server connections allowed per user/database pair

## `db.pooler.max_client_conn`
* MAXIMUM number of client connections allowed

## `db.settings.effective_cache_size`
* planner's assumption about the effective size of the disk cache
  * query planner parameter — ❌ does NOT affect actual memory allocation❌

## `db.settings.logical_decoding_work_mem`
* memory -- for -- logical decoding, before writing data to local disk

## `db.settings.maintenance_work_mem`
* MAXIMUM memory -- for -- maintenance operations (VACUUM, CREATE INDEX, ALTER TABLE ADD FOREIGN KEY)

## `db.settings.max_connections`
* MAXIMUM number of concurrent connections
  * ⚠️ requires database restart⚠️

## `db.settings.max_locks_per_transaction`
* average number of object locks -- allocated for -- each transaction
  * ⚠️ requires database restart⚠️

## `db.settings.max_parallel_maintenance_workers`
* MAXIMUM parallel workers -- started by -- a single utility command

## `db.settings.max_parallel_workers`
* MAXIMUM parallel workers -- supported by -- the system
  * ⚠️ requires database restart⚠️

## `db.settings.max_parallel_workers_per_gather`
* MAXIMUM parallel workers -- started by -- a single Gather or Gather Merge node

## `db.settings.max_replication_slots`
* MAXIMUM number of replication slots
  * ⚠️ requires database restart⚠️

## `db.settings.max_slot_wal_keep_size`
* MAXIMUM size of WAL files -- retained by -- replication slots | pg_wal directory

## `db.settings.max_standby_archive_delay`
* MAXIMUM delay before canceling queries | hot standby -- processing -- archived WAL data

## `db.settings.max_standby_streaming_delay`
* MAXIMUM delay before canceling queries | hot standby -- processing -- streamed WAL data

## `db.settings.max_wal_size`
* MAXIMUM size of WAL files | pg_wal directory

## `db.settings.max_wal_senders`
* MAXIMUM concurrent connections from standby servers or streaming base backup clients
  * ⚠️ requires database restart⚠️

## `db.settings.max_worker_processes`
* MAXIMUM number of background processes
  * ⚠️ requires database restart⚠️

## `db.settings.session_replication_role`
* controls whether triggers and rewrite rules are enabled
  * valid values: `"origin"`, `"replica"`, `"local"`

## `db.settings.shared_buffers`
* memory -- for -- shared memory buffers
  * ⚠️ requires database restart⚠️

## `db.settings.statement_timeout`
* abort any statement -- taking more than -- the specified time

## `db.settings.track_activity_query_size`
* MAXIMUM size of the query string tracked | pg_stat_activity.current_query
  * ⚠️ requires database restart⚠️

## `db.settings.track_commit_timestamp`
* record commit time of transactions
  * ⚠️ requires database restart⚠️

## `db.settings.wal_keep_size`
* MINIMUM size of past log file segments | pg_wal directory

## `db.settings.wal_sender_timeout`
* terminate replication connections inactive longer than this time

## `db.settings.work_mem`
* memory -- for -- internal sort operations and hash tables, before writing to temp disk files

## `db.seed.enabled`
* enables running seeds | starting or resetting the database

## `db.seed.sql_paths`
* array of files or glob patterns -- to -- find seeds

## `realtime.enabled`
* enable the local Realtime service

## `realtime.ip_version`
* bind realtime -- via -- IPv4 or IPv6

## `studio.enabled`
* enable the local Supabase Studio dashboard

## `studio.port`
* port -- for -- Supabase Studio

## `studio.api_url`
* external URL of the API server -- that -- frontend connects to

## `studio.openai_api_key`
* OpenAI API key -- for -- AI features | Studio dashboard
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `inbucket.enabled`
* enable the local InBucket service

## `inbucket.port`
* port -- for -- the email testing server web interface
  * emails sent | local dev setup are ❌ NOT actually sent❌ — monitored via web interface

## `inbucket.smtp_port`
* port -- for -- the email testing server SMTP port

## `inbucket.pop3_port`
* port -- for -- the email testing server POP3 port

## `inbucket.admin_email`
* email -- used as -- sender | emails sent from the application

## `inbucket.sender_name`
* display name -- used as -- sender | emails sent from the application

## `storage.enabled`
* enable the local Storage service

## `storage.file_size_limit`
* MAXIMUM file size allowed -- for -- ALL buckets | the project

## `auth.enabled`
* enable the local GoTrue service

## `auth.site_url`
* base URL of your website
  * used as allow-list for redirects & for constructing URLs | emails

## `auth.additional_redirect_urls`
* list of _exact_ URLs -- that -- auth providers are permitted to redirect to post authentication

## `auth.jwt_expiry`
* how long tokens are valid, in seconds
  * default: 3600 (1 hour), maximum: 604800 (1 week)

## `auth.enable_manual_linking`
* allow testing manual linking of accounts

## `auth.enable_refresh_token_rotation`
* if disabled -> refresh token will ❌ NEVER expire❌

## `auth.refresh_token_reuse_interval`
* allows refresh tokens -- to be -- reused after expiry, up to the specified interval (seconds)
  * ⚠️ requires `enable_refresh_token_rotation = true`⚠️

## `auth.rate_limit.email_sent`
* number of emails -- sent per -- hour
  * ⚠️ requires `auth.email.smtp` to be enabled⚠️

## `auth.rate_limit.sms_sent`
* number of SMS messages -- sent per -- hour
  * ⚠️ requires `auth.sms` to be enabled⚠️

## `auth.rate_limit.anonymous_users`
* number of anonymous sign-ins per hour per IP address
  * ⚠️ requires `enable_anonymous_sign_ins = true`⚠️

## `auth.rate_limit.token_refresh`
* number of sessions -- refreshed in -- a 5 minute interval per IP address

## `auth.rate_limit.sign_in_sign_ups`
* number of sign up and sign-in requests in a 5 minute interval per IP address
  * excludes anonymous users

## `auth.rate_limit.token_verifications`
* number of OTP / Magic link verifications in a 5 minute interval per IP address

## `auth.enable_signup`
* allow/disallow new user signups

## `auth.enable_anonymous_sign_ins`
* allow/disallow anonymous sign-ins

## `auth.email.enable_signup`
* allow/disallow new user signups -- via -- email

## `auth.email.double_confirm_changes`
* if enabled -> user must confirm email change | BOTH old & new email addresses

## `auth.email.enable_confirmations`
* if enabled -> users must confirm their email address before signing in

## `auth.email.secure_password_change`
* if enabled -> requires current password -- when -- changing to a new password

## `auth.email.max_frequency`
* MINIMUM time -- between -- email requests
  * _Example values:_ `"1m"`, `"1h"`, `"24h"`

## `auth.email.otp_length`
* length of OTP code -- sent in -- emails
  * must be between 6 and 10 digits

## `auth.email.otp_expiry`
* expiry time for an OTP code, in seconds

## `auth.email.smtp.host`
* hostname or IP address of the SMTP server

## `auth.email.smtp.port`
* port number of the SMTP server

## `auth.email.smtp.user`
* username -- for -- authenticating with the SMTP server

## `auth.email.smtp.pass`
* password -- for -- authenticating with the SMTP server

## `auth.email.smtp.admin_email`
* email -- used as -- sender | emails sent from the application

## `auth.email.smtp.sender_name`
* display name -- used as -- sender | emails sent from the application

## `auth.email.template.<type>.subject`
* subject | email template -- for -- the given type
  * types: `invite`, `confirmation`, `recovery`, `magic_link`, `email_change`

## `auth.email.template.<type>.content_path`
* content path | email template -- for -- the given type
  * types: `invite`, `confirmation`, `recovery`, `magic_link`, `email_change`

## `auth.email.notification.<type>.enabled`
* determines whether to send email notifications -- for -- the given type
  * types: `password_changed`, `email_changed`, `phone_changed`, `mfa_factor_enrolled`, `mfa_factor_unenrolled`, `identity_linked`, `identity_unlinked`

## `auth.email.notification.<type>.subject`
* subject -- for -- the given email notification type

## `auth.email.notification.<type>.content_path`
* relative path to the content template -- for -- the given email notification type

## `auth.sms.enable_signup`
* allow/disallow new user signups -- via -- SMS

## `auth.sms.enable_confirmations`
* if enabled -> users must confirm their phone number before signing in

## `auth.sms.test_otp`
* pre-defined map of phone number -> OTP -- for -- testing
  * usage: `[auth.sms.test_otp]` / `4152127777 = "123456"`

## `auth.sms.<provider>.enabled`
* use an external SMS provider
  * providers: `twilio`, `twilio_verify`, `messagebird`, `textlocal`, `vonage`

## `auth.sms.<twilio|twilio_verify>.account_sid`
* Twilio Account SID

## `auth.sms.<twilio|twilio_verify>.message_service_sid`
* Twilio Message Service SID

## `auth.sms.<twilio|twilio_verify>.auth_token`
* Twilio Auth Token
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `auth.sms.messagebird.originator`
* MessageBird Originator

## `auth.sms.messagebird.access_key`
* MessageBird Access Key
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `auth.sms.textlocal.sender`
* TextLocal Sender

## `auth.sms.textlocal.api_key`
* TextLocal API Key
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `auth.sms.vonage.from`
* Vonage From

## `auth.sms.vonage.api_key`
* Vonage API Key

## `auth.sms.vonage.api_secret`
* Vonage API Secret
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `auth.external.<provider>.enabled`
* use an external OAuth provider
  * providers: `apple`, `azure`, `bitbucket`, `discord`, `facebook`, `github`, `gitlab`, `google`, `kakao`, `keycloak`, `linkedin_oidc`, `notion`, `twitch`, `twitter`, `slack_oidc`, `spotify`, `workos`, `zoom`

## `auth.external.<provider>.client_id`
* client ID -- for -- the external OAuth provider

## `auth.external.<provider>.secret`
* client secret -- for -- the external OAuth provider
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `auth.external.<provider>.url`
* base URL -- for -- constructing authorization and access token URLs
  * used by `gitlab` and `keycloak`

## `auth.external.<provider>.redirect_uri`
* URI -- that -- OAuth2 provider will redirect to with the code and state values

## `auth.external.<provider>.skip_nonce_check`
* disables nonce validation during OIDC authentication flow
  * ⚠️ reduces security — allows potential replay attacks with stolen ID tokens⚠️

## `auth.hook.<hook_name>.enabled`
* enable Auth Hook
  * possible values: `custom_access_token`, `send_sms`, `send_email`, `mfa_verification_attempt`, `password_verification_attempt`

## `auth.hook.<hook_name>.uri`
* URI of hook to invoke
  * http/https function OR Postgres function: `pg-functions://<database>/<schema>/<function-name>`

## `auth.hook.<hook_name>.secrets`
* configure -- when using -- HTTP Hooks
  * base64 comma-separated values — for secret rotation

## `auth.mfa.totp.enroll_enabled`
* enable TOTP enrollment -- for -- MFA

## `auth.mfa.totp.verify_enabled`
* enable TOTP verification -- for -- MFA

## `auth.mfa.max_enrolled_factors`
* MAXIMUM number of MFA factors -- enrolled per -- user

## `auth.mfa.phone.enroll_enabled`
* enable Phone enrollment -- for -- MFA

## `auth.mfa.phone.otp_length`
* length of OTP code -- sent when using -- phone MFA

## `auth.mfa.phone.max_frequency`
* MINIMUM time -- between -- phone requests
  * _Example values:_ `"10s"`, `"20s"`, `"1m"`

## `auth.mfa.phone.verify_enabled`
* enable Phone verification -- for -- MFA

## `auth.mfa.web_authn.enroll_enabled`
* enable WebAuthn enrollment -- for -- MFA

## `auth.mfa.web_authn.verify_enabled`
* enable WebAuthn verification -- for -- MFA

## `auth.passkey.enabled`
* enable passkey sign-in and registration
  * ⚠️ requires `auth.webauthn` to be configured⚠️

## `auth.webauthn.rp_display_name`
* human-readable name -- for -- the WebAuthn relying party, shown to users during passkey ceremony
  * ⚠️ required when `auth.passkey.enabled = true`⚠️

## `auth.webauthn.rp_id`
* WebAuthn relying party identifier
  * must be a registrable suffix of every origin | `auth.webauthn.rp_origins`
  * ⚠️ required when `auth.passkey.enabled = true`⚠️

## `auth.webauthn.rp_origins`
* list of origins your app is served from
  * browser refuses WebAuthn ceremony if page origin ❌ NOT in this list❌
  * ⚠️ required when `auth.passkey.enabled = true`⚠️

## `auth.sessions.timebox`
* force log out after the specified duration
  * _Example values:_ `'50m'`, `'20h'`

## `auth.sessions.inactivity_timeout`
* force log out if user has been inactive longer than the specified duration

## `auth.third_party.aws_cognito.enabled`
* enable third party auth -- with -- AWS Cognito (Amplify)

## `auth.third_party.aws_cognito.user_pool_id`
* User Pool ID -- for -- AWS Cognito (Amplify)

## `auth.third_party.aws_cognito.user_pool_region`
* User Pool region -- for -- AWS Cognito (Amplify)
  * _Example values:_ `'ap-southeast-1'`, `'us-east-1'`

## `auth.third_party.auth0.enabled`
* enable third party auth -- with -- Auth0

## `auth.third_party.auth0.tenant`
* Tenant Identifier -- for -- Auth0 instance

## `auth.third_party.auth0.tenant_region`
* Tenant region -- for -- Auth0 instance

## `auth.third_party.firebase.enabled`
* enable third party auth -- with -- Firebase

## `auth.third_party.firebase.project_id`
* Project ID -- for -- Firebase instance

## `edge_runtime.enabled`
* enable the local Edge Runtime service -- for -- Edge Functions

## `edge_runtime.policy`
* request handling policy -- for -- Edge Functions
  * `oneshot`: recommended for development (hot reload support)
  * `per_worker`: recommended for load testing

## `edge_runtime.inspector_port`
* port -- to -- attach the Chrome inspector for debugging Edge Functions

## `functions.<function_name>.enabled`
* controls whether a function is deployed or served
  * `false` -> skipped during deployment & ❌ NOT served locally❌

## `functions.<function_name>.verify_jwt`
* if `true` -> rejects requests ❌ without❌ a valid JWT | Authorization header

## `functions.<function_name>.import_map`
* Deno import map file -- for -- the Function
  * default: `supabase/functions/<function_name>/deno.json`

## `functions.<function_name>.entrypoint`
* custom entrypoint path -- for -- the function, relative to project root
  * default: `supabase/functions/<function_name>/index.ts`

## `functions.<function_name>.static_files`
* array of static files -- to -- bundle with the function
  * supports glob patterns
  * ⚠️ only file paths within `functions` directory supported⚠️

## `analytics.enabled`
* enable the local Logflare service

## `analytics.port`
* port -- to -- the local Logflare service

## `analytics.vector_port`
* port -- to -- the local syslog ingest service

## `analytics.backend`
* configure one of the supported backends: `postgres`, `bigquery`

## `experimental.webhooks.enabled`
* automatically enable webhook features -- on -- each new created branch
  * ⚠️ experimental — may change in future releases⚠️

## `experimental.orioledb_version`
* configures Postgres storage engine -- to use -- OrioleDB with S3 support
  * ⚠️ experimental — may change in future releases⚠️

## `experimental.s3_host`
* S3 bucket URL -- for -- OrioleDB storage
  * format: `<bucket_name>.s3-<region>.amazonaws.com`
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `experimental.s3_region`
* S3 bucket region -- for -- OrioleDB storage
  * _Example:_ `us-east-1`
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `experimental.s3_access_key`
* `AWS_ACCESS_KEY_ID` -- for -- S3 bucket access
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `experimental.s3_secret_key`
* `AWS_SECRET_ACCESS_KEY` -- for -- S3 bucket access
  * ❌ DO NOT commit to git❌ — use env variable substitution

## `remotes.<branch_name>.project_id`
* project reference ID -- for -- a specific persistent Supabase branch
  * all root config options also supported | `remotes` block
