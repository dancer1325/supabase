# Supabase Next.js Auth & User Management Starter

* scenario
  * EXISTING users update their account

* goal
  * how to use
    * user 
      * signups -- via -- [Supabase Auth](https://supabase.com/auth)
        * [Supabase SSR Auth -- for -- Next.js](../../../apps/docs/content/guides/auth/server-side/nextjs)
      * avatar images -- via -- [Supabase Storage](../../../apps/docs/content/guides/storage)
    * Public profiles restricted -- via -- [RLS policies](../../../apps/docs/content/guides/database/postgres/row-level-security.md)

## technology stack

* FE
  * [Next.js](https://github.com/vercel/next.js)
  * [`@supabase/ssr`](https://supabase.com/docs/guides/auth/server-side/nextjs) for cookie-based SSR auth, used from both Server Components and Server Actions.
  * [`@supabase/supabase-js`](https://supabase.com/docs/library/getting-started) for the browser client and realtime data.
  * [Tailwind CSS v4](https://tailwindcss.com/) for styling.
- Backend:
  - [supabase.com/dashboard](https://supabase.com/dashboard/) — hosted Postgres database with a REST API, Auth, and Storage.
  - Local development via the [Supabase CLI](https://supabase.com/docs/guides/cli).

## Project structure

- `app/login/` — login and signup form. The form posts to Server Actions in `app/login/actions.ts` that call `supabase.auth.signInWithPassword()` and `supabase.auth.signUp()`.
- `app/account/` — protected profile page. Uses a Supabase server client to check the session and renders an account form with avatar upload.
- `app/auth/confirm/route.ts` — handles the email confirmation callback by verifying the OTP token and redirecting.
- `app/auth/signout/route.ts` — server route that signs the user out.
- `lib/supabase/client.ts` — browser client (`createBrowserClient`).
- `lib/supabase/server.ts` — server client (`createServerClient`) wired up to Next.js cookies.
- `supabase/migrations/` — database schema for the `profiles` table, RLS policies, the `handle_new_user` trigger, and the `avatars` storage bucket.
- `supabase/config.toml` — local Supabase configuration used by `npx supabase start`.

## how to deploy INSTANTLY?

The Vercel deployment will guide you through creating a Supabase account and project
* After installation of the Supabase integration, all relevant environment variables will be set up 
so that the project is usable immediately after deployment 🚀.

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fsupabase%2Fsupabase%2Ftree%2Fmaster%2Fexamples%2Fuser-management%2Fnextjs-user-management&project-name=supabase-nextjs-user-management&repository-name=supabase-nextjs-user-management&integration-ids=oac_VqOgBHqhEoFTPzGkPd7L0iH6&external-id=https%3A%2F%2Fgithub.com%2Fsupabase%2Fsupabase%2Ftree%2Fmaster%2Fexamples%2Fuser-management%2Fnextjs-user-management)

## how to run locally?

* requirements
  * Node.js v20+
  * `npx`
    * bundled -- with -- npm 

* steps
  * `npm install`
  * `npx supabase start`
    * responsible for
      * boots
        * Postgres
        * Auth
        * Storage
        * Supabase Studio locally
      * runs the "supabase/migrations/"
  * `cp .env.example .env.local`
  * `npm run dev`
  * http://localhost:3000

## Using a remote Supabase project

### 1. Create a project

Sign up at [https://supabase.com/dashboard](https://supabase.com/dashboard) and create a new project
* Wait for your database to start.

### 2. Get the URL and publishable key

Go to the Project Settings (the cog icon), open the API tab, and find your **Project URL** and **publishable key**.

The `publishable` key is your client-side API key
* It allows "anonymous access" to your database until the user logs in
* Once they log in, the user's own JWT is used, which enables Row Level Security to scope data per user
* Read more [below](#postgres-row-level-security).

> **Note:** The `secret` (service role) key has full access to your data and bypasses all security policies
* Keep it in server environments only — never expose it to the client or browser.

### 3. Link and push the schema

Copy the production env template and fill it in with your project URL, publishable key, and the URL(s) you want to allow as redirect targets:

```bash
cp .env.production.example .env.production
```

Link your local checkout to the remote project:

```bash
SUPABASE_ENV=production npx supabase@latest link --project-ref <your-project-ref>
```

Push the `supabase/config.toml` settings (Auth site URL, redirect URLs, etc.):

```bash
SUPABASE_ENV=production npx supabase@latest config push
```

Push the database schema in `supabase/migrations/`:

```bash
SUPABASE_ENV=production npx supabase@latest db push
```

## Vercel Preview with Branching

Supabase integrates seamlessly with Vercel's preview branches, giving each branch a dedicated Supabase project
* This setup allows testing database migrations or service configurations safely before applying them to production.

### Steps

1. Ensure the Vercel project is linked to a Git repository.
2. Configure the "Preview" environment variables in Vercel:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`

3. Create a new branch, make changes (e.g., update `max_frequency`), and push the branch to Git.
   - Open a pull request to trigger the Vercel + Supabase integration.
   - Upon successful deployment, the preview environment reflects the changes.

![Preview Checks](https://github.com/user-attachments/assets/db688cc2-60fd-4463-bbed-e8ecc11b1a39)

## Postgres RLS

* This project uses high-level authorization via Postgres' Row Level Security.
When you start a Postgres database on Supabase, we populate it with an `auth` schema and some helper functions.
When a user logs in, they are issued a JWT with the role `authenticated` and their UUID.
We can use these details to provide fine-grained control over what each user can and cannot do.

* [schema & policies](supabase/migrations/20221017024722_init.sql)

## More Supabase examples & resources

### Examples

These official examples are maintained by the Supabase team:

- [Next.js Subscription Payments Starter](https://github.com/vercel/nextjs-subscription-payments)
- [Next.js Slack Clone](https://github.com/supabase/supabase/tree/master/examples/slack-clone/nextjs-slack-clone)
- [Next.js Data Fetching](https://github.com/supabase/supabase/tree/master/examples/caching/with-nextjs-13)
- [And more...](https://github.com/supabase/supabase/tree/master/examples)

### Other resources

- [[Docs] Next.js User Management Quickstart](https://supabase.com/docs/guides/getting-started/tutorials/with-nextjs)
- [[Docs] Server-Side Auth for Next.js](https://supabase.com/docs/guides/auth/server-side/nextjs)
- [[Blog] Fetching and caching Supabase data in Next.js 13 Server Components](https://supabase.com/blog/fetching-and-caching-supabase-data-in-next-js-server-components)
