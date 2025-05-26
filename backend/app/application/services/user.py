# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.user import UserRepository
from .base import BaseService


class UserService(BaseService):
    def get_all_users(self):
        repo = UserRepository(self.session)
        return repo.get_all_users()