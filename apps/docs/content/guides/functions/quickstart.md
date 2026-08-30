---
id: 'functions-quickstart'
title: 'Getting Started with Edge Functions'
description: 'Get started with Supabase Edge Functions.'
subtitle: 'Learn how to create, test, and deploy your first Edge Function using the Supabase CLI.'
---

* goal
  * via Supabase CLI, about Supabase Edge Function, how to
    * create
    * test locally
    * deploy
    * invoke

## Prerequisites

* [Supabase CLI](../cli.md) 
  * installed 
  * configured
* Docker-compatible runtime

## Step 1: Create or configure your project

* | your project,
  * `supabase init`

## Step 2: Create your first function

* | your project,
  * `supabase functions new <EDGE_FUNCTION_NAME>` -> create
    * "supabase/functions/<EDGE_FUNCTION_NAME>/index.ts"

      ```tsx
      export default {
        fetch: withSupabase({ auth: ['publishable', 'secret'] }, async (req, ctx) => {
          const { name } = await req.json()
      
          return Response.json({
            message: `Hello ${name}!`,
          })
        }),
      }
      ```
      * `publishable`
        * use cases
          * client-side
      * `secret`
        * use cases
          * server-side
      * if you want to change this behavior -> pass `--auth` flag
        * == `supabase functions new <EDGE_FUNCTION_NAME> --auth <AUTH_MODE>`
    * OPTIONALLY
      * Deno configuration

* Supabase Edge Functions' URL
  * can be -- , via [Supabase Auth](../auth), -- secured

## Step 3: Test your function LOCALLY

```bash
# Start ALL Supabase services
supabase start
  
# serve ALL functions | http://localhost:54321/functions/v1/<EDGE_FUNCTION_NAME>
supabase functions serve
```

* Hot reloading
  * if you change the function code -> AUTOMATICALLY the server is reloaded
  * requirements
    * ⚠️keep the terminal window open⚠️

* Problems
  * Problem1: edge function is running
    * Attempt1: port ALREADY used
      * `supabase status`
        * if there is SOME UNNECESSARY Supabase service / block edge function's port -> `supabase stop`

## Step 4: Send a test request

```bash
# if you want to find <SUPABASE_PUBLISHABLE_KEY> -> `supabase status`
## 1. 's input "Functions"
curl -i --location --request POST 'http://<HOST>:<PORT>/functions/v1/<EDGE_FUNCTION_NAME>' \
  --header 'apiKey: <SUPABASE_PUBLISHABLE_KEY>' \
  --data '{"name":"Functions"}'

## 2. 's input "World"
curl -i --location --request POST 'http://<HOST>:<PORT>/functions/v1/<EDGE_FUNCTION_NAME>' \
  --header 'apiKey: <SUPABASE_PUBLISHABLE_KEY>' \
  --data '{"name":"World"}'
```

* 's return
  * edge function's `fetch()`'s output

## Step 5: Connect your local project -- to -- your Supabase project

* enable
  * [deploy your function globally](#step-6-deploy-edge-function--production)

* steps
  * `supabase login` 
    * authenticate
  * `supabase projects list`
    * find your project ID
  * `supabase link --project-ref [YOUR_PROJECT_ID]`
    * connect your local project -- to -- your remote Supabase project
  * `supabase status`
    * verify your local project authenticated is linked -- to -- your remote Supabase project

## Step 6: Deploy edge function | production

* deploy edge function | production
  * AVAILABLE | "https://[YOUR_PROJECT_ID].supabase.co/functions/v1/<EDGE_FUNCTION_NAME>"
  * == 💡deploy your function | Supabase's global edge network💡

```bash
# 1. deploy <EDGE_FUNCTION_NAME> function
supabase functions deploy <EDGE_FUNCTION_NAME>

# 2. deploy ALL edge functions
supabase functions deploy
```

* ⚠️if Docker is NOT available -> `supabase` AUTOMATICALLY falls back -- to -- API-based deployment⚠️
  * if you want to EXPLICITLY use API deployment -> pass `--use-api` flag

    ```bash
    supabase functions deploy <EDGE_FUNCTION_NAME> --use-api
    ```

## Step 7: Test your deployed edge function

* steps
  * Supabase Dashboard > project > Settings > API Keys
  * hit it

    ```bash
    curl --request POST 'https://[YOUR_PROJECT_ID].supabase.co/functions/v1/hello-world' \
      --header 'apikey: <SUPABASE_PUBLISHABLE_KEY>' \
      --header 'Content-Type: application/json' \
      --data '{"name":"Production"}'
    ```

## Usage

* == | an app,
  * invoke the edge function 

* steps
  * guarantee that the function can handle [CORS](cors) requests


TODO:

  * <Admonition type="note" label="Calling from the browser?">

 


</Admonition>

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="supabase-js"
>

<TabPanel id="supabase-js" label="Supabase Client">

```jsx
import { createClient } from '@supabase/supabase-js'

const supabase = createClient('https://[YOUR_PROJECT_ID].supabase.co', 'YOUR_PUBLISHABLE_KEY')

const { data, error } = await supabase.functions.invoke('hello-world', {
  body: { name: 'JavaScript' },
})

console.log(data) // { message: "Hello JavaScript!" }
```

</TabPanel>

<TabPanel id="fetch" label="Fetch API">

```jsx
const response = await fetch('https://[YOUR_PROJECT_ID].supabase.co/functions/v1/hello-world', {
  method: 'POST',
  headers: {
    apikey: '<SUPABASE_PUBLISHABLE_KEY>',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({ name: 'Fetch' }),
})

const data = await response.json()
console.log(data)
```

</TabPanel>

</Tabs>
