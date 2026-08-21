# Supabase Studio / Supabase Dashboard

* allows
  * managing your Supabase project
* uses
  * | ANY hosted Supabse approach
    * [cloud](https://supabase.com/dashboard)
    * [self-hosted](../docs/content/guides/self-hosting.md)
* -- based on -- 
  * [Next.js](https://nextjs.org/)
  * [Tailwind](https://tailwindcss.com/)
* ❌NOT allow❌
  * deploy & manage projects
* allows
  * | EXISTING deployments,
    * Table & SQL editors
      * EXCEPT to: ❌save queries❌
    * database management
    * API documentation

## Managing Project Settings

* Project settings 
  * managed | ⚠️outside of the Dashboard⚠️
    * if you use 
      * docker compose -> managed | your docker-compose file
      * Supabase cloud -> store your secrets & env vars | vault or secrets manager

## How to contribute?

TODO: 
- Branch from `master` and name your branches with the following structure
  - `{type}/{branch_name}`
    - Type: `chore | fix | feature`
    - The branch name is arbitrary — just make sure it summarizes the work.
- When you send a PR to `master`, it will automatically tag members of the frontend team for review.
- Review the main [contributing guide](../../CONTRIBUTING.md) to help test your feature before sending a PR.
- The Dashboard is under active development. You should run `git pull` frequently to make sure you're up to date.

### Developer Quickstart

* | Supabase internal,
  * [internal `infrastructure` repo](https://github.com/supabase/platform/blob/develop/docs/contributing.md)

* steps
  ```bash
  # You'll need to be on Node v22
  # in /studio
  
  ## For external contributors
  pnpm install # install dependencies
  pnpm run dev # start dev server
  
  ## For internal contributors
  ## First clone the private supabase/platform repo and follow instructions for setting up mise
  mise studio  # Run from supabase/platform alongside `mise infra`
  
  ## For all
  pnpm run test # run tests
  pnpm run test -- --watch # run tests in watch mode
  ```

## Running within a self-hosted environment

TODO: 
Follow the [self-hosting guide](https://supabase.com/docs/guides/hosting/docker) to get started.

```
cd ..
cd docker
docker compose -f docker-compose.yml -f ./dev/docker-compose.dev.yml up
```

Once you've got that set up, update `.env` in the studio folder with the corresponding values.

```
POSTGRES_PASSWORD=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_KEY=
```

Then run the following commands to install dependencies and start the dashboard.

```
npm install
npm run dev
```

If you would like to configure different defaults for "Default Organization" and "Default Project", 
you will need to update the `.env` in the studio folder with the corresponding values.

```
DEFAULT_ORGANIZATION_NAME=
DEFAULT_PROJECT_NAME=
```
