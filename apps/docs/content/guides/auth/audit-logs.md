---
id: 'auth-audit-logs'
title: 'Auth Audit Logs'
description: 'Monitor and track authentication events with audit logging.'
subtitle: 'Monitor and track authentication events with audit logging.'
---

* Auth audit logs
  * ' scope
    * your Supabase project
  * allows
    * track of authentication events
      * Reason:🧠AUTOMATICALLY capture ALL authentication events🧠
      * _Examples:_ 
        * User signups and logins
        * Password changes and resets
        * Email verification events
        * Token refresh and logout events
  * uses
    * monitor user authentication activities
    * detect suspicious behavior
    * maintain compliance -- with -- security requirements
  * ' [storing](#storage)

## Storage

* default places | audit logs are stored
  1. your project's Postgres database's `auth.audit_log_entries` table
     * if you want to reduce database storage costs -> disable it
  2. External log storage
     * == cost-efficient storage / accessible -- through -- the Supabase Dashboard 

### how to configure ?

* steps
  * Supabase Dashboard > choose your project > Authentication > Audit Logs
    * if you want to disable database storage -> toggle on "Disable writing auth audit logs to project database"

## Log format

* [here](https://github.com/supabase/auth/blob/master/internal/models/audit_log_entry.go#L100)

### Log actions reference

* [source code](https://github.com/supabase/auth/blob/master/internal/models/audit_log_entry.go#L23-L48)
  * TODO: add next table to source code


| Action                          | Description                             |
| ------------------------------- | --------------------------------------- |
| `user_signedup`                 | New user registration                   |
| `user_invited`                  | User invitation sent                    |
| `user_deleted`                  | User account deleted                    |
| `user_modified`                 | User profile updated                    |
| `user_recovery_requested`       | Password reset request                  |
| `user_reauthenticate_requested` | User reauthentication required          |
| `user_confirmation_requested`   | Email/phone confirmation requested      |
| `user_repeated_signup`          | Duplicate signup attempt                |
| `user_updated_password`         | Password change completed               |
| `token_revoked`                 | Refresh token revoked                   |
| `token_refreshed`               | Refresh token used to obtain new tokens |
| `generate_recovery_codes`       | MFA recovery codes generated            |
| `factor_in_progress`            | MFA factor enrollment started           |
| `factor_unenrolled`             | MFA factor removed                      |
| `challenge_created`             | MFA challenge initiated                 |
| `verification_attempted`        | MFA verification attempt                |
| `factor_deleted`                | MFA factor deleted                      |
| `recovery_codes_deleted`        | MFA recovery codes deleted              |
| `factor_updated`                | MFA factor settings updated             |
| `mfa_code_login`                | Login with MFA code                     |
| `identity_unlinked`             | An identity unlinked from account       |

## Limitations

* short delay BETWEEN: triggered event -- appear logs
* query capabilities
  * == dashboard interface
