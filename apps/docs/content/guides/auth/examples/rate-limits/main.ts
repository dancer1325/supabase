import { createServerClient } from '@supabase/ssr'

const supabase = createServerClient(
    'https://<your-project-id>.supabase.co',
    '<your-secret-key>', // Key should start with sb_secret
    {
        global: {
            headers: {
                'sb-forwarded-for': request.headers.get('x-forwarded-for'),
            },
        },
    }
)