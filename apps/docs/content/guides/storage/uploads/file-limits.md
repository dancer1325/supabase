---
id: 'storage-file-limits'
title: 'Limits'
subtitle: 'Learn how to increase Supabase file limits.'
description: 'Learn how to increase Supabase file limits.'
sidebar_label: 'Limits'
---

## GLOBALLY file size

* requirements
  * ⚠️Supabase Cloud⚠️
    * == ❌NOT ALLOWED | Supabase local❌
* -> apply | ALL your buckets
* steps
  * Supabase Dashboard > Storage > Files > Settings
* ⚠️restrictions / Supabase Cloud plan⚠️
    
    | Plan       | Max File Size Limit |
    | ---------- | ------------------- |
    | Free       | 50 MB               |
    | Pro        | 500 GB              |
    | Team       | 500 GB              |
    | Enterprise | Custom              |

## MAXIMUM file size / bucket

* [how to specify](../buckets/creating-buckets.md#restricting-uploads)
* MAXIMUM file size / bucket <= GLOBALLY file size's limits

## File name restrictions

* | file names,
  * ⚠️ONLY ALLOWED characters⚠️
    - **Alphanumeric**: `A-Z`, `a-z`, `0-9`
    - **Punctuation**: `_` (underscore), `-` (hyphen), `.` (dot), `'` (apostrophe), `,` (comma)
    - **Special characters**: `!`, `*`, `&`, `$`, `@`, `=`, `;`, `:`, `+`, `?`, `(`, `)`
    - **Whitespace**
