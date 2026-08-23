// 1. execute basic function
val data = supabase.postgrest.rpc("hello_world")

// 2. apply filter & selectors
val data = supabase.postgrest.rpc("get_planets") {
    filter {
        eq("id", 1)
    }
}

// 3. passing parameters
val data = supabase.postgrest.rpc(
    function = "add_planet",
    parameters = buildJsonObject { //You can put here any serializable object including your own classes
        put("name", "Jakku")
    }
)