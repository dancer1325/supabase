---
title: Local Development & CLI
subtitle: Learn how to develop locally and use the Supabase CLI
---

* goal
  * develop your applications -- via -- the locally running Supabase stack

* ⚠️requirements⚠️
  * install the [Supabase CLI](local-development/cli/getting-started)
  * container runtime / Docker APIs-compatible
    * [Docker Desktop](https://docs.docker.com/desktop/)
      * recommended on
    * [Rancher Desktop](https://rancherdesktop.io/) (macOS, Windows, Linux)
    * [Podman](https://podman.io/) (macOS, Windows, Linux)
    * [OrbStack](https://orbstack.dev/) (macOS)

## Quickstart

<Admonition type="note">

Pick an install method and use the same tab in every step below
* **Homebrew** gives you a global `supabase` command
* **npm, pnpm, and yarn** install the CLI into your project as a dev dependency, 
so you run it through your package runner (`npx supabase`, `pnpm supabase`, or `yarn supabase`)

</Admonition>

1.  Install the Supabase CLI:

    </TabPanel><TabPanel id="brew" label="brew">

    ```sh
    brew install supabase/tap/supabase
    ```

    </TabPanel></Tabs>

2.  In your repo, initialize the local Supabase project:

    <Tabs scrollable size="small" type="underlined" defaultActiveId="npm" queryGroup="package-manager"><TabPanel id="npm" label="npm">

    ```sh
    npx supabase init
    ```

    </TabPanel><TabPanel id="yarn" label="yarn">

    ```sh
    yarn supabase init
    ```

    </TabPanel><TabPanel id="pnpm" label="pnpm">

    ```sh
    pnpm supabase init
    ```

    </TabPanel><TabPanel id="brew" label="brew">

    ```sh
    supabase init
    ```

    </TabPanel>

    </Tabs>

3.  Start the local Supabase stack:

    <Tabs scrollable size="small" type="underlined" defaultActiveId="npm" queryGroup="package-manager"><TabPanel id="npm" label="npm">

    ```sh
    npx supabase start
    ```

    </TabPanel><TabPanel id="yarn" label="yarn">

    ```sh
    yarn supabase start
    ```

    </TabPanel><TabPanel id="pnpm" label="pnpm">

    ```sh
    pnpm supabase start
    ```

    </TabPanel><TabPanel id="brew" label="brew">

    ```sh
    supabase start
    ```

    </TabPanel>

    </Tabs>

4.  View your local Supabase instance at [http://localhost:54323](http://localhost:54323).

<Admonition type="caution">

If your local development machine is connected to an untrusted public network, you should create a separate Docker network and bind to 127.0.0.1 before starting the local development stack. This restricts network access to only your localhost machine.

```sh
docker network create -o 'com.docker.network.bridge.host_binding_ipv4=127.0.0.1' local-network
npx supabase start --network-id local-network
```

You should never expose your local development stack publicly.

</Admonition>

## Local development

Local development with Supabase allows you to work on your projects in a self-contained environment on your local machine
*  Working locally has several advantages:

1. Faster development: You can make changes and see results instantly without waiting for remote deployments.
2. Offline work: You can continue development even without an internet connection.
3. Cost-effective: Local development is free and doesn't consume your project's quota.
4. Enhanced privacy: Sensitive data remains on your local machine during development.
5. Safe testing: You can experiment with different configurations and features without affecting your production environment.

Once set up, you can initialize a new Supabase project, start the local stack, and begin developing your application using local Supabase services
*  This includes access to a local Postgres database, Auth, Storage, and other Supabase features.
