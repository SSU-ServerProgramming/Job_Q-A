from app.persistence.repositories.user import UserRepository
from app.database.models.user import User
from app.presentation.jwt import create_access_token, create_refresh_token
from .base import BaseService
import re
import bcrypt

from app.persistence.repositories.company import CompanyRepository


class AuthService(BaseService):
    def __is_valid_email(self, email: str) -> bool:
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(pattern, email))
    
    def register(self, email: str, password: str, nickname: str) -> dict:
        if not self.__is_valid_email(email):
            raise ValueError("유효하지 않은 이메일 형식입니다.")

        repo = UserRepository(self.session)
        company = CompanyRepository(self.session).get_by_domain(email.split("@")[-1])

        if not company:
            raise ValueError("등록되지 않은 회사 도메인입니다.")

        if repo.get_by_email(email):
            raise ValueError("이미 등록된 이메일입니다.")

        user = User(
            email=email,
            password= bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8'),
            nickname=nickname,
            company_id=company.id
        )
        created_user = repo.create(user)
        self.session.commit()
        return {
            'id': created_user.id,
            'email': created_user.email,
            'nickname': created_user.nickname,
            'company_id': created_user.company_id
        }

      
    def login(self, data: dict):
        repo = UserRepository(self.session)
        user = repo.get_by_email(data['email'])
        if not user:
            raise ValueError("존재하지 않는 이메일입니다.")
        
        if not bcrypt.checkpw(data['password'].encode('utf-8'), user.password.encode('utf-8')):
            raise ValueError("비밀번호가 일치하지 않습니다.")
            
        # JWT 토큰 생성
        access_token = create_access_token(user.id)
        refresh_token = create_refresh_token(user.id)
            
        return {
            'id': user.id,
            'email': user.email,
            'nickname': user.nickname,
            'company_id': user.company_id,
            'access_token': access_token,
            'refresh_token': refresh_token
        }
    
    def link_company(self, user_id: int, company_email: str) -> User | None:
        domain = company_email.split("@")[-1]
        company = CompanyRepository(self.session).get_by_domain(domain)
        if not company:
            raise ValueError("등록되지 않은 회사 도메인입니다.")

        user = UserRepository(self.session).get_by_id(user_id)
        if not user:
            raise ValueError("사용자를 찾을 수 없습니다.")

        user.company_name = company.name
        self.session.commit()
        return user
    
