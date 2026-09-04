import { readAll } from 'https://deno.land/std/io/read_all.ts'
import { Webhook } from 'https://esm.sh/standardwebhooks@1.0.0'

const postmarkEndpoint = 'https://api.postmarkapp.com/email'
// Replace this with your email
const FROM_EMAIL = 'myemail@gmail.com'
const PROJECT_REF = '<your-project-ref>'

// Email Subjects
const subjects = {
    en: {
        signup: 'Confirm your email address',
        recovery: 'Reset your password',
        invite: "You've been invited",
        magiclink: 'Your sign-in link',
        email_change: 'Confirm your new email address',
        email_change_new: 'Confirm your new email address',
        reauthentication: '{{token}} is your verification code',
    },
    es: {
        signup: 'Confirma tu correo electrónico',
        recovery: 'Restablece tu contraseña',
        invite: 'Has sido invitado',
        magiclink: 'Tu enlace de inicio de sesión',
        email_change: 'Confirma tu nueva dirección de correo electrónico',
        email_change_new: 'Confirma tu nueva dirección de correo electrónico',
        reauthentication: '{{token}} es tu código de verificación',
    },
    fr: {
        signup: 'Confirmez votre adresse e-mail',
        recovery: 'Réinitialisez votre mot de passe',
        invite: 'Vous avez été invité',
        magiclink: 'Votre lien de connexion',
        email_change: 'Confirmez votre nouvelle adresse e-mail',
        email_change_new: 'Confirmez la nouvelle adresse e-mail',
        reauthentication: '{{token}} est votre code de vérification',
    },
}

// HTML Body
const templates = {
    en: {
        signup: `<h2>Confirm your email address</h2><p>Follow the link below to confirm this email address and finish signing up.</p><p><a href="{{confirmation_url}}">Confirm email address</a></p>`,
        recovery: `<h2>Reset your password</h2><p>We received a request to reset your password. Follow the link below to choose a new one.</p><p><a href="{{confirmation_url}}">Reset password</a></p><p>If you didn't request this, you can safely ignore this email.</p>`,
        invite: `<h2>You've been invited</h2><p>You've been invited to create an account. Follow the link below to accept.</p><p><a href="{{confirmation_url}}">Accept invitation</a></p>`,
        magiclink: `<h2>Your sign-in link</h2><p>Follow the link below to sign in. This link expires shortly and can only be used once.</p><p><a href="{{confirmation_url}}">Sign in</a></p>`,
        email_change: `<h2>Confirm your new email address</h2><p>Follow the link below to confirm {{new_email}} as your new email address.</p><p><a href="{{confirmation_url}}">Confirm new email address</a></p><p>If you didn't request this change, you can safely ignore this email.</p>`,
        email_change_new: `<h2>Confirm your new email address</h2><p>Follow the link below to confirm {{new_email}} as your new email address.</p><p><a href="{{confirmation_url}}">Confirm new email address</a></p><p>If you didn't request this change, you can safely ignore this email.</p>`,
        reauthentication: `<h2>Your verification code</h2><p>Use the code below to verify your identity. It expires shortly.</p><p>{{token}}</p>`,
    },
    es: {
        signup: `<h2>Confirma tu dirección de correo electrónico</h2><p>Sigue el enlace de abajo para confirmar esta dirección de correo electrónico y terminar el registro.</p><p><a href="{{confirmation_url}}">Confirmar dirección de correo electrónico</a></p>`,
        recovery: `<h2>Restablece tu contraseña</h2><p>Recibimos una solicitud para restablecer tu contraseña. Sigue el enlace de abajo para elegir una nueva.</p><p><a href="{{confirmation_url}}">Restablecer contraseña</a></p><p>Si no solicitaste esto, puedes ignorar este correo.</p>`,
        invite: `<h2>Has sido invitado</h2><p>Te han invitado a crear una cuenta. Sigue el enlace de abajo para aceptar.</p><p><a href="{{confirmation_url}}">Aceptar invitación</a></p>`,
        magiclink: `<h2>Tu enlace de inicio de sesión</h2><p>Sigue el enlace de abajo para iniciar sesión. Este enlace caduca pronto y solo se puede usar una vez.</p><p><a href="{{confirmation_url}}">Iniciar sesión</a></p>`,
        email_change: `<h2>Confirma tu nueva dirección de correo electrónico</h2><p>Sigue el enlace de abajo para confirmar {{new_email}} como tu nueva dirección de correo electrónico.</p><p><a href="{{confirmation_url}}">Confirmar nueva dirección de correo electrónico</a></p><p>Si no solicitaste este cambio, puedes ignorar este correo.</p>`,
        email_change_new: `<h2>Confirma tu nueva dirección de correo electrónico</h2><p>Sigue el enlace de abajo para confirmar {{new_email}} como tu nueva dirección de correo electrónico.</p><p><a href="{{confirmation_url}}">Confirmar nueva dirección de correo electrónico</a></p><p>Si no solicitaste este cambio, puedes ignorar este correo.</p>`,
        reauthentication: `<h2>Tu código de verificación</h2><p>Usa el código de abajo para verificar tu identidad. Caduca pronto.</p><p>{{token}}</p>`,
    },
    fr: {
        signup: `<h2>Confirmez votre adresse e-mail</h2><p>Suivez le lien ci-dessous pour confirmer cette adresse e-mail et terminer votre inscription.</p><p><a href="{{confirmation_url}}">Confirmer l'adresse e-mail</a></p>`,
        recovery: `<h2>Réinitialisez votre mot de passe</h2><p>Nous avons reçu une demande de réinitialisation de votre mot de passe. Suivez le lien ci-dessous pour en choisir un nouveau.</p><p><a href="{{confirmation_url}}">Réinitialiser le mot de passe</a></p><p>Si vous n'avez pas fait cette demande, vous pouvez ignorer cet e-mail.</p>`,
        invite: `<h2>Vous avez été invité</h2><p>Vous avez été invité à créer un compte. Suivez le lien ci-dessous pour accepter.</p><p><a href="{{confirmation_url}}">Accepter l'invitation</a></p>`,
        magiclink: `<h2>Votre lien de connexion</h2><p>Suivez le lien ci-dessous pour vous connecter. Ce lien expire bientôt et ne peut être utilisé qu'une seule fois.</p><p><a href="{{confirmation_url}}">Se connecter</a></p>`,
        email_change: `<h2>Confirmez votre nouvelle adresse e-mail</h2><p>Suivez le lien ci-dessous pour confirmer {{new_email}} comme nouvelle adresse e-mail.</p><p><a href="{{confirmation_url}}">Confirmer la nouvelle adresse e-mail</a></p><p>Si vous n'avez pas demandé ce changement, vous pouvez ignorer cet e-mail.</p>`,
        email_change_new: `<h2>Confirmez votre nouvelle adresse e-mail</h2><p>Suivez le lien ci-dessous pour confirmer {{new_email}} comme nouvelle adresse e-mail.</p><p><a href="{{confirmation_url}}">Confirmer la nouvelle adresse e-mail</a></p><p>Si vous n'avez pas demandé ce changement, vous pouvez ignorer cet e-mail.</p>`,
        reauthentication: `<h2>Votre code de vérification</h2><p>Utilisez le code ci-dessous pour vérifier votre identité. Il expire bientôt.</p><p>{{token}}</p>`,
    },
}

