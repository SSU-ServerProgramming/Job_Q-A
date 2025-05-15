from sqlalchemy.orm import Session

from app.database.session import get_db
from app.database.models.user import User


# class UserRepository:
#     def __init__(self):
#         self.session = get_db()

#     def get_by_id(self, user_id: int) -> User | None:
#         return self.session.get(User, user_id)

#     def add(self, user: User) -> User:
#         self.session.add(user)
#         self.session.commit()
#         return user

#     def close(self):
#         self.session.close()

class UserRepository:
    def __init__(self, session: Session):
        self.session = session

    def get_by_id(self, user_id: int) -> User | None:
        """ID로 사용자 정보를 조회합니다."""
        return self.session.query(User).filter(User.id == user_id).first()

    def get_by_email(self, email: str) -> User | None:
        """이메일로 사용자 정보를 조회합니다."""
        return self.session.query(User).filter(User.email == email).first()

    def get_users_by_company(self, company_id: int, skip: int = 0, limit: int = 100) -> list[User]:
        """특정 회사 ID에 소속된 사용자 목록을 조회합니다."""
        return self.session.query(User).filter(User.company_id == company_id).offset(skip).limit(limit).all()

    def get_user_by_name(self, name: str) -> list[User]:
        """특정 이름을 가진 사용자 목록을 조회합니다."""
        return self.session.query(User).filter(User.name == name).all()

    def create(self, user: User) -> User:
        """새로운 사용자 정보를 생성합니다."""
        self.session.add(user)
        self.session.flush()
        return user

    def update(self, user: User) -> User:
        """기존 사용자 정보를 업데이트합니다."""
        self.session.merge(user)
        self.session.flush()
        return user

    def delete(self, user_id: int) -> None:
        """ID로 사용자 정보를 삭제합니다."""
        user = self.get_by_id(user_id)
        if user:
            self.session.delete(user)
            self.session.flush()

    def get_all(self, skip: int = 0, limit: int = 100) -> list[User]:
        """모든 사용자 정보를 조회합니다 (페이징 처리 가능)."""
        return self.session.query(User).offset(skip).limit(limit).all()