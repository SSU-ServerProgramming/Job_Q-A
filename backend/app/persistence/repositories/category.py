from .base import BaseRepository
from app.database.models.category import Category


class CategoryRepository(BaseRepository):
    def get_all_categories(self) -> list[Category]:
        """모든 카테고리를 반환합니다."""
        result = (
            self.session.query(Category)
            .order_by(Category.id)
            .all()
        )
        return result