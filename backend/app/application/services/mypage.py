from app.persistence.repositories.user import UserRepository
from app.persistence.repositories.board import BoardRepository
from app.persistence.repositories.comment import CommentRepository
from .base import BaseService


class MypageService(BaseService):
    # 내 정보 조회
    def get_user_info(self, user_id: int):
        repo = UserRepository(self.session)
        result = repo.get_by_user_id_with_company(user_id)
        if not result:
            return None
        user, _ = result
        return user

    # 내가 쓴 게시글 목록 조회
    def get_user_boards(self, user_id: int) -> list[dict]:
        repo = BoardRepository(self.session)
        boards = repo.get_by_user_id(user_id)
        return [b.to_dict_mypage() for b in boards if b is not None]

    # 내가 쓴 댓글 목록 조회
    def get_user_comments(self, user_id: int) -> list[dict]:
        repo = CommentRepository(self.session)
        comments = repo.get_by_user(user_id)
        return [c.to_dict_mypage() for c in comments if c is not None]
