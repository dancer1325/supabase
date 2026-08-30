---
id: 'architecture'
title: 'Edge Functions Architecture'
description: 'Guide to Supabase Edge Functions: Architecture and How They Work'
subtitle: 'Understanding the Architecture of Supabase Edge Functions'
tocVideo: 'za_loEtS4gs'
---

* goal
  * Supabase Edge Functions'
    * architecture 
    * inner workings  

* Edge functions
  * == serverless compute resources /
    * run | edge of the network 
      * == close to users
    * enable
      * low-latency execution / tasks 
        * _Example of tasks:_ API endpoints, webhooks, and real-time data processing
  * advantages
    * Low Latency
      * Reason:🧠-- thanks to -- proximity to users🧠
    * Scalability
      * Reason:🧠you do NOT need to provision servers🧠
    * Developer-Friendly
      * Reason:🧠Supabase self-manage the architecture🧠
    * Cost-Effective
      * Reason:🧠pay / use model🧠
  * COMMON use cases
    * real-time data transformations
      * _Example:_ image processing
    * API integrations & webhooks
    * Personalization & A/B testing | edge

## 1. Understanding Edge Functions

* Edge Functions
  * how to define them?
    * as ".js" file | Supabase's "functions/"
  * allow
    * handle compute-intensive tasks | server-side | edge
      * Reason:🧠NO bother the client device OR database🧠
      * | edge
        * == the closest node -- to the -- customer
        * enable
          * speed
          * scalability 
    * integrates seamlessly -- with -- Supabase services (Supabase Storage, Supabase Auth)

* _Example:_ photo-sharing app / apply filters to photos (e.g., grayscale or sepia)
  * Workflow Overview
    * user uploads an original image | Supabase Storage
    * user selects a filter
      * == client-side app invokes -- , via Supabase JavaScript SDK, -- an edge function /
        1. Downloads the original image -- from -- Supabase Storage
        2. Applies the filter -- by using -- a library
        3. Uploads the processed image | Storage
        4. Returns the path to the filtered image -- to -- the client

## 2. Deployment process

* edge function deployment process
  * is
    * straightforward
    * automated
  * steps
    * | your app's 
       * "supabase/", 
         * write the function 
       * root path,
         * `supabase functions deploy <FUNCTION_NAME>` ->
           * function + its dependencies are bundled | ".ESZip"
             * == format /
               * created -- by -- Deno
               * ALSO contains a module graph -- for -- quick loading & execution
             * & uploaded | Supabase's backend
           * generate a function's UNIQUE URL
             * -> GLOBALLY accessible
  * benefits
    * AUTOMATIC handling of dependencies & bundling
    * ❌NO need to manage infrastructure❌
      * Reason:🧠 Supabase distributes the function | its global edge network / handle
        * scaling 
        * availability🧠
  * enable
    * function can be invoked from ANYWHERE

## 3. GLOBAL distribution & routing

* Edge functions' distributed architecture
  * allows
    * minimize -- , thanks to global edge network, -- latency
  * ' components
    * **Global API Gateway**
      * == entry point / ALL requests
        * determine -- , by requester's IP address, -- the geographic location
        * routes the request -- to -- the nearest edge location
          * _Example:_ routing a request FROM Amsterdam -- to -- Frankfurt
    * **Edge Locations**
      * == Supabase's network of data centers worldwide | functions are replicated
        * ".ESZip" bundle is AUTOMATICALLY distributed | these locations
    * **Routing Logic**
      * TODO: Based on geolocation mapping, ensuring the function executes as close as possible to the user for optimal performance.
  * how does distribution works?
    * Post-deployment
      * == function is propagated | ALL edge nodes
    * TODO: This setup eliminates the need for developers to configure CDNs or regional servers manually.

## 4. Execution mechanics: Fast and isolated

* Supabase Edge Functions
  * restrictions
    * ⚠️ONLY support⚠️
      * creating functions | ".ts"
  * 💡are -- , through [Deno runtime](https://deno.com/), -- executed💡
    * Reason:🧠Deno's design
      * enable
        * extensibility
        * -- thanks to its Rust codebase --
          * modern developer experience
          * memory safety
          * ...
      * prioritizes
        * speed
        * isolation
        * scalability🧠
  * 's 
    * **Request Handling**
      1. TODO:A client sends an HTTP request (e.g., POST) to the function's URL, including parameters like auth headers, image ID, and filter type.
      2. The global API gateway routes it to the nearest edge location.
      3. At the edge, Supabase's **edge runtime** validates the request (e.g., checks authorization)
    * **Execution Environment**
      * new **V8 isolate** is spun up for each invocation. V8 is the JavaScript engine used by Chrome and Node.js, providing a lightweight, 
  sandboxed environment
      * Each isolate has its own memory heap and execution thread, ensuring complete isolation—no interference between concurrent requests.
      * The ESZip bundle is loaded into the isolate, and the function code runs.
      * After execution, the response (e.g., filtered image path) is sent back to the client
    * **Performance Optimizations**
      * **Cold Starts**
        * Even initial executions are fast (milliseconds) due to the compact ESZip format and minimal Deno runtime overhead.
      * **Warm Starts**
        * Isolates can remain active for a period (plan-dependent) to handle subsequent requests without restarting.
      * **Concurrency**
        * Multiple isolates can run simultaneously in the same edge location, supporting high traffic
    * **Isolation and Security**
      * Isolates prevent side effects from one function affecting others, enhancing reliability
      * No persistent state; each run is stateless, ideal for ephemeral tasks.
  * vs TRADITIONAL serverless OR monolithic architectures
    * provides
      * lower latency
      * automatic scaling
      * NO infrastructure management
