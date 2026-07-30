import { useState, useEffect } from 'react'
import { supabaseLocalStorage } from './lib/supabaseLocalStorage'
import Auth from './components/Auth'
import Account from './components/Account'
import { View } from 'react-native'

export default function App() {
  const [userId, setUserId] = useState<string | null>(null)
  const [email, setEmail] = useState<string | undefined>(undefined)

  useEffect(() => {
    supabaseLocalStorage.auth.getClaims().then(({ data: { claims } }) => {
      if (claims) {
        setUserId(claims.sub)
        setEmail(claims.email)
      }
    })

    supabaseLocalStorage.auth.onAuthStateChange(async (_event, _session) => {
      const {
        data: { claims },
      } = await supabaseLocalStorage.auth.getClaims()
      if (claims) {
        setUserId(claims.sub)
        setEmail(claims.email)
      } else {
        setUserId(null)
        setEmail(undefined)
      }
    })
  }, [])

  return <View>{userId ? <Account key={userId} userId={userId} email={email} /> : <Auth />}</View>
}
