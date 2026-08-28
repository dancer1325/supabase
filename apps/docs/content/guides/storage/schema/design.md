---
id: 'storage-schema-design'
title: 'The Storage Schema'
description: 'Learn about the storage schema'
subtitle: 'Learn about the storage schema'
sidebar_label: 'Schema'
---

* Supabase Storage 
  * store your buckets' metadata & objects' metadata | Postgres schema / name: "storage"
    * -> used Postgres' tables
      * are
        * "storage.buckets"
        * "storage.objects"
        * "storage.migrations"
      * recommendations
        * if you want to modify them (NOT recommended) ->
          * ❌NOT -- via -- SQL❌
          * ⚠️-- via -- API⚠️
            * Reason:🧠API modifies Postgres & S3🧠 
  * 's schema

    ```mermaid
    erDiagram
      buckets ||--o{ objects : "buckets_id:id"
      buckets {
        text id PK
        text name
        timestamptz created_at
        timestamptz updated_at
        boolean public
        bigint file_size_limit
        text[] allowed_mime_types
        text owner_id
      }
      objects {
        uuid id PK
        text bucket_id FK
        text name
        timestamptz created_at
        timestamptz updated_at
        jsonb metadata
        text[] path_tokens
        text version
        text owner_id
      }
      migrations {
        integer id PK
        varchar(100) name
        varchar(40) hash
        timestamp executed_at
      }
    ```

    * "bucket" - "objects" 
      * 1toN
      * MANY objects / 1 bucket
        * `buckets.id` -- to -- `objects.bucket_id`
    * "objects"
      * metadata / EACH file
    * "migrations"
      * == schema migrations / applied | Supabase Storage

## Modifying the schema

* recommendations
  * ❌NOT modify built-in schema's objects❌
  * add custom indexes / improve RLS policies' performance
