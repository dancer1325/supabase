---
title: 'Supabase CLI'
description: 'The Supabase CLI provides tools to develop your project locally, deploy to the Supabase Platform, and set up CI/CD workflows.'
subtitle: 'Develop locally, deploy to the Supabase Platform, and set up CI/CD workflows'
---

* Supabase CLI
  * [introduction](../../cli.md)
  * 's commands
    * `supabase init`
      * create a NEW LOCAL project
    * `supabase start`
      * launch the Supabase services
  * ⚠️is project-scoped⚠️
    * _Example:_ MOST commands (as `start`) expect to run | directory / has ALREADY initialized (==`supabase init`)
      * == contains
        * "supabase/"
        * "config.toml"

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

* [introduction](../../local-development.md)

## Telemetry

TODO: 
The Supabase CLI collects telemetry data about general usage
* Participating in this program is optional, and you can opt out at any time.

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

You can also opt out using the `SUPABASE_TELEMETRY_DISABLED=1` environment variable
* The broader `DO_NOT_TRACK=1` convention is also respected.
