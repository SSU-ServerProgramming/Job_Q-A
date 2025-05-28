# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.user import UserRepository
from .base import BaseService


class UserService(BaseService):
    def get_all_users(self):
        repo = UserRepository(self.session)

        return repo.get_all_users()
    
    def get_user_info(self, user_id: int):
        repo = UserRepository(self.session)
        result = repo.get_by_user_id_with_company(user_id)
        if not result:
            return None
        user, _ = result
        return user

