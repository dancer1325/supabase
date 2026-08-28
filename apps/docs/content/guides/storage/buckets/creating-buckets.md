---
id: 'storage-creating-buckets'
title: 'Creating Buckets'
description: 'Learn how to create Supabase Storage buckets.'
sidebar_label: 'Buckets'
---

* ways to create a bucket
  * -- via -- Supabase Dashboard
    * steps
      * Supabase Dashboard > Storage > New bucket > 
        * enter a name
        * Create a bucket
  * -- via -- SQL
  * -- via -- Supabase client libraries

## Restricting uploads

* restrictions
  * by type -- `allowedMimeTypes` --
  * by [files' size](../uploads/file-limits.md) -- `fileSizeLimit` --
