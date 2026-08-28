//  1. create a bucket
try await supabase.storage.createBucket("avatars")

// 2. download a file
let response = try await supabase.storage.from("avatars").download(path: "public/avatar1.png")