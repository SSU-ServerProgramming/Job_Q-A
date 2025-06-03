from app.persistence.repositories.user import UserRepository
from app.persistence.repositories.board import BoardRepository
from app.persistence.repositories.comment import CommentRepository
from app.persistence.repositories.company import CompanyRepository
from .base import BaseService


class MypageService(BaseService):
    # 내 정보 조회
    def get_user_info(self, user_id: int):
        repo = UserRepository(self.session)

        user = repo.get_by_id(user_id)
        if user is None:
            raise ValueError("사용자가 존재하지 않습니다.")
        
        repo = CompanyRepository(self.session)
        company = repo.get_by_id(user.company_id)

        return user.id, user.email, user.nickname, company.name

    # 내가 쓴 게시글 목록 조회
    def get_user_boards(self, user_id: int) -> list:
        repo = BoardRepository(self.session)
        boards = repo.get_by_user_id(user_id)

        if not boards:
            return []

        return boards

    # 내가 쓴 댓글 목록 조회
    def get_user_comments(self, user_id: int) -> list:
        repo = CommentRepository(self.session)
        comments = repo.get_by_user(user_id)

        if not comments:
            return []

        return comments
