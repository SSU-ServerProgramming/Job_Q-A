from app.persistence.repositories.user import UserRepository
from app.database.models.user import User
from .base import BaseService


class AuthService(BaseService):
    def register(self, data: dict):
        repo = UserRepository(self.session)
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