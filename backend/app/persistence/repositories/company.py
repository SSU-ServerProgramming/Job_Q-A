from .base import BaseRepository
from app.database.models.company import Company

from app.persistence.exception import PersistenceError

class CompanyRepository(BaseRepository):
    @PersistenceError.error 
    def get_by_domain(self, domain:str) -> Company | None:
        return self.session.query(Company).filter(Company.domain == domain).first()
    
    @PersistenceError.error
    def get_by_id(self, id:int) -> Company | None:
        return self.session.query(Company).filter(Company.id == id).first()