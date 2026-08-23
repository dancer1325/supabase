---
title: 'Use Supabase with Expo React Native'
subtitle: 'Learn how to create a Supabase project, add some sample data to your database, and query the data from an Expo app.'
breadcrumb: 'Framework Quickstarts'
---

* [set up db](../../../_partials/quickstart_db_setup.md)

## 3. create a minimal Expo app

```bash
npx create-expo-app my-app --template blank-typescript
```

## 4. install Supabase's Agent Skills -- OPTIONAL --

* [here](../../ai-tools/ai-skills)

## 5. install the Supabase client library -- "@supabase/supabase-js" --

* steps
  * | your project path
    ```bash
    # react-native-url-polyfill
    #   allows
    #     URL handling
    # expo-sqlite
    #   allows
    #     session storage
    npx expo install @supabase/supabase-js react-native-url-polyfill expo-sqlite
    ```

## 6. Declare Supabase environment variables

* steps
  * Supabase Dashboard > | "Get connected" panel, click in "Framework" > Framework = Expo React Native
    * copy them
  * | your project's root path

    ```.env
    EXPO_PUBLIC_SUPABASE_URL=<SUBSTITUTE_SUPABASE_URL>
    EXPO_PUBLIC_SUPABASE_KEY=<SUBSTITUTE_SUPABASE_PUBLISHABLE_KEY>
    ```
  * [get API details](../../../_partials/api_settings.md)

## 7. Initialize the Supabase client

```ts name=lib/supabase.ts
// persist authentication sessions
import 'react-native-url-polyfill/auto'
import { createClient } from '@supabase/supabase-js'
import 'expo-sqlite/localStorage/install'

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL
const supabasePublishableKey = process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY

export const supabase = createClient(supabaseUrl, supabasePublishableKey, {
  auth: {
    storage: localStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
})
```

## 8. | your app, query data

```tsx name=App.tsx
import { useEffect, useState } from 'react'
import { FlatList, StyleSheet, Text, View } from 'react-native'

import { supabase } from './lib/supabase'

export default function App() {
  const [instruments, setInstruments] = useState([])

  useEffect(() => {
    getInstruments()
  }, [])

  async function getInstruments() {
    const { data } = await supabase.from('instruments').select()
    setInstruments(data)
  }

  return (
    <View style={styles.container}>
      <FlatList
        data={instruments}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => <Text style={styles.item}>{item.name}</Text>}
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    paddingTop: 50,
    paddingHorizontal: 16,
  },
  item: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
})
```

## 9. Start the app

* steps
  * `npx expo start`
  * choose an option

## Next steps

* [set up Auth](../../auth)
* [insert MORE data | your database](../../database/import-data)
* upload & serve static files -- via -- [Storage](../../storage)
