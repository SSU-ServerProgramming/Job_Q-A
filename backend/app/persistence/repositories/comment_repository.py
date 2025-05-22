from sqlalchemy.orm import Session
from datetime import datetime
from app.database.models.comment import Comment

class CommentRepository:
    def __init__(self, session: Session):
        self.session = session

    def create(self, data: dict) -> dict:
        comment = Comment(
            user_id=data["user_id"],
            board_id=data["board_id"],
            content=data["content"],
            parent_comment_id=data.get("parent_comment_id")
        )
        self.session.add(comment)
        self.session.flush()
        return {
            "comment_id": comment.id,
            "board_id": comment.board_id,
            "user_id": comment.user_id,
            "content": comment.content,
            "date": comment.created_at.strftime("%Y-%m-%d %H:%M:%S")
        }

    def update(self, comment_id: int, data: dict) -> dict:
        comment = self.session.query(Comment).filter(Comment.id == comment_id).first()
        if not comment or comment.user_id != data["user_id"]:
            raise ValueError("댓글 수정 권한이 없습니다.")
        comment.content = data["content"]
        self.session.flush()
        return {
            "comment_id": comment.id,
            "board_id": comment.board_id,
            "user_id": comment.user_id,
            "content": comment.content,
            "date": comment.updated_at.strftime("%Y-%m-%d %H:%M:%S")
        }

    def delete(self, comment_id: int, user_id: int):
        comment = self.session.query(Comment).filter(Comment.id == comment_id).first()
        if not comment or comment.user_id != user_id:
            raise ValueError("댓글 삭제 권한이 없습니다.")
        self.session.delete(comment)
        self.session.flush()

    def like(self, comment_id: int, user_id: int) -> dict:
        comment = self.session.query(Comment).filter(Comment.id == comment_id).first()
        if comment is None:
            raise ValueError(f"댓글 ID {comment_id}가 존재하지 않습니다.")
        comment.num_like += 1
        self.session.flush()
        return {"comment_id": comment.id, "like": comment.num_like}

    def unlike(self, comment_id: int, user_id: int) -> dict:
        comment = self.session.query(Comment).filter(Comment.id == comment_id).first()
        if comment is None:
            raise ValueError(f"댓글 ID {comment_id}가 존재하지 않습니다.")
        comment.num_like = max(comment.num_like - 1, 0)
        self.session.flush()
        return {"comment_id": comment.id, "like": comment.num_like}

    def get_by_user(self, user_id: int) -> list[dict]:
        comments = self.session.query(Comment).filter(Comment.user_id == user_id).all()
        return [
            {
                "comment_id": c.id,
                "board_id": c.board_id,
                "content": c.content,
                "date": c.created_at.strftime("%Y-%m-%d %H:%M:%S")
            }
            for c in comments
        ]
