from typing import TYPE_CHECKING
from sqlalchemy import Integer, ForeignKey, DateTime, UniqueConstraint, func, PrimaryKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.models.base import Base

# 순환 참조 방지
if TYPE_CHECKING:
    from .comment import Comment

class CommentLike(Base):
    __tablename__ = "comment_likes"

    user_id: Mapped[int] = mapped_column(
        Integer,        
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False
    )
    comment_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("comments.id", ondelete="CASCADE"),
        nullable=False
    )

    __table_args__ = (
        PrimaryKeyConstraint("user_id", "comment_id", name="pk_comment_likes"),
    )

    comment: Mapped["Comment"] = relationship("Comment", back_populates="likes")