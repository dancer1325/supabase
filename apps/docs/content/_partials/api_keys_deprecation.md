* Supabase 
  * ⚠️[changed the way / keys work](https://github.com/orgs/supabase/discussions/29260)⚠️ 
    * Reason: 🧠improve
      * project security
      * developer experience🧠
  * `anon` & `service_role` types
    * | end of 2026,
      * they will be deprecated
    * replace by `sb_publishable_xxx` & `sb_secret_xxx`
      * ways to find them
        * | Supabase Dashboard > Choose project > 
          * Connect dialog
            * url: https://supabase.com/dashboard/project/<PROJECT_KEY>?showConnect=true
          * \> Settings > API keys
