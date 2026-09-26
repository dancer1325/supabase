---
title: 'Native Mobile Deep Linking'
subtitle: 'Set up Deep Linking for mobile applications.'
tocVideo: '8TZ6O1C8ujE'
---

* goal: configurar Deep Linking para que los redirects de Auth (email confirmation, magic link, password reset, OAuth) abran una página específica de la app

* Auth methods -- involve --> redirect to app
  * Signup confirmation emails, Magic Link signins, password reset emails -> link that redirects to app
  * OAuth signins -> automatic redirect to app
* Deep Linking -> configure redirect to open a specific page
  * 🧠 necessary if: need to display password reset form | app, or manually exchange a token hash
  * [password reset](/docs/guides/auth/passwords#resetting-a-users-password-forgot-password)

## Setting up deep linking

### Expo React Native

* register custom URL scheme | `app.json` / `app.config.js` -- under `scheme` key

```json
{
  "expo": {
    "scheme": "com.supabase"
  }
}
```

* add redirect URL | [auth settings](/dashboard/project/_/auth/url-configuration) -- e.g. `com.supabase://**`
* implement OAuth and linking handlers
  * [supabase-js reference](/docs/reference/javascript/initializing?example=react-native-options-async-storage) -- for initializing client | React Native

```tsx ./components/Auth.tsx
import { Button } from "react-native";
import { makeRedirectUri } from "expo-auth-session";
import * as QueryParams from "expo-auth-session/build/QueryParams";
import * as WebBrowser from "expo-web-browser";
import * as Linking from "expo-linking";
import { supabase } from "app/utils/supabase";

WebBrowser.maybeCompleteAuthSession(); // required for web only
const redirectTo = makeRedirectUri();

const createSessionFromUrl = async (url: string) => {
  const { params, errorCode } = QueryParams.getQueryParams(url);

  if (errorCode) throw new Error(errorCode);
  const { access_token, refresh_token } = params;

  if (!access_token) return;

  const { data, error } = await supabase.auth.setSession({
    access_token,
    refresh_token,
  });
  if (error) throw error;
  return data.session;
};

const performOAuth = async () => {
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "github",
    options: {
      redirectTo,
      skipBrowserRedirect: true,
    },
  });
  if (error) throw error;

  const res = await WebBrowser.openAuthSessionAsync(
    data?.url ?? "",
    redirectTo
  );

  if (res.type === "success") {
    const { url } = res;
    await createSessionFromUrl(url);
  }
};

const sendMagicLink = async () => {
  const { error } = await supabase.auth.signInWithOtp({
    email: "valid.email@supabase.io",
    options: {
      emailRedirectTo: redirectTo,
    },
  });

  if (error) throw error;
  // Email sent.
};

export default function Auth() {
  // Handle linking into app from email app.
  const url = Linking.useLinkingURL();
  if (url) createSessionFromUrl(url);

  return (
    <>
      <Button onPress={performOAuth} title="Sign in with GitHub" />
      <Button onPress={sendMagicLink} title="Send Magic Link" />
    </>
  );
}
```

* 👀 best UX -> use universal links (more elaborate setup)
  * [Expo docs deep linking](https://docs.expo.dev/guides/deep-linking/)

---

### Flutter

* supabase_flutter supports deep links | Android, iOS, Web, macOS, Windows

#### Deep link config

* go to [auth settings](/dashboard/project/_/auth/url-configuration)
* add app redirect callback | `Additional Redirect URLs` field
  * format: `[YOUR_SCHEME]://[YOUR_HOSTNAME]`
  * e.g. `io.supabase.flutterquickstart://login-callback`
  * 🧠 scheme must be unique across device -> use reverse domain of website

#### Platform specific config — Android

```xml
<manifest ...>
  <!-- ... other tags -->
  <application ...>
    <activity ...>
      <!-- ... other tags -->

      <!-- Deep Links -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with YOUR_SCHEME://YOUR_HOST -->
        <data
          android:scheme="YOUR_SCHEME"
          android:host="YOUR_HOSTNAME" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

* ⚠️ `android:host` attribute is optional for Deep Links
* [Android deep linking docs](https://developer.android.com/training/app-links/deep-linking)

#### Platform specific config — iOS

* declare scheme | `ios/Runner/Info.plist` (or Xcode Target Info editor, under URL Types)

```xml
<!-- ... other tags -->
<plist>
<dict>
  <!-- ... other tags -->
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>[YOUR_SCHEME]</string>
      </array>
    </dict>
  </array>
  <!-- ... other tags -->
</dict>
</plist>
```

* [Apple URL scheme docs](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app)

#### Platform specific config — Windows

* more steps than other platforms
* [Learn more](https://pub.dev/packages/app_links#windows)

Declare in `<PROJECT_DIR>\windows\runner\win32_window.h`:

```cpp
// Dispatches link if any.
// This method enables our app to be with a single instance too.
// This is optional but mandatory if you want to catch further links in same app.
bool SendAppLinkToInstance(const std::wstring& title);
```

Add inclusion at top of `<PROJECT_DIR>\windows\runner\win32_window.cpp`:

```cpp
#include "app_links_windows/app_links_windows_plugin.h"
```

Add method in `<PROJECT_DIR>\windows\runner\win32_window.cpp`:

```cpp
bool Win32Window::SendAppLinkToInstance(const std::wstring& title) {
  // Find our exact window
  HWND hwnd = ::FindWindow(kWindowClassName, title.c_str());

  if (hwnd) {
    // Dispatch new link to current window
    SendAppLink(hwnd);

    // (Optional) Restore our window to front in same state
    WINDOWPLACEMENT place = { sizeof(WINDOWPLACEMENT) };
    GetWindowPlacement(hwnd, &place);
    switch(place.showCmd) {
      case SW_SHOWMAXIMIZED:
          ShowWindow(hwnd, SW_SHOWMAXIMIZED);
          break;
      case SW_SHOWMINIMIZED:
          ShowWindow(hwnd, SW_RESTORE);
          break;
      default:
          ShowWindow(hwnd, SW_NORMAL);
          break;
    }
    SetWindowPos(0, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW | SWP_NOSIZE | SWP_NOMOVE);
    SetForegroundWindow(hwnd);
    // END Restore

    // Window has been found, don't create another one.
    return true;
  }

  return false;
}
```

Add call to `SendAppLinkToInstance` in `CreateAndShow`:

```cpp
bool Win32Window::CreateAndShow(const std::wstring& title,
                                const Point& origin,
                                const Size& size) {
if (SendAppLinkToInstance(title)) {
    return false;
}

...
```

* register scheme | Windows registry -- this package ❌ does it for you
  * use [url_protocol](https://pub.dev/packages/url_protocol) | app
  * 👀 best solution: include registry modifications in installer -> allows deregistration

#### Platform specific config — macOS

Add XML | `macos/Runner/Info.plist` inside `<plist version="1.0"><dict>`:

```xml
<!-- ... other tags -->
<plist version="1.0">
<dict>
  <!-- ... other tags -->
  <key>CFBundleURLTypes</key>
  <array>
      <dict>
          <key>CFBundleURLName</key>
          <!-- abstract name for this URL type (you can leave it blank) -->
          <string>sample_name</string>
          <key>CFBundleURLSchemes</key>
          <array>
              <!-- your schemes -->
              <string>sample</string>
          </array>
      </dict>
  </array>
  <!-- ... other tags -->
</dict>
</plist>
```

---

### Swift

#### Deep link config

1. go to [auth settings](/dashboard/project/_/auth/url-configuration)
2. enter app redirect URL | `Additional Redirect URLs` field
   * format: `[YOUR_SCHEME]://[YOUR_HOSTNAME]`
   * e.g. `io.supabase.user-management://login-callback`
   * 🧠 scheme must be unique across device -> typically reverse domain of website

* add custom URL to app -> OS knows how to redirect back after user clicks magic link
* option A: Xcode Target Info Editor -- [official Apple docs](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app#Register-your-URL-scheme)
* option B: declare manually | `Info.plist`

```xml Info.plist
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <!-- other tags -->
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>io.supabase.user-management</string>
        </array>
      </dict>
    </array>
  </dict>
  </plist>
```

---

### Android Kotlin

#### Deep link config

1. go to [auth settings](/dashboard/project/_/auth/url-configuration)
2. enter app redirect URL | `Additional Redirect URLs` field
   * format: `[YOUR_SCHEME]://[YOUR_HOSTNAME]`
   * e.g. `io.supabase.user-management://login-callback`
   * 🧠 scheme must be unique across device -> typically reverse domain of website

* edit Android manifest -> app opens when user clicks magic link

```xml
<manifest ...>
  <!-- ... other tags -->
  <application ...>
    <activity ...>
      <!-- ... other tags -->

      <!-- Deep Links -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with YOUR_SCHEME://YOUR_HOST -->
        <data
          android:scheme="YOUR_SCHEME"
          android:host="YOUR_HOSTNAME" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

* [Android deep linking docs](https://developer.android.com/training/app-links/deep-linking)

* specify scheme and host | Supabase Client

```kotlin
install(Auth) {
   host = "login-callback"
   scheme = "io.supabase.user-management"
}
```

* call `Auth#handleDeeplinks` when app opens

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    supabase.handleDeeplinks(intent)
}
```

* -> user authenticated when app receives valid deep link
