from .base import BaseRepository
from app.database.models.company import Company

class CompanyRepository(BaseRepository):
    def get_by_domain(self, domain: str) -> Company | None:
        return self.session.query(Company).filter(Company.domain == domain).first()