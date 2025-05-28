from functools import wraps
from flask import request
from app.presentation.jwt import verify_token

class AuthenticationError(Exception):
    def __init__(self, message: str, status_code: int = 401):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        # 헤더에서 토큰 가져오기
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(" ")[1]
            except IndexError:
                raise AuthenticationError("잘못된 토큰 형식입니다.")

        if not token:
            raise AuthenticationError("토큰이 없습니다.")

        try:
            # 토큰 검증
            data = verify_token(token)
            # 현재 사용자 정보를 request에 추가
            request.user = data
        except ValueError as e:
            raise AuthenticationError(str(e))

        return f(*args, **kwargs)
    return decorated 