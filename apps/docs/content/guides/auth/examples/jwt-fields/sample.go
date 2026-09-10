type AmrEntry struct {
    Method    string `json:"method"`
    Timestamp int64  `json:"timestamp"`
}

type JwtClaims struct {
    Iss         string                 `json:"iss"`
    Aud         interface{}            `json:"aud"` // string or []string
    Exp         int64                  `json:"exp"`
    Iat         int64                  `json:"iat"`
    Sub         string                 `json:"sub"`
    Role        string                 `json:"role"`
    Aal         string                 `json:"aal"`
    SessionID   string                 `json:"session_id"`
    Email       string                 `json:"email"`
    Phone       string                 `json:"phone"`
    IsAnonymous bool                   `json:"is_anonymous"`
    Jti         *string                `json:"jti,omitempty"`
    Nbf         *int64                 `json:"nbf,omitempty"`
    AppMetadata map[string]interface{} `json:"app_metadata,omitempty"`
    UserMetadata map[string]interface{} `json:"user_metadata,omitempty"`
    Amr         []AmrEntry             `json:"amr,omitempty"`
    Ref         *string                `json:"ref,omitempty"` // Only in anon/service role tokens
}