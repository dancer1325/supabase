const { data, error } = await supabase.auth.signUp({
    email: 'valid.email@supabase.io',
    password: 'example-password',
    options: {
        data: {
            first_name: 'John',
            age: 27,
        },
    },
})

const {
    data: { user },
} = await supabase.auth.getUser()
let metadata = user?.user_metadata