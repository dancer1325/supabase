---
title: 'Use Supabase Auth with Next.js'
subtitle: 'Learn how to configure Supabase Auth for the Next.js App Router.'
breadcrumb: 'Auth Quickstarts'
hideToc: true
---

* goal
  * how to configure Supabase Auth -- for -- Next.JS App Router?

### 1. Create a new Supabase project

Head over to [database.new](https://database.new) and create a new Supabase project.

Your new database has a table for storing your users
* You can see that this table is currently empty by running some SQL in the [SQL Editor](/dashboard/project/_/sql/new).

```sql
select * from auth.users;
```

### 2. Create a Next.js app

Use the `create-next-app` command and the `with-supabase` template, to create a Next.js app pre-configured with:
- [Cookie-based Auth](/docs/guides/auth/server-side/creating-a-client?queryGroups=package-manager&package-manager=npm&queryGroups=framework&framework=nextjs&queryGroups=environment&environment=server)
- [TypeScript](https://www.typescriptlang.org/)
- [Tailwind CSS](https://tailwindcss.com/)

```bash
npx create-next-app -e with-supabase
```

### 3. Declare Supabase Environment Variables

* 
Rename `.env.example` to `.env.local` and populate with your Supabase connection variables:

```text
# .env.local
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_... key
```

### 4. Start the app

Start the development server, go to http://localhost:3000 in a browser, and you should see the contents of `app/page.tsx`.

To sign up a new user, navigate to http://localhost:3000/auth/sign-up, and click `Sign up`.

```bash
npm run dev
```

## Learn more

- [Setting up Server-Side Auth for Next.js](/docs/guides/auth/server-side/creating-a-client?queryGroups=framework&framework=nextjs) for a Next.js deep dive
- [Supabase Auth docs](/docs/guides/auth#authentication) for more Supabase authentication methods
