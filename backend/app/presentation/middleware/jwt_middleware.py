from functools import wraps
from flask import request, jsonify
from app.presentation.jwt import verify_token

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
                return jsonify({'message': 'Invalid token format'}), 401

        if not token:
            return jsonify({'message': 'Token is missing'}), 401

        try:
            # 토큰 검증
            data = verify_token(token)
            # 현재 사용자 정보를 request에 추가
            request.user = data
        except ValueError as e:
            return jsonify({'message': str(e)}), 401

        return f(*args, **kwargs)
    return decorated 