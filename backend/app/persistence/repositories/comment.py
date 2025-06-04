from sqlalchemy.orm import joinedload

from .base import BaseRepository
from app.database.models.comment import Comment
from app.database.models.comment_like import CommentLike

from app.persistence.exception import PersistenceError


class CommentRepository(BaseRepository):
    @PersistenceError.error
    def get_by_id(self, comment_id: int) -> Comment | None:
        return self.session.query(Comment).filter(Comment.id == comment_id).first()
    
    @PersistenceError.error
    def get_by_board_id(self, board_id: int) -> list[Comment]:
        result = (
            self.session.query(Comment)
            .options(joinedload(Comment.author))
            .filter(Comment.board_id == board_id)
            .all()
        )
        return self.session.query(Comment).filter(Comment.board_id == board_id).all()

    @PersistenceError.error
    def get_by_user(self, user_id: int) -> list[Comment]:
        return self.session.query(Comment).filter(Comment.user_id == user_id).all()

    @PersistenceError.error
    def create(self, user_id: int, board_id: int, content: str, parent_comment_id: int = None) -> Comment:
        comment = Comment(user_id=user_id, board_id=board_id, content=content, parent_comment_id=parent_comment_id)
        self.session.add(comment)
        self.session.flush()
        return comment

    @PersistenceError.error
    def update(self, comment: Comment, content: str) -> Comment:
        comment.content = content
        self.session.flush()
        return comment

    @PersistenceError.error
    def delete(self, comment: Comment) -> None:
        self.session.delete(comment)
        self.session.flush()

    @PersistenceError.error
    def like(self, comment_id: int, user_id: int) -> Comment:
        comment = self.get_by_id(comment_id)
        if comment is None:
            raise ValueError("댓글이 존재하지 않습니다.")

        exists = self.session.query(CommentLike).filter_by(comment_id=comment_id, user_id=user_id).first()
        if exists:
            raise ValueError("이미 좋아요를 누른 상태입니다.")

        new_like = CommentLike(user_id=user_id, comment_id=comment_id)
        self.session.add(new_like)
        comment.num_like += 1
        self.session.flush()
        return comment

    @PersistenceError.error
    def unlike(self, comment_id: int, user_id: int) -> Comment:
        comment = self.get_by_id(comment_id)
        if comment is None:
            raise ValueError("댓글이 존재하지 않습니다.")

        like = self.session.query(CommentLike).filter_by(comment_id=comment_id, user_id=user_id).first()
        if not like:
            raise ValueError("좋아요 기록이 존재하지 않습니다.")

        self.session.delete(like)
        comment.num_like = max(comment.num_like - 1, 0)
        self.session.flush()
        return comment
