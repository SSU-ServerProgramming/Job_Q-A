from typing import List
from sqlalchemy import Integer, String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    email: Mapped[str] = mapped_column(String(45), nullable=False, unique=True)
    nickname: Mapped[str] = mapped_column(String(45), nullable=False)
    password: Mapped[str] = mapped_column(String(200), nullable=False)
    company_id: Mapped[int] = mapped_column(Integer,
        ForeignKey("companies.id",ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False)
    
    company: Mapped["Company"] = relationship("Company", back_populates="users")
    boards: Mapped[List["Board"]] = relationship("Board", back_populates="author")
    comments: Mapped[List["Comment"]] = relationship("Comment", back_populates="author")
    liked_boards: Mapped[List["BoardLikes"]] = relationship(
        "BoardLikes", back_populates="user", cascade="all, delete-orphan"
    )

