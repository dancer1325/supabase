---
id: 'storage-access-control'
title: 'Storage Access Control'
description: 'Learn how to restrict Supabase file uploads.'
sidebar_label: 'Uploads'
tocVideo: '4ERX__Y908k'
---

* storage restriction access
  * -- thanks to -- [Row Level Security (RLS)](../../database/postgres/row-level-security) 

## Access policies

* Supabase Storage
  * by default,
    * does NOT allow ANY uploads | buckets
      * Reason:🧠NOT contain RLS policies🧠
  * if you want to enable certain operations -> create RLS policies | `storage.objects` table
    * _Example:_ if you want to 
      * upload objects -> grant the `INSERT` permission | `storage.objects` table
      * overwrite files (== `upsert`) -> grant `SELECT` & `UPDATE` permissions
  * ['s schema](../schema/design)
  * if you want to simplify the process of crafting your policies -> use the [helper functions](../schema/helper-functions) 
    * _Example:_ if you need DIFFERENT `SELECT` policies / DIFFERENT Storage actions (_Example:_ listing objects vs reading authenticated objects) -> use
      * `storage.allow_only_operation()`
      * `storage.allow_any_operation()`

## Bypassing access controls

* == bypass the RLS policies
* use cases
  * you ONLY use Storage -- from -- trusted clients (_Example:_ your own servers)

* Service keys
  * grant unrestricted access | ALL Storage APIs
  * steps to use
    * | `Authorization` header,
      * add `service key`
