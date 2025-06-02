from .base import BaseRepository
from app.database.models.comment_like import CommentLike

from app.persistence.exception import PersistenceError


class CommentLikesRepository(BaseRepository):
    @PersistenceError.error
    def get_by_user_comment_id(self, user_id: int, comment_id: int) -> CommentLike | None:
        result = (
            self.session.query(CommentLike)
            .filter(
                CommentLike.user_id == user_id,
                CommentLike.comment_id == comment_id
            )
            .one_or_none()
        )
        return result

    @PersistenceError.error
    def insert_like(self, user_id: int, comment_id: int) -> CommentLike:
        like = CommentLike(user_id=user_id, comment_id=comment_id)
        self.session.add(like)
        self.session.flush()
        return like

    @PersistenceError.error
    def delete_like(self, user_id: int, comment_id: int) -> None:
        like = self.get_by_user_comment_id(user_id, comment_id)
        if like is not None:
            self.session.delete(like)
        self.session.flush()