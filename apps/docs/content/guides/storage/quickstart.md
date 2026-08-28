---
id: 'storage-quickstart'
title: 'Storage Quickstart'
description: 'Learn how to use Supabase to store and serve files.'
subtitle: 'Learn how to use Supabase to store and serve files.'
sidebar_label: 'Quickstart'
tocVideo: 'J9mTPY8rIXE'
---

* goal
  * Supabase Storage's basic functionality 

## Concepts

### Files

* == ANY media file
  * _Examples:_ images, GIFs, and videos
* allows
  * storing files -- outside -- the database
    * Reason:🧠Supabase Storage != Postgres🧠
    * 👀recommended👀
      * Reason:🧠files' size🧠
* HTML files
  * are returned -- as -- plain text
* ⚠️['s naming restrictions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html)⚠️

### Folders

* folders 
  * allows
    * organize your files
  * ⚠️['s naming restrictions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html)⚠️

### Buckets

* Buckets
  * == "super folders"
  * == INDEPENDENT containers  
    * of files & folders
  * uses
    * create DISTINCT buckets / DIFFERENT Security &  Access Rules
  * ⚠️['s naming restrictions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html)⚠️

## Create a bucket

* ways
  * -- via -- Supabase Dashboard
    * \> Storage > New Bucket > enter name > Create bucket
  * -- via -- SQL
  * -- via -- Supabase client libraries

## Upload a file

* ways
  * -- via -- Supabase Dashboard
    * \> Storage > choose the Bucket > upload file
  * -- via -- SQL
  * -- via -- Supabase client libraries

## Download a file

* ways
  * -- via -- Supabase Dashboard
    * \> Storage > choose the Bucket > choose a file > download
  * -- via -- SQL
  * -- via -- Supabase client libraries

## Add security rules

* policies
  * uses
    * | files
    * | buckets
  * ALLOWED operations
    * downloads (SELECT)
    * uploads (INSERT)
    * updates (UPDATE)
    * deletes (DELETE)
* allows
  * restrict access | your files 

* ways
  * -- via -- Supabase Dashboard
    * \> Storage > Files > Policies 
  * -- via -- SQL
  * -- via -- Supabase client libraries

* [video](https://www.youtube.com/watch?v=J9mTPY8rIXE)
  * TODO: 
