from app.persistence.repositories.comment import CommentRepository
from app.database.models import Comment, Board
from .base import BaseService

from app.persistence.repositories.comment_like import CommentLikesRepository
from sqlalchemy.exc import IntegrityError

class CommentService(BaseService):
    # 유저가 작성한 모든 댓글 조회
    def get_comments_by_user(self, user_id: int) -> list[Comment]:
        repo = CommentRepository(self.session)
        return repo.get_by_user(user_id=user_id)
    
    # 특정 댓글 조회
    def get_comment_by_id(self, comment_id: int):
        repo = CommentRepository(self.session)
        return repo.get_by_id(comment_id)

    def create_comment(self, user_id: int, board_id: int, content: str, parent_comment_id: int = None) -> Comment:
        board = self.session.query(Board).filter(Board.id == board_id).first()
        if board is None:
            raise ValueError("게시물이 존재하지 않습니다.")
        repo = CommentRepository(self.session)
        return repo.create(user_id=user_id, board_id=board_id, content=content, parent_comment_id=parent_comment_id)

    def update_comment(self, comment_id: int, user_id: int, content: str) -> Comment:
        repo = CommentRepository(self.session)
        comment = repo.get_by_id(comment_id=comment_id)

        if comment is None:
            raise ValueError("댓글이 존재하지 않습니다.")
        if comment.user_id != user_id:
            raise ValueError("댓글 수정 권한이 없습니다.")

        return repo.update(comment=comment, content=content)

    def delete_comment(self, comment_id: int, user_id: int) -> Comment:
        repo = CommentRepository(self.session)
        comment = repo.get_by_id(comment_id=comment_id)

        if comment is None:
            raise ValueError("댓글이 존재하지 않습니다.")
        if comment.user_id != user_id:
            raise ValueError("댓글 삭제 권한이 없습니다.")

        repo.delete(comment)
        return comment

    def like_comment(self, comment_id: int, user_id: int) -> Comment | None:
        comment_repo = CommentRepository(self.session)
        like_repo = CommentLikesRepository(self.session)
        comment = comment_repo.get_by_id(comment_id)

        if comment is None:
            raise ValueError("댓글이 존재하지 않습니다.")

        try:
            like_repo.insert_like(user_id=user_id, comment_id=comment_id)
            comment.num_like += 1
            self.session.commit()
            return comment
        
        except IntegrityError as e:
            self.session.rollback()
            # 조건 위배가 아니면 중복으로 판단
            if "uix_user_comment" in str(e.orig):
                raise ValueError("이미 좋아요한 댓글입니다.")
            else:
                raise ValueError("좋아요 처리 중 오류가 발생했습니다.")
      

    def unlike_comment(self, comment_id: int, user_id: int) -> Comment | None:
        comment_repo = CommentRepository(self.session)
        like_repo = CommentLikesRepository(self.session)
        comment = comment_repo.get_by_id(comment_id)

        if comment is None:
            raise ValueError("댓글이 존재하지 않습니다.")

        like = like_repo.get_by_user_comment_id(user_id=user_id, comment_id=comment_id)
        if like is None:
            raise ValueError("좋아요 기록이 존재하지 않습니다.")

        like_repo.delete_like(user_id=user_id, comment_id=comment_id)
        comment.num_like = max(0, comment.num_like - 1)
        self.session.commit()
        return comment