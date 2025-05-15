from typing import Optional, List
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base

class Company(Base):
    __tablename__ = "companies"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(45), nullable=False)
    domain: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)

    users:  Mapped[List["User"]]  = relationship(
        "User",
        back_populates="company",
        cascade="all, delete-orphan"
    )