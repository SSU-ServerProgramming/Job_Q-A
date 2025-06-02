from .base import BaseRepository
from app.database.models.board_likes import BoardLikes

from app.persistence.exception import PersistenceError


class BoardLikesRepository(BaseRepository):
    @PersistenceError.error
    def get_by_user_board_id(self, user_id:int, board_id:int):
        """주 키(user_id+board_id)로 조회합니다."""
        result = (
            self.session.query(BoardLikes)
            .filter(
                BoardLikes.user_id == user_id,
                BoardLikes.board_id == board_id
            )
            .one_or_none()
        )
        return result
    
    @PersistenceError.error
    def insert_like(self, user_id: int, board_id: int) -> BoardLikes:
        """좋아요를 추가합니다."""
        like = BoardLikes(user_id=user_id, board_id=board_id)
        self.session.add(like)
        self.session.flush()
        return like
    
    @PersistenceError.error
    def delete_like(self, user_id: int, board_id: int) -> None:
        """좋아요를 제거합니다."""
        like = self.get_by_user_board_id(user_id, board_id)
        if like is not None:
            self.session.delete(like)
        self.session.flush()