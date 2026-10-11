* ways to configure SMS Authentication | Twilio
  * [Twilio Verify](#how-to-set-up-twilio-verify)
  * [Twilio Programmable Messaging](#how-to-set-up-twilio-programmable-messaging)

## Prerequisites

* [Twilio account](https://www.twilio.com/try-twilio)
* Supabase project
* Mobile phone / can receive SMS

## how to set up Twilio Verify?

* [Twilio Verify](https://www.twilio.com/en-us/trusted-activation/verify) 
  * == specialized OTP solution / 
    * Twilio generates the OTPs
      * ❌!= [REST of providers](../)❌
      * have a validity period
        * [Rate Limit & Timeouts](https://www.twilio.com/docs/verify/api/rate-limits-and-timeouts)
  * use cases
    * over-the-phone authentication
  * SUPPORTED channels
    * `whatsapp`
    * `sms`

* steps
  1. | Twilio dashboard, 
     * create a new [verification service](https://help.twilio.com/articles/360033309133-Getting-Started-with-Twilio-Verify-V2) 
  2. | Supabase Dashboard, 
     * \> choose a project > auth > providers
  3. configure the Twilio Verify Service ID

## how to set up Twilio Programmable Messaging?

* goal
  * set up Twilio -- as -- an SMS provider

* Twilio Programmable Messaging
  * [documentation](https://www.twilio.com/docs/messaging)
  * provides
    * generic SMS sending support

* [video](https://www.youtube-nocookie.com/embed/akScoPO01bc)

### Setting up your Twilio credentials

TODO: 
Start by logging into your Twilio account and starting a new project: https://www.twilio.com/console/projects/create

Give your project a name and verify the mobile number you'll be using to test with
* This is the number that will be receiving the SMS OTPs.

![Name your twilio project](/docs/img/guides/auth-twilio/1.png)
![verify your own phone number](/docs/img/guides/auth-twilio/2.png)

Select 'SMS', 'Identity & Verification', and 'With code' as options on the welcome form.

![Form Fields](/docs/img/guides/auth-twilio/3.png)

When you're back on the [Twilio console screen](https://www.twilio.com/console), you need to scroll down and click 'Get a trial phone number' - this is the number that you'll be sending SMSs from.

![Get a trial phone number](/docs/img/guides/auth-twilio/4.png)

![Successful phone number](/docs/img/guides/auth-twilio/5.png)

You should now be able to see all three values you'll need to get started:

- Account SID
- Auth Token
- Sender Phone Number

![All the credentials you'll need](/docs/img/guides/auth-twilio/6.png)

Now go to the [Auth > Providers](https://supabase.com/dashboard/project/_/auth/providers) page in the Supabase dashboard and select "Phone" from the Auth Providers list.

You should see an option to enable the Phone provider.

Toggle it on, and copy the 3 values over from the Twilio dashboard
* Click save.

Note: for "Twilio Message Service SID" you can use the Sender Phone Number generated above.

![Plug in Twilio credentials](/docs/img/guides/auth-twilio/8.png)

Now the backend should be setup, we can proceed to add our client-side code!

<Admonition type="note">
  The `Twilio Content SID` field is specific to Twilio Programmable Messaging (WhatsApp) senders.
  Disregard this field if you are only sending SMS messages
* Refer to the section on WhatsApp OTP
  Logins for further details.
</Admonition>

#### SMS custom template

The SMS message sent to a phone containing an OTP code can be customized
* This is useful if you need to mention a brand name or display a website address.

Go to the [Auth > Providers](https://supabase.com/dashboard/project/_/auth/providers) page in the Supabase dashboard and select "Phone" from the Auth Providers list
* Scroll to the very bottom of the "Phone" section to the "SMS Message" input - you can customize the SMS message here.

Use the variable `.Code` in the template to display the OTP code
* Here's an example in the SMS template.

![example in the SMS template](/docs/img/guides/auth-twilio/9.png)

## WhatsApp OTP logins

* goal
  * use WhatsApp -- as -- a delivery channel

* Here are some examples our users have cited:

- You want higher deliverability
- You wish for a secure channel
- Your users mostly use WhatsApp as a messaging platform

Twilio Verify can be used with WhatsApp OTPs with no additional configuration.

Complete the following steps to use WhatsApp OTP with Twilio Programmable Messaging:

1. Go through the [Twilio self sign up guide for WhatsApp](https://www.twilio.com/docs/whatsapp/self-sign-up).
2. Register a Twilio Content Template via the [API](https://www.twilio.com/docs/content/whatsappauthentication) and note the corresponding Twilio Content SID. You can also use the Template Builder on the Twilio dashboard to create a Content Template
   ![Twilio Content SID Image](/docs/img/guides/auth-twilio/twilio_content_sid.png)
3. Register the Twilio Content SID on the Supabase dashboard under Authentication > Providers > Phone > Twilio Content SID. Ensure you have Twilio selected as your phone provider.

<Admonition>

You may only use one Twilio Content SID at a time. Supabase Auth will use the Content Template over the `SMS Message` field when sending WhatsApp messages. Use Twilio Verify if you need to use more than one message template.

</Admonition>
