---
id: 'webhooks'
title: 'Database Webhooks'
description: 'Trigger external payloads on database events.'
subtitle: 'Trigger external payloads on database events.'
tocVideo: 'codAs9-NeHM'
---

* Database Webhooks
  * == database triggers
  * allow you to 
    * if a table event occurs -> FROM your database, send real-time data -- to -- ANOTHER system 

* if a database row is changed -> fire ALL events 

* table events
  * `INSERT`
  * `UPDATE`
  * `DELETE`

## Webhooks vs triggers

Database Webhooks are very similar to triggers, and 
that's because Database Webhooks are a convenience wrapper around triggers using the [pg_net](/docs/guides/database/extensions/pgnet) extension
* This extension is asynchronous, and therefore will not block your database changes for long-running network requests.

* [video](https://www.youtube.com/watch?v=codAs9-NeHM)
  * if a row is inserted | a `profiles` table -> how to create a NEW customer | Stripe 

## Creating a webhook

* steps
  1. | your Supabase Dashboard,
     * \> choose a project > integrations > webhooks > overview
  2. Give your Webhook a name.
  3. Select the table you want to hook into.
  4. Select one or more events (table inserts, updates, or deletes) you want to hook into.

 

We currently support HTTP webhooks
* These can be sent as `POST` or `GET` requests with a JSON payload.

## Payload

The payload is automatically generated from the underlying table record:

```typescript
type InsertPayload = {
  type: 'INSERT'
  table: string
  schema: string
  record: TableRecord<T>
  old_record: null
}
type UpdatePayload = {
  type: 'UPDATE'
  table: string
  schema: string
  record: TableRecord<T>
  old_record: TableRecord<T>
}
type DeletePayload = {
  type: 'DELETE'
  table: string
  schema: string
  record: null
  old_record: TableRecord<T>
}
```

## Monitoring

Logging history of webhook calls is available under the `net` schema of your database
* For more info, see the [GitHub Repo](https://github.com/supabase/pg_net).

## Local development

When using Database Webhooks on your local Supabase instance, you need to be aware that the Postgres database runs inside a Docker container
* This means that `localhost` or `127.0.0.1` in your webhook URL will refer to the container itself, not your host machine where your application is running.

To target services running on your host machine, use `host.docker.internal`
* If that doesn't work, you may need to use your machine's local IP address instead.

For example, if you want to trigger an edge function when a webhook fires, your webhook URL would be:

```
http://host.docker.internal:54321/functions/v1/my-function-name
```

If you're experiencing connection issues with webhooks locally, verify you're using the correct hostname instead of `localhost`.

## Resources

- [pg_net](/docs/guides/database/extensions/pgnet): an async networking extension for Postgres
