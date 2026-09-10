from typing import Optional, Union, List, Dict, Any
from dataclasses import dataclass

@dataclass
class AmrEntry:
    method: str
    timestamp: int

@dataclass
class JwtClaims:
    iss: str
    aud: Union[str, List[str]]
    exp: int
    iat: int
    sub: str
    role: str
    aal: str
    session_id: str
    email: str
    phone: str
    is_anonymous: bool
    jti: Optional[str] = None
    nbf: Optional[int] = None
    app_metadata: Optional[Dict[str, Any]] = None
    user_metadata: Optional[Dict[str, Any]] = None
    amr: Optional[List[AmrEntry]] = None
    ref: Optional[str] = None  # Only in anon/service role tokens