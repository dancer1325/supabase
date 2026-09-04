import {
    Webhook
} from "https://esm.sh/standardwebhooks@1.0.0";
import {
    readAll
} from "https://deno.land/std/io/read_all.ts";

const postmarkEndpoint = 'https://api.postmarkapp.com/email';
const sendGridEndpoint = 'https://api.sendgrid.com/v3/mail/send';
const FROM_EMAIL = 'myemail@gmail.com'

// Email Subjects
const subjects = {
    signup: 'Confirm your email address',
    recovery: 'Reset your password',
    invite: "You've been invited",
    magiclink: 'Your sign-in link',
    email_change: 'Confirm your new email address',
    email_change_new: 'Confirm your new email address',
    reauthentication: '{{token}} is your verification code'
};

// HTML Body
const templates = {
    signup: `<h2>Confirm your email address</h2><p>Follow the link below to confirm this email address and finish signing up.</p><p><a href="{{confirmation_url}}">Confirm email address</a></p>`,
    recovery: `<h2>Reset your password</h2><p>We received a request to reset your password. Follow the link below to choose a new one.</p><p><a href="{{confirmation_url}}">Reset password</a></p><p>If you didn't request this, you can safely ignore this email.</p>`,
    invite: `<h2>You've been invited</h2><p>You've been invited to create an account. Follow the link below to accept.</p><p><a href="{{confirmation_url}}">Accept invitation</a></p>`,
    magiclink: `<h2>Your sign-in link</h2><p>Follow the link below to sign in. This link expires shortly and can only be used once.</p><p><a href="{{confirmation_url}}">Sign in</a></p>`,
    email_change: `<h2>Confirm your new email address</h2><p>Follow the link below to confirm {{new_email}} as your new email address.</p><p><a href="{{confirmation_url}}">Confirm new email address</a></p><p>If you didn't request this change, you can safely ignore this email.</p>`,
    email_change_new: `<h2>Confirm your new email address</h2><p>Follow the link below to confirm {{new_email}} as your new email address.</p><p><a href="{{confirmation_url}}">Confirm new email address</a></p><p>If you didn't request this change, you can safely ignore this email.</p>`,
    reauthentication: `<h2>Your verification code</h2><p>Use the code below to verify your identity. It expires shortly.</p><p>{{token}}</p>`
};

function generateConfirmationURL(email_data) {
    // TODO: replace the ref with your project ref
    return `https://<ref>.supabase.co/auth/v1/verify?token=${email_data.token_hash}&type=${email_data.email_action_type}&redirect_to=${email_data.redirect_to}`
}

async function sendEmailWithPostmark(user: any, email_data: any, serverToken: string): Promise<Response> {
    const subject = subjects[email_data.email_action_type] || 'Notification';
    const confirmation_url = generateConfirmationURL(email_data)
    let template = templates[email_data.email_action_type];
    let htmlBody = template.replace('{{confirmation_url}}', confirmation_url)
        .replace('{{token}}', email_data.token || '')
        .replace('{{new_token}}', email_data.new_token || '')
        .replace('{{site_url}}', email_data.site_url || '')
        .replace('{{old_email}}', email_data.old_email || '')
        .replace('{{new_email}}', user.new_email || '');

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-Postmark-Server-Token': serverToken
        },
        body: JSON.stringify({
            From: FROM_EMAIL,
            To: user.email,
            Subject: subject,
            HtmlBody: htmlBody
        })
    };

    return await fetch(postmarkEndpoint, requestOptions);
}

async function sendEmailWithSendGrid(user: any, email_data: any, apiKey: string): Promise<Response> {
    const subject = subjects[email_data.email_action_type] || 'Notification';
    let template = templates[email_data.email_action_type];
    cont confirmation_url = generateConfirmationURL(email_data)
    let htmlBody = template.replace('{{confirmation_url}}', confirmation_url)
        .replace('{{token}}', email_data.token || '')
        .replace('{{new_token}}', email_data.new_token || '')
        .replace('{{site_url}}', email_data.site_url || '')
        .replace('{{old_email}}', email_data.old_email || '')
        .replace('{{new_email}}', user.new_email || '');

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
            personalizations: [{
                to: [{
                    email: user.email
                }],
                subject: subject
            }],
            from: {
                email: FROM_EMAIL
            },
            content: [{
                type: "text/html",
                value: htmlBody
            }]
        })
    };

    return await fetch(sendGridEndpoint, requestOptions);
}

Deno.serve(async (req) => {
    const payload = await req.text();
    const postmarkServerToken = Deno.env.get("POSTMARK_SERVER_TOKEN");
    const sendGridApiKey = Deno.env.get("SENDGRID_API_KEY");
    const headers = Object.fromEntries(req.headers);
    const base64_secret = Deno.env.get('SEND_EMAIL_HOOK_SECRET').replace('v1,whsec_', '');
    const wh = new Webhook(base64_secret);
    const {
        user,
        email_data
    } = wh.verify(payload, headers);

    try {
        // Try sending email using Postmark
        let response = await sendEmailWithPostmark(user, email_data, postmarkServerToken!);

        if (!response.ok) {
            // If Postmark fails, try SendGrid
            console.error(`Primary email send failed: ${await response.text()}`);
            response = await sendEmailWithSendGrid(user, email_data, sendGridApiKey!);

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(`Failed to send email via backup: ${errorData.errors[0].message}`);
            }
        }

        return new Response(JSON.stringify({
            message: "Email sent successfully."
        }), {
            headers: {
                "Content-Type": "application/json"
            }
        });
    } catch (error) {
        return new Response(JSON.stringify({
            error: `Failed to process the request: ${error.message}`
        }), {
            status: 500,
            headers: {
                "Content-Type": "application/json"
            }
        });
    }
});