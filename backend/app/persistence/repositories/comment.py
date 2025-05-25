# comment_repository.py
from sqlalchemy.orm import Session
from app.database.models.comment import Comment
from app.database.models.comment_like import CommentLike


class CommentRepository:
    def __init__(self, session):
        self.session = session

    def get_by_id(self, comment_id: int) -> Comment | None:
        return self.session.query(Comment).filter(Comment.id == comment_id).first()

    def get_by_user(self, user_id: int) -> list[Comment]:
        return self.session.query(Comment).filter(Comment.user_id == user_id).all()

    def has_user_liked(self, comment_id: int, user_id: int) -> bool:
        return self.session.query(CommentLike).filter_by(comment_id=comment_id, user_id=user_id).first() is not None

    def add_like(self, comment: Comment, user_id: int) -> Comment:
        new_like = CommentLike(user_id=user_id, comment_id=comment.id)
        self.session.add(new_like)
        comment.num_like += 1
        self.session.flush()
        return comment

    def remove_like(self, comment: Comment, user_id: int) -> Comment | None:
        like = self.session.query(CommentLike).filter_by(comment_id=comment.id, user_id=user_id).first()
        if like:
            self.session.delete(like)
            comment.num_like = max(comment.num_like - 1, 0)
            self.session.flush()
            return comment
        return None

    def create(self, comment: Comment) -> Comment:
        self.session.add(comment)
        self.session.flush()
        return comment

    def update(self, comment: Comment) -> Comment:
        self.session.merge(comment)
        self.session.flush()
        return comment

    def delete(self, comment: Comment) -> None:
        self.session.delete(comment)
        self.session.flush()
