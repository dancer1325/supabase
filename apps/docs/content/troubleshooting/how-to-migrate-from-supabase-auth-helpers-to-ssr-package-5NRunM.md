---
title = "How to Migrate from Supabase Auth Helpers to SSR package"
github_url = "https://github.com/orgs/supabase/discussions/27849"
date_created = "2024-07-07T17:24:30+00:00"
topics = [ "auth" ]
keywords = [ "migration", "auth", "ssr", "package" ]
database_id = "273b79ad-b8ff-4669-8544-b99920e2d3c8"
---

* goal
  * migrate from `auth-helpers` packages -- to -- `@supabase/ssr` package

* [here](../server-side/migrating-to-ssr-from-auth-helpers.md)

TODO: what to do with rest of files?

### 3. Replace your proxy.ts file

```
// proxy.ts

import { type NextRequest } from "next/server"
import { updateSession } from "@/lib/supabase/proxy"

export async function proxy(request: NextRequest) {
  return await updateSession(request)
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * Feel free to modify this pattern to include more paths.
     */
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
}
```

### 4. Create your server actions to handle login and sign up

```
// app/login/actions.ts

'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

import { createClient } from '@/lib/supabase/server';

export async function login(formData: FormData) {
  const supabase = createClient();

  // type-casting here for convenience
  // in practice, you should validate your inputs
  const data = {
    email: formData.get('email') as string,
    password: formData.get('password') as string,
  };

  const { error } = await supabase.auth.signInWithPassword(data)

  if (error) {
    redirect('/error');
  }

  revalidatePath('/', 'layout');
  redirect('/');
}

export async function signup(formData: FormData) {
  const supabase = createClient();

  // type-casting here for convenience
  // in practice, you should validate your inputs
  const data = {
    email: formData.get('email') as string,
    password: formData.get('password') as string,
  };

  const { error } = await supabase.auth.signUp(data);

  if (error) {
    redirect('/error');
  }

  revalidatePath('/', 'layout');
  redirect('/');
}
```

### 5. Use the server actions in your login page UI

```
// app/login/page.tsx

import { login, signup } from './actions';

export default function LoginPage() {
  return (
    <form>
      <label htmlFor="email">Email:</label>
      <input id="email" name="email" type="email" required />
      <label htmlFor="password">Password:</label>
      <input id="password" name="password" type="password" required />
      <button formAction={login}>Log in</button>
      <button formAction={signup}>Sign up</button>
    </form>
  );
}
```

### 6. Client components

```
'use client';

// replace this line
import { createClientComponentClient } from '@supabase/auth-helpers-nextjs';

// with
import { createClient } from '@/lib/supabase/client';

export default async function Page() {
 // replace this line
 const supabase = createClientComponentClient<Database>();

 // with
 const supabase = createClient();

 return...
}
```

### 7. Server components

```
// replace
import { cookies } from 'next/headers';
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs';

// with
import { createClient } from '@/lib/supabase/server';

export default async function Page() {
 // replace
 const cookieStore = cookies();
 const supabase = createServerComponentClient<Database>({
  cookies: () => cookieStore
 });

 // with
 const supabase = createClient();

 return...
}
```

### 8. Route handlers

```
// replace
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs';
import { cookies } from 'next/headers';

// with
import { createClient } from '@/lib/supabase/server';

export async function POST(request: Request) {
 // replace
 const supabase = createRouteHandlerClient<Database>({
    cookies: () => cookieStore,
  });

  // with
  const supabase = createClient();

  return...
}
```

Likewise, you can replace the clients created with `@supabase/auth-helpers-nextjs`
with utility functions you created with `@supabase/ssr`.

`createMiddlewareClient` → `createServerClient`
`createClientComponentClient` → `createBrowserClient`
`createServerComponentClient` → `createServerClient`
`createRouteHandlerClient` → `createServerClient`

You can find more clear and concise examples of creating clients [in our SSR documentation](/docs/guides/auth/server-side/creating-a-client?queryGroups=framework&framework=nextjs&queryGroups=environment&environment=route-handler#creating-a-client).

If you have any feedback about this guide, provide them as a comment below
* If you find any issues or have feedback for the `@supabase/ssr` client, post them as an issue in `@supabase/ssr` repo.

As always, our GitHub community and Discord channel are open for technical discussions and resolving your issues.
