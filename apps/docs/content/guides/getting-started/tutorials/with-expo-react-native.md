---
title: 'Build a User Management App with Expo React Native'
description: 'Learn how to use Supabase in your React Native App.'
tocVideo: 'AE7dKIKMJy4'
---

* [introduction](../../../_partials/quickstart_intro.md)

![Supabase User Management example](../../../../public/img/supabase-expo-react-native-demo.png)

* _Example:_ [here](../../../../../../examples/user-management/expo-user-management)

* [project setup](../../../_partials/project_setup.md)

TODO: move ALL to the example?

## how has it been created?

### Initialize a React Native app

```bash
npx create-expo-app -t expo-template-blank-typescript expo-user-management

cd expo-user-management

npx expo install @supabase/supabase-js @react-native-async-storage/async-storage
```

* ways to store user session
  * [LocalStorage](lib/supabaseLocalStorage.ts)
    * initialize the Supabase client -- by using -- API URL + API key
      * safe to expose -- thanks to -- enable [Row Level Security](../../database/postgres/row-level-security) | your Database  
  * [SecureStore](lib/supabaseLargeSecureStore.ts)
    * 's goal
      * encrypt the user's session information
    * 's approach
      * use 
        * [aes-js](https://github.com/ricmoo/aes-js)
          * == JS-only implementation of AES  encryption algorithm / CTR mode
        * [react-native-get-random-values](https://www.npmjs.com/package/react-native-get-random-values)
          * generate 256-bit encryption key
      * store the 
        * encryption key | [Expo SecureStore](https://docs.expo.dev/versions/latest/sdk/securestore)
          * choose the [`SecureStoreOptions`](https://docs.expo.dev/versions/latest/sdk/securestore/#securestoreoptions) -- based on -- your app's needs
        * encrypted value | AsyncStorage
    * requirements

      ```bash
      npm install @supabase/supabase-js
      npm install @react-native-async-storage/async-storage
      npm install aes-js react-native-get-random-values
      npm install --save-dev @types/aes-js
      npx expo install expo-secure-store
      ```

### Set up a login component

TODO: 

<Admonition type="note">

By default Supabase Auth requires email verification before a session is created for the users
To support email verification you need to [implement deep link handling](/docs/guides/auth/native-mobile-deep-linking?platform=react-native)!

While testing, you can disable email confirmation in your [project's email auth provider settings](/dashboard/project/_/auth/providers).

</Admonition>

### Account page

After a user signs in, let them edit their profile details and manage their account.

Create a new component for that called `Account.tsx`.

<$CodeSample
path="/user-management/expo-user-management/components/Account.tsx"
lines={[[1, 4], [6, 79], [90, -1]]}
meta="name=components/Account.tsx"
/>

### Launch!

Now that you have all the components in place, update `App.tsx`:

<$CodeSample
path="/user-management/expo-user-management/App.tsx"
lines={[[1, -1]]}
meta="name=App.tsx"
/>

Once that's done, run this in a terminal window:

```bash
npm start
```

And then press the appropriate key for the environment you want to test the app in and you should see the completed app.

## Bonus: Profile photos

Every Supabase project is configured with [Storage](/docs/guides/storage) for managing large files like
photos and videos.

### Additional dependency installation

You need an image picker that works on the environment you are building the project for, this example uses `expo-image-picker`.

```bash
npx expo install expo-image-picker
```

### Create an upload widget

Create an avatar for the user so that they can upload a profile photo.
Start by creating a new component:

<$CodeSample
path="/user-management/expo-user-management/components/Avatar.tsx"
lines={[[1, -1]]}
meta="name=components/Avatar.tsx"
/>

### Add the new widget

And then add the widget to the Account page:

<$CodeSample
path="/user-management/expo-user-management/components/Account.tsx"
lines={[[1, -1]]}
meta="name=components/Account.tsx"
/>

Now run the prebuild command to get the application working on your chosen platform.

```bash
npx expo prebuild
```

At this stage you have a fully functional application!
