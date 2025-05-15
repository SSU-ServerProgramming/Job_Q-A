from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from app.config import Config


engine = create_engine(
    Config.DATABASE_URI,
    echo=Config.DEBUG,
    pool_pre_ping=True,
    future=True,
)

SessionLocal = scoped_session(
    sessionmaker(
        bind=engine,
        autocommit=False,
        autoflush=False,
        future=True,
    )
)
