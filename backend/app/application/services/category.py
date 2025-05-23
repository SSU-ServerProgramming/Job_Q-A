# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.category import CategoryRepository
from .base import BaseService


class CategoryService(BaseService):
    def get_all_users(self):
        repo = CategoryRepository(self.session)
        return repo.get_all_categories()