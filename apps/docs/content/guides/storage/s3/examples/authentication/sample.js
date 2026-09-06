import { S3Client } from '@aws-sdk/client-s3'

const {
    data: { session },
} = await supabase.auth.getSession()

const client = new S3Client({
    forcePathStyle: true,
    region: 'project_region',
    endpoint: 'https://project_ref.storage.supabase.co/storage/v1/s3',
    credentials: {
        accessKeyId: 'project_ref',
        secretAccessKey: 'anonKey',
        sessionToken: session.access_token,
    },
})