# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.board import BoardRepository
from .base import BaseService


class BoardService(BaseService):
    def get_all_boards(self):
        repo = BoardRepository(self.session)
        return repo.get_all_boards()
    
    def get_user_boards(self, user_id: int):
        repo = BoardRepository(self.session)
        return repo.get_by_user_id(user_id)