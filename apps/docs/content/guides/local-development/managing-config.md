---
id: 'managing-config'
title: 'Managing config and secrets'
description: 'Managing local configuration using config.toml.'
---

* goal
  * Supabase CLI's "config.toml"

## Config reference -- "config.toml" --

* AUTOMATICALLY created | run `supabase init`
* located | "<YOUR_PROJECT>/supabase/"
* allows
  * manage local configuration
* [reference](../../../spec/cli_v1_config.yaml)

### how to use secrets | "config.toml"?

* `env()` function
  * allows
    * reference environment variables | "config.toml" 
  * detect any values / stored | root of your project directory's ".env" 
  * uses
    * store sensitive information
      * _Examples:_ API keys, OTHER values / you do NOT want to check | version control

    ```
    .
    ├── .env
    ├── .env.example
    └── supabase
        └── config.toml
    ```

### MORE advanced secrets management workflows

* **Using dotenvx** 
  * allows
    * securely manage environment variables | DIFFERENT branches & environments
  * _Example:_ [here](../../../../../examples/slack-clone/nextjs-slack-clone-dotenvx)
* [**Branch-specific secrets**](../deployment/branching)
* **Encrypted configuration values | your "config.toml"**
