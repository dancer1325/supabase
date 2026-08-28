try await supabase.storage.createBucket(
  "avatars",
  options: BucketOptions(public: true)
)