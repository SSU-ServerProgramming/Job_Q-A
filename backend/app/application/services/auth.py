from app.persistence.repositories.user import UserRepository
from app.database.models.user import User
from .base import BaseService
import re


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