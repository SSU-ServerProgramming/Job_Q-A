from typing import List, Optional, TYPE_CHECKING
from sqlalchemy import Integer, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin

# 순환 참조 방지
if TYPE_CHECKING:
    from .comment_like import CommentLike

class Comment(Base, TimestampMixin):
    __tablename__ = 'comments'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    board_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("boards.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    parent_comment_id: Mapped[Optional[int]] = mapped_column(
        Integer,
        ForeignKey("comments.id", ondelete="SET NULL", onupdate="CASCADE"),
    )
    content: Mapped[str] = mapped_column(String(200), nullable=False)
    num_like: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    author:  Mapped["User"] = relationship("User", back_populates="comments")
    board:   Mapped["Board"] = relationship("Board", back_populates="comments")
    parent:  Mapped["Comment"] = relationship(
        "Comment",
        remote_side=[id],
        back_populates="replies"
    )
    replies: Mapped[List["Comment"]] = relationship(
        "Comment",
        back_populates="parent",
        cascade="all, delete-orphan"
    )
    likes: Mapped[List["CommentLike"]] = relationship(
        back_populates="comment",
        cascade="all, delete-orphan"
    )

    # JSON 형식 반환
    def to_dict_full(self) -> dict:
        return {
            "board_id": self.board_id,
            "comment_id": self.id,
            "content": self.content,
            "date": (self.updated_at or self.created_at).strftime("%Y-%m-%d %H:%M:%S"),
            "user_id": self.user_id,
        }

    def to_dict_mypage(self) -> dict:
        return {
            "board_id": self.board_id,
            "comment_id": self.id,
            "content": self.content,
            "date": (self.updated_at or self.created_at).strftime("%Y-%m-%d %H:%M:%S"),
        }

# comment_like 관계 추가
likes: Mapped[List["CommentLike"]] = relationship(back_populates="comment", cascade="all, delete-orphan")