function generateConfirmationURL(email_data) {
    const baseUrl = `https://${PROJECT_REF}.supabase.co/auth/v1/verify`
    const params = new URLSearchParams({
        token: email_data.token_hash,
        type: email_data.email_action_type,
        redirect_to: email_data.redirect_to,
    })

    return `${baseUrl}?${params.toString()}`
}

Deno.serve(async (req) => {
    const payload = await req.text()
    const serverToken = Deno.env.get('POSTMARK_SERVER_TOKEN')
    const headers = Object.fromEntries(req.headers)
    const base64_secret = Deno.env.get('SEND_EMAIL_HOOK_SECRET').replace('v1,whsec_', '')
    const wh = new Webhook(base64_secret)
    const { user, email_data } = wh.verify(payload, headers)

    const language = (user.user_metadata && user.user_metadata.i18n) || 'en'
    const subject = subjects[language][email_data.email_action_type] || 'Notification'

    let template = templates[language][email_data.email_action_type]
    const confirmation_url = generateConfirmationURL(email_data)
    let htmlBody = template
        .replace('{{confirmation_url}}', confirmation_url)
        .replace('{{token}}', email_data.token || '')
        .replace('{{new_token}}', email_data.new_token || '')
        .replace('{{site_url}}', email_data.site_url || '')
        .replace('{{old_email}}', email_data.old_email || '')
        .replace('{{new_email}}', user.new_email || '')

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-Postmark-Server-Token': serverToken,
        },
        body: JSON.stringify({
            From: FROM_EMAIL,
            To: user.email,
            Subject: subject,
            HtmlBody: htmlBody,
        }),
    }

    try {
        const response = await fetch(postmarkEndpoint, requestOptions)
        if (!response.ok) {
            const errorData = await response.json()
            throw new Error(`Failed to send email: ${errorData.Message}`)
        }
        return new Response(
            JSON.stringify({
                message: 'Email sent successfully.',
            }),
            {
                headers: {
                    'Content-Type': 'application/json',
                },
            }
        )
    } catch (error) {
        return new Response(
            JSON.stringify({
                error: `Failed to process the request: ${error.message}`,
            }),
            {
                status: 500,
                headers: {
                    'Content-Type': 'application/json',
                },
            }
        )
    }
})