---
title: 'Supabase CLI'
description: 'The Supabase CLI provides tools to develop your project locally, deploy to the Supabase Platform, and set up CI/CD workflows.'
subtitle: 'Develop locally, deploy to the Supabase Platform, and set up CI/CD workflows'
---

* Supabase CLI
  * == tool /
    * enables you to
      * run the entire Supabase stack 
        * | your machine, OR
        * | CI environment
      * manage hosted projects
  * `supabase init`
    * create a NEW LOCAL project
  * `supabase start`
    * launch the Supabase services

TODO: 
* It provides a suite of commands for various tasks, including:

- Setting up and managing local development environments
- Generating TypeScript types for your database schema
- Handling database migrations
- Managing environment variables and secrets
- Deploying your project to the Supabase platform

With the CLI, you can streamline your development workflow, automate repetitive tasks, and maintain consistency across different environments


<Admonition type="note" label="Global command vs. project dependency">

There are two ways to install the CLI, and they change the command you type:

- **Project dependency** with `npm`, `pnpm`, or `yarn` installs the CLI into a single project (there is no global `supabase` command with this method). Run it through your package runner instead, for example `npx supabase <command>`.
- **Global install** with Homebrew, Scoop, or Linux packages. Run commands as `supabase <command>`.

Either way, the CLI is **project-scoped**: most commands (including `start`) expect to run inside a directory that has been initialized with `supabase init`, which creates the `supabase/` folder and `config.toml`. Run `init` first, then the other commands from the same directory.

The rest of this page writes examples as `supabase <command>`; translate them to `npx supabase <command>` if you installed the CLI as a project dependency.

</Admonition>

## Installing the Supabase CLI

* ways
  * -- as -- project dev dependency
    * == installation | 1! project
    * ⚠️requirements⚠️
      * Node.js v20+
    * steps

    ```sh
    # 1. ways
    # 1.1 -- via -- npm
    npm install supabase --save-dev

    # 1.2 -- via -- yarn
    NODE_OPTIONS=--no-experimental-fetch yarn add supabase --dev
    
    # 1.3 -- via -- pnpm
    # 1.3.1 | pnpm v10-
    pnpm add supabase --save-dev 
    # 1.3.1 | pnpm v10+
    pnpm add supabase --save-dev --allow-build=supabase
    
    # 1.4 -- via -- bun
    bun add supabase --dev
    
    # 2. check
    # 2.1 npm
    npx supabase --help
    
    # 2.2 yarn
    yarn supabase --help
    
    # 2.3 pnpm
    pnpm supabase --help
    
    # 2.4 bun
    bunx supabase --help
    
    ```

  * globally
    * | macOS

      ```sh
      brew install supabase/tap/supabase
      ```
    * | Windows"

      ```powershell
      scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
      scoop install supabase
      ```
    * | Linux

      ```
      # 1. ways
      # 1.1
      sudo apk add --allow-untrusted <...>.apk
      # 1.2
      sudo dpkg -i <...>.deb
      # 1.3
      sudo rpm -i <...>.rpm
      ```

## Beta channel

TODO: 
Pre-release CLI builds ship from the development branch (`X.Y.Z-beta.N` versions). Use the npm `beta` dist-tag, or install `supabase-beta` via Homebrew / Scoop (separate packages from stable).

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="npm"
>
<TabPanel id="npm" label="npm">

Install as a dev dependency:

```sh
npm install supabase@beta --save-dev
```

Or run without installing:

```sh
npx supabase@beta --help
```

</TabPanel>
<TabPanel id="macos" label="macOS">

```sh
brew install supabase/tap/supabase-beta
brew link --overwrite supabase-beta
```

</TabPanel>
<TabPanel id="windows" label="Windows">

```powershell
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase-beta
```

</TabPanel>
<TabPanel id="linux" label="Linux">

#### Homebrew

```sh
brew install supabase/tap/supabase-beta
brew link --overwrite supabase-beta
```

#### Linux packages

