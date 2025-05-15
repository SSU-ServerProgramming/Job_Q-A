import datetime

from sqlalchemy import MetaData, DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, registry


convention = {
    "ix":   "ix_%(column_0_label)s",                                       # INDEX
    "uq":   "uq_%(table_name)s_%(column_0_name)s",                         # UNIQUE
    "ck":   "ck_%(table_name)s_%(column_0_name)s",                         # CHECK
    "fk":   "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s", # FOREIGN_KEY
    "pk":   "pk_%(table_name)s"                                            # PRIMARY_KEY
}

mapper_registry = registry(metadata=MetaData(naming_convention=convention))

class Base(DeclarativeBase):
    registry = mapper_registry
    metadata = mapper_registry.metadata


class TimestampMixin:
    """생성, 수정 시간 관리"""
    __abstract__ = True
    
    created_at: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )

    updated_at: Mapped[datetime.datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        server_onupdate=func.now(),
        nullable=False
    )