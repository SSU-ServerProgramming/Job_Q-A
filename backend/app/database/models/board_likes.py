from sqlalchemy import ForeignKey, PrimaryKeyConstraint, Integer
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base


class BoardLikes(Base):
    __tablename__ = "board_likes"

    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False
    )
    board_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("boards.id", ondelete="CASCADE"),
        nullable=False
    )

    __table_args__ = (
        PrimaryKeyConstraint("user_id", "board_id", name="pk_board_likes"),
    )

    board: Mapped["Board"] = relationship("Board", back_populates="likes")
    user: Mapped["User"] = relationship("User", back_populates="liked_boards")
