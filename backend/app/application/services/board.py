# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.board import BoardRepostory
from .base import BaseService


class BoardService(BaseService):
    def get_all_boards(self):
        repo = BoardRepostory(self.session)
        return repo.get_all_boards()