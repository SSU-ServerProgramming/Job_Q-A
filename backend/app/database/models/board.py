from typing import List
from sqlalchemy import Integer, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base, TimestampMixin


class Board(Base, TimestampMixin):
    __tablename__ = "boards"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    category_id:  Mapped[int]  = mapped_column(
        Integer,
        ForeignKey("categories.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    title:       Mapped[str] = mapped_column(String(45), nullable=False)
    content:     Mapped[str] = mapped_column(String(2000))
    num_like:    Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    num_comment: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    author:   Mapped["User"]     = relationship("User", back_populates="boards")
    category: Mapped["Category"] = relationship("Category", back_populates="boards")
    comments: Mapped[List["Comment"]] = relationship("Comment", back_populates="board")

    def to_dict_mypage(self) -> dict:
        return {
            "board_id": self.id,
            "category_name": self.category.name if self.category else None,
            "comment_count": self.num_comment,
            "date": (self.updated_at or self.created_at).strftime("%Y-%m-%d %H:%M:%S"),
            "like": self.num_like,
            "title": self.title
    }