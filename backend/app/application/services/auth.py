from app.persistence.repositories.user import UserRepository
from app.database.models.user import User
from app.presentation.jwt import create_access_token, create_refresh_token
from .base import BaseService
import re
import bcrypt


class AuthService(BaseService):
    def register(self, data: dict):
        if not self._is_valid_email(data['email']):
            raise ValueError("유효하지 않은 이메일 형식입니다.")

        repo = UserRepository(self.session)
        
        if repo.get_by_email(data['email']):
            raise ValueError("이미 등록된 이메일입니다.")

        user = User(
            email=data['email'],
            password=data['password'],
            nickname=data['nickname'],
            company_id=data['company_id']
        )
        created_user = repo.create(user)
        return {
            'id': created_user.id,
            'email': created_user.email,
            'nickname': created_user.nickname,
            'company_id': created_user.company_id
        }

    def _is_valid_email(self, email: str) -> bool:
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(pattern, email))  
      
    def login(self, data: dict):
        repo = UserRepository(self.session)
        user = repo.get_by_email(data['email'])
        if not user:
            raise ValueError("존재하지 않는 이메일입니다.")
        
        if not bcrypt.checkpw(data['password'].encode('utf-8'), user.password.encode('utf-8')):
            raise ValueError("비밀번호가 일치하지 않습니다.")
            
        # JWT 토큰 생성
        access_token = create_access_token(user.id)
        refresh_token = create_refresh_token(user.id)
            
        return {
            'id': user.id,
            'email': user.email,
            'nickname': user.nickname,
            'company_id': user.company_id,
            'access_token': access_token,
            'refresh_token': refresh_token
        }
