import os
from datetime import datetime, timedelta
import jwt

JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'your-secret-key')
JWT_ACCESS_TOKEN_EXPIRES = timedelta(days=30)
JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=30)

def create_access_token(user_id: int) -> str:
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + JWT_ACCESS_TOKEN_EXPIRES,
        'iat': datetime.utcnow(),
        'type': 'access'
    }
    return jwt.encode(payload, JWT_SECRET_KEY, algorithm='HS256')

def create_refresh_token(user_id: int) -> str:
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + JWT_REFRESH_TOKEN_EXPIRES,
        'iat': datetime.utcnow(),
        'type': 'refresh'
    }
    return jwt.encode(payload, JWT_SECRET_KEY, algorithm='HS256')

def verify_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=['HS256'])
        return payload
    except jwt.ExpiredSignatureError:
        raise ValueError("토큰이 만료되었습니다.")
    except jwt.InvalidTokenError:
        raise ValueError("유효하지 않은 토큰입니다.") 