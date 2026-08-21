# ⚠️requirements⚠️
## container runtime / Docker APIs-compatible
### Reason:🧠| run supabase project, bootstrap Supabase's components -- as -- containers🧠
#### Docker Desktop
* `npx supabase start` OR `supabase start`
* `docker ps`
  * check bootstrapped containers
#### Rancher Desktop (macOS, Windows, Linux)
* `npx supabase start` OR `supabase start`
  * Problems
    * Problem1: 

        ```text
        "failed to start docker container "supabase_vector_supabase": Error response from daemon: error while creating mount
              source path '/Users/*/.rd/docker.sock': mkdir /Users/*/.rd/docker.sock: operation not supported "
        ```
      * ATTEMPT1: `export DOCKER_HOST=unix:///Users/*/.rd/docker.sock`
      * ATTEMPT2: use container engine dockerd OR containerd
      * SOLUTION: TODO: 
#### Podman (macOS, Windows, Linux)
TODO:
#### OrbStack (macOS)
TODO:
#### colima (macOS)
TODO:

# how to start?
## steps
### | your repo, initialize the local Supabase project
* | here
  * `npx supabase init`
#### | FIRST run, it takes times -- Reason: 🧠CLI needs to download the Docker images | your local machine🧠
* check printed logs
#### == create "supabase/"
* [here](supabase)
### | your repo, start the local Supabase stack
* | here,
  * `npx supabase start`
#### 's output
##### your local Supabase credentials
* check printed log
  * Authentication Keys
  * Storage
###### provided tools
TODO:
####### Supabase Studio
TODO:
####### API Gateway
TODO:
######## if you try to access these services WITHOUT the client libraries -> pass the client keys -- as an -- `Authorization` header
TODO:
####### Postgres
TODO:
######## if you want to access -> -- through -- ANY Postgres client
TODO:
######## if you want to access the database -- through -- edge function | your local Supabase setup -> replace `localhost` -- with -- `host.docker.internal`
TODO:
####### Supabase Analytics Server
TODO:
######## accesses the docker logging driver -- through --
TODO:
######## logs are stored | local database | `_analytics` schema
TODO:
######## if you want advanced logs analysis -- via -- Logs Explorer -> use the BigQuery backend
TODO:
##### 👀if your local development machine is connected -- to an -- untrusted public network -> create a separate Docker network & bind to 127.0.0.1👀
TODO:
###### Reason: 🧠restrict network access -- to -- ONLY your localhost machine🧠
TODO:
##### recommendations
TODO:
###### ❌NEVER expose your local development stack PUBLICLY❌
TODO:
### | your browser,
TODO:
#### http://localhost:54323
TODO:
##### your local Supabase instance
TODO:
# how to stop (WITHOUT resetting your local database) ?
TODO:
# Local development
TODO:
## Supabase -- via -- local development
TODO:
### allows you to
TODO:
#### work on your projects | self-contained environment | your local machine
TODO:
### advantages
TODO:
#### 1. Faster development
TODO:
##### == make changes & see results INSTANTLY WITHOUT waiting for remote deployments
TODO:
#### 2. Offline work
TODO:
##### == develop WITHOUT internet connection
TODO:
#### 3. Cost-effective
TODO:
##### == free
TODO:
#### 4. Enhanced privacy
TODO:
##### Reason: 🧠sensitive data lives | your local machine🧠
TODO:
#### 5. Safe testing
TODO:
##### Reason: 🧠you experiment with DIFFERENT configurations + features / WITHOUT affecting your production environment🧠
TODO:
