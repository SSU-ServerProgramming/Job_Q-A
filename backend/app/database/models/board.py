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
    likes: Mapped[List["BoardLikes"]] = relationship(
        "BoardLikes", back_populates="board", cascade="all, delete-orphan"
    )
