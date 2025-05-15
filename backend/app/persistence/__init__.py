from .repositories.user_repository import UserRepository
from app.database.session import SessionLocal

def get_db_session():
    return SessionLocal()