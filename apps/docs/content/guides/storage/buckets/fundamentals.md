---
id: 'storage-bucket-public-and-private'
title: 'Storage Buckets'
description: 'Learn how Supabase Storage Buckets works.'
sidebar_label: 'Buckets'
---

* Buckets
  * allow you to
    * keep your files organized
    * determine the [access Model](#access-model) -- for -- your assets
  * [upload restrictions](creating-buckets#restricting-uploads)

## Access model

### Private buckets

* ⚠️default one⚠️
* -> ALL operations (EVEN download assets) are subject -- , via [RLS policies](../security/access-control), to -- access control

* ways to download assets | private bucket
  * use the `download()` method | JS,
    * by providing an authorization header containing your user's JWT
    * The RLS policy you create on the `storage.objects` table will use this user to determine if they have access.
  * create a signed URL -- via -- `createSignedUrl` method
    * can be accessed | limited time

* _Example of use cases:_
  - Uploading users' sensitive documents
  - Securing private assets -- by -- using RLS
    - == set up fine-grain access controls

### Public buckets

* allows
  * retrieving & serving files | the bucket
    * -> ⚠️ANYONE / possesses the asset URL -> can readily access the file⚠️
    * ❌NOT enable
      * upload
      * delete
      * moving
      * copying❌

* _Example of use cases:_
  - User profile pictures
  - User public media
  - Blog post content

* vs private buckets
  * MORE performant
    * Reason:🧠[cached differently](../cdn/fundamentals#public-vs-private-buckets)🧠
