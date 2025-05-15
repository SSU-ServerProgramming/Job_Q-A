from typing import List
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base


class Category(Base):
    __tablename__ = "categories"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(45), nullable=False, unique=True)

    boards: Mapped[List["Board"]] = relationship("Board", back_populates="category")