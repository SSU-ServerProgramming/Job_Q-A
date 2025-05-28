# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.category import CategoryRepository
from app.database.models.category import Category
from .base import BaseService


class CategoryService(BaseService):
    def get_all_categories(self) -> list[Category]:
        """모든 카테고리를 반환합니다."""
        repo = CategoryRepository(self.session)
        return repo.get_all_categories()