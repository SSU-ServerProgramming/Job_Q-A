from sqlalchemy.orm import Session
from app.database.models.board import Board
from app.database.models.category import Category

class BoardRepository:
    def __init__(self, session: Session):
        self.session = session

    def get_by_user(self, user_id: int) -> list[dict]:
        boards = (
            self.session.query(Board, Category)
            .join(Category, Board.category_id == Category.id)
            .filter(Board.user_id == user_id)
            .order_by(Board.created_at.desc())
            .all()
        )

        return [
            {
                "board_id": b.id,
                "title": b.title,
                "category_name": c.name,
                "date": b.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                "like": b.num_like,
                "comment_count": b.num_comment
            }
            for b, c in boards
        ]