Beta builds are attached to [GitHub pre-releases](https://github.com/supabase/cli/releases). Download the `.apk`, `.deb`, or `.rpm` for your platform and install with the same commands as [Linux packages](#linux-packages) above.

</TabPanel>
</Tabs>

## Updating the Supabase CLI

When a new [version](https://github.com/supabase/cli/releases) is released, you can update the CLI using the same channels.

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="macos"
>
<TabPanel id="macos" label="macOS">

```sh
brew upgrade supabase
```

Beta channel:

```sh
brew upgrade supabase-beta
```

</TabPanel>
<TabPanel id="windows" label="Windows">

```powershell
scoop update supabase
```

Beta channel:

```powershell
scoop update supabase-beta
```

</TabPanel>
<TabPanel id="linux" label="Linux">

#### Homebrew

```sh
brew upgrade supabase
```

Beta channel:

```sh
brew upgrade supabase-beta
```

#### Linux package manager

1. Download the latest package from the [Supabase CLI releases page](https://github.com/supabase/cli/releases/latest)
2. Install the package using the same commands as the [initial installation](#linux-packages):
   - `sudo apk add --allow-untrusted <...>.apk`
   - `sudo dpkg -i <...>.deb`
   - `sudo rpm -i <...>.rpm`

</TabPanel>
<TabPanel id="npm" label="npm">

If you have installed the CLI as dev dependency via [npm](https://www.npmjs.com/package/supabase), you can update it with:

```sh
npm update supabase --save-dev
```

Beta channel (`supabase@beta`):

```sh
npm update supabase@beta --save-dev
```

</TabPanel>
</Tabs>

If you have any Supabase containers running locally, stop them and delete their data volumes before proceeding with the upgrade. This ensures that Supabase managed services can apply new migrations on a clean state of the local database.

<Admonition type="tip" title="Backup and stop running containers">

Remember to save any local schema and data changes before stopping because the `--no-backup` flag will delete them.

```sh
supabase db diff -f my_schema
supabase db dump --local --data-only > supabase/seed.sql
supabase stop --no-backup
```

</Admonition>

## Running a local Supabase project

The most common thing you'll do with the CLI is run the full Supabase stack (Postgres, Auth, Storage, and the rest) on your own machine. That stack runs in Docker containers, so you need a container runtime installed first. Follow the official guide to install and configure [Docker Desktop](https://docs.docker.com/desktop) on your machine.

Alternately, you can use a different container tool that offers Docker compatible APIs.

- [Rancher Desktop](https://rancherdesktop.io/) (macOS, Windows, Linux)
- [Podman](https://podman.io/) (macOS, Windows, Linux)
- [OrbStack](https://orbstack.dev/) (macOS)
- [colima](https://github.com/abiosoft/colima) (macOS)

With a container runtime running, go to the folder where you want to create your project and initialize it:

```bash
supabase init
```

This creates a new `supabase` folder. It's safe to commit this folder to version control.

Now, from the same folder, start the Supabase stack:

```bash
supabase start
```

<Admonition type="note">

If you installed the CLI as a project dependency (npm, pnpm, yarn, or bun), run these as `npx supabase init` and `npx supabase start` instead. See the [note above](#installing-the-supabase-cli).

</Admonition>

This takes time on your first run because the CLI needs to download the Docker images to your local machine. The CLI includes the entire Supabase stack, and a few additional images useful for local development (like a local SMTP server and a database diff tool).

## Access your project's services

Once all the Supabase services are running, you'll see output containing your local Supabase credentials. It should look like the below, with urls and keys that you use in your local project:

```
Started supabase local development setup.

╭──────────────────────────────────────╮
│ 🔧 Development Tools                 │
├─────────┬────────────────────────────┤
│ Studio  │ http://127.0.0.1:54323     │
│ Mailpit │ http://127.0.0.1:54324     │
│ MCP     │ http://127.0.0.1:54321/mcp │
╰─────────┴────────────────────────────╯

╭──────────────────────────────────────────────────────╮
│ 🌐 APIs                                              │
├────────────────┬─────────────────────────────────────┤
│ Project URL    │ http://127.0.0.1:54321              │
│ REST           │ http://127.0.0.1:54321/rest/v1      │
│ GraphQL        │ http://127.0.0.1:54321/graphql/v1   │
│ Edge Functions │ http://127.0.0.1:54321/functions/v1 │
╰────────────────┴─────────────────────────────────────╯

╭───────────────────────────────────────────────────────────────╮
│ ⛁ Database                                                    │
├─────┬─────────────────────────────────────────────────────────┤
│ URL │ postgresql://postgres:postgres@127.0.0.1:54322/postgres │
╰─────┴─────────────────────────────────────────────────────────╯

╭──────────────────────────────────────────────────────────────╮
│ 🔑 Authentication Keys                                       │
├─────────────┬────────────────────────────────────────────────┤
│ Publishable │ sb_publishable_...                             │
│ Secret      │ sb_secret_...                                  │
╰─────────────┴────────────────────────────────────────────────╯
```

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="studio"
  queryGroup="access-method"
>
<TabPanel id="studio" label="Studio">

```sh
# Default URL:
http://localhost:54323
```

The local development environment includes Supabase Studio, a graphical interface for working with your database.

![Local Studio](/docs/img/guides/cli/local-studio.png)

</TabPanel>
<TabPanel id="postgres" label="Postgres">

```sh
# Default URL:
postgresql://postgres:postgres@localhost:54322/postgres
```

The local Postgres instance can be accessed through [`psql`](https://www.postgresql.org/docs/current/app-psql.html) or any other Postgres client, such as [pgAdmin](https://www.pgadmin.org/). For example:

```bash
psql 'postgresql://postgres:postgres@localhost:54322/postgres'
```

<Admonition type="note">

To access the database from an edge function in your local Supabase setup, replace `localhost` with `host.docker.internal`.

</Admonition>

</TabPanel>
<TabPanel id="kong" label="API Gateway">

```sh
# Default URL:
http://localhost:54321
```

If you are accessing these services without the client libraries, you may need to pass the client keys as an `Authorization` header. Learn more about [JWT headers](/docs/learn/auth-deep-dive/auth-deep-dive-jwts).

```sh
curl 'http://localhost:54321/rest/v1/' \
    -H "apikey: sb_publishable_..."

http://localhost:54321/rest/v1/           # REST (PostgREST)
http://localhost:54321/realtime/v1/       # Realtime
http://localhost:54321/storage/v1/        # Storage
http://localhost:54321/auth/v1/           # Auth (GoTrue)
```

<Admonition type="note">

`sb_publishable_...` is the publishable key output when you run the command `supabase start`.

</Admonition>

</TabPanel>
<TabPanel id="analytics" label="Analytics">

Local logs rely on the Supabase Analytics Server which accesses the docker logging driver by either volume mounting `/var/run/docker.sock` domain socket on Linux and macOS, or exposing `tcp://localhost:2375` daemon socket on Windows. These settings must be configured manually after [installing](/docs/guides/local-development/cli/getting-started#installing-the-supabase-cli) the Supabase CLI.

<Admonition type="note">

For advanced logs analysis using the Logs Explorer, it is advised to use the BigQuery backend instead of the default Postgres backend. Read about the steps [here](/docs/reference/self-hosting-analytics/introduction#bigquery).

</Admonition>

All logs are stored in the local database under the `_analytics` schema.

</TabPanel>
</Tabs>

## Stopping local services

When you are finished working on your Supabase project, you can stop the stack (without resetting your local database):

```bash
supabase stop
```

## Telemetry

The Supabase CLI collects telemetry data about general usage. Participating in this program is optional, and you can opt out at any time.

### How to opt out

You can disable telemetry by running:

```bash
supabase telemetry disable
```

You can check the current status and re-enable with:

```bash
supabase telemetry status
supabase telemetry enable
```

You can also opt out using the `SUPABASE_TELEMETRY_DISABLED=1` environment variable. The broader `DO_NOT_TRACK=1` convention is also respected.

## Learn more

- [CLI configuration](/docs/guides/local-development/cli/config)
- [CLI reference](/docs/reference/cli)
