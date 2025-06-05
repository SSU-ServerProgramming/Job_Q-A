from typing import List
from sqlalchemy import Integer, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin


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
    parent_comment_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("comments.id", ondelete="SET NULL", onupdate="CASCADE"),
        nullable=True
    )
    
    content: Mapped[str] = mapped_column(String(200), nullable=False)
    num_like: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    author: Mapped["User"] = relationship("User", back_populates="comments")
    board: Mapped["Board"] = relationship("Board", back_populates="comments")
    parent: Mapped["Comment"] = relationship("Comment", remote_side=[id], back_populates="replies")
    replies: Mapped[List["Comment"]] = relationship("Comment", back_populates="parent", cascade="all, delete-orphan", passive_deletes=True)
    likes: Mapped[List["CommentLike"]] = relationship(back_populates="comment", cascade="all, delete-orphan")

