---
id: 'development-environment'
title: 'Development Environment'
description: 'Get the best Edge Functions experience with the right local developer environment.'
subtitle: 'Set up your local development environment for Edge Functions.'
tocVideo: 'lFhU3L8VoSQ'
---

* requirements
  * [install Supabase CLI](../cli.md)

## Step 1: Install Deno CLI

* Supabase CLI
  * 👀serves -- , through its OWN Edge Runtime, -- functions locally👀
    * ❌!= use the standard Deno CLI❌ 
    * Reason:🧠 keep consistent the development & production environment🧠

* [how to install SEPARATELY Deno?](https://deno.com/manual@v1.32.5/getting_started/setup_your_environment)
  * ADVANTAGES
    * Deno LSP enable
      * improve your editor's autocompletion
      * type checking
      * testing
    * Deno's built-in tools
      * _Examples:_ `deno fmt`, `deno lint`, and `deno test`
  * if you want to check that it's PROPERLY installed -> `deno --version`

## Step 2: Set up your editor

Set up your editor environment for proper TypeScript support, autocompletion, and error detection.

### VSCode/Cursor (recommended)

1. **Install the Deno extension** from the VSCode marketplace
2. **Option 1: Auto-generate (easiest)**
   When running `supabase init`, select `y` when prompted "Generate VS Code settings for Deno? [y/N]"
3. **Option 2: Manual setup**

   Create a `.vscode/settings.json` in your project root:

   ```json
   {
     "deno.enablePaths": ["./supabase/functions"],
     "deno.importMap": "./supabase/functions/deno.json"
   }
   ```

This configuration enables the Deno language server only for the `supabase/functions` folder, 
while using VSCode's built-in JavaScript/TypeScript language server for all other files.

---

### Multi-root workspaces

The standard `.vscode/settings.json` setup works perfectly for projects where your Edge Functions
live alongside your main application code
* However, you might need multi-root workspaces if your development setup involves:

- **Multiple repositories:** Edge Functions in one repo, main app in another
- **Microservices:** Several services you need to develop in parallel

For this development workflow, create `edge-functions.code-workspace`:

<$CodeSample
path="/edge-functions/edge-functions.code-workspace"
meta="edge-functions.code-workspace"
language="json"
/>

You can find the complete example on [GitHub](https://github.com/supabase/supabase/tree/master/examples/edge-functions).

---

## Recommended project structure

It's recommended to organize your functions according to the following structure:

```bash
└── supabase
    ├── functions
    │   ├── deno.json           # Top-level Deno configuration
    │   ├── _shared             # Shared code (underscore prefix)
    │   │   ├── supabaseAdmin.ts # Supabase client with SECRET key
    │   │   ├── supabaseClient.ts # Supabase client with PUBLISHABLE key
    │   │   └── cors.ts         # Reusable CORS headers
    │   ├── function-one        # Use hyphens for function names
    │   │   └── index.ts
    │   └── function-two
    │       └── index.ts
    ├── tests
    │   ├── function-one-test.ts
    │   └── function-two-test.ts
    ├── migrations
    └── config.toml
```

- **Use "fat functions"**
* Develop few, large functions by combining related functionality
* This minimizes cold starts.
- **Name functions with hyphens (`-`)**
* This is the most URL-friendly approach
- **Store shared code in `_shared`**
* Store any shared code in a folder prefixed with an underscore (`_`).
- **Separate tests**
* Use a separate folder for [Unit Tests](/docs/guides/functions/unit-test) that includes the name of the function followed by a `-test` suffix.

---

## Essential CLI commands

### `supabase start`

* allow
  * start LOCALLY your entire Supabase stack (database, auth, storage, and Edge Functions runtime)

### `supabase functions serve [function-name]`

* allow
  * develop a specific function / 
    * hot reloading feature
    * functions run | http://localhost:54321/functions/v1/[function-name

* `supabase functions serve`
  * serve ALL functions

### `supabase functions deploy hello-world`

* allow
  * deploy the function
