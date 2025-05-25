from .base import BaseRepository

from app.database.models.user import User
from app.database.models.company import Company

class UserRepository(BaseRepository):
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
        self.session.commit()
        return user

    def update(self, user: User) -> User:
        """기존 사용자 정보를 업데이트합니다."""
        self.session.merge(user)
        self.session.commit()
        return user

    def delete(self, user_id: int) -> None:
        """ID로 사용자 정보를 삭제합니다."""
        user = self.get_by_id(user_id)
        if user:
            self.session.delete(user)
            self.session.commit()

    def get_all_user(self, skip: int = 0, limit: int = 100) -> list[User]:
        """모든 사용자 정보를 조회합니다 (페이징)."""
        return self.session.query(User).offset(skip).limit(limit).all()
    
    def get_by_user_id_with_company(self, user_id: int) -> tuple[User, Company] | None:
        """마이페이지 용 사용자 정보 (회사 포함) 조회"""
        result = (
            self.session.query(User, Company)
            .join(Company, User.company_id == Company.id)
            .filter(User.id == user_id)
            .first()
        )
        return result
