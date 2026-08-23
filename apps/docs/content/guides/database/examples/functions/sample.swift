// 1. execute basic function
try await supabase.rpc("hello_world").execute()

// 2. apply filter & selectors
let response = try await supabase.rpc("get_planets").eq("id", value: 1).execute()

// 3. passing parameters
//  3.1 using Encodable type
struct Planet: Encodable {
  let name: String
}

try await supabase.rpc(
  "add_planet",
  params: Planet(name: "Jakku")
)
.execute()

//  3.2using AnyJSON convenience type
try await supabase.rpc(
  "add_planet",
  params: ["name": AnyJSON.string("Jakku")]
)
.execute()