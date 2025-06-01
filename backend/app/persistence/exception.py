# persistence/error.py

# Persistence에서 사용하는 에러 클래스를 정의합니다.
# Persistence에서 직접 예외처리를 하지는 않으며, SQLAlchemy Exception을 Application layer로 곧바로 전달하지 않기 위함입니다.
# Persistence layer의 모든 예외는 PersistenceError로 감싸서 상위계층에 전달합니다.
from sqlalchemy.exc import SQLAlchemyError
from functools import wraps


class PersistenceError(Exception):
    def __init__(self, message: str = "DB Error", exception: Exception | None = None):
        self.exception = exception
        super().__init__(message)

    @staticmethod
    def error(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            try:
                return fn(*args, **kwargs)
            except SQLAlchemyError as e:
                raise PersistenceError(f"SQLAlchemyError in {fn.__name__}", e) from e
            except Exception as e:
                raise PersistenceError(f"Other Error in {fn.__name__}") from e
        return wrapper