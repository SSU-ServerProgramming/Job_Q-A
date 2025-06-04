import os
from flask import Flask, g
from flask_cors import CORS

from app.config import config
from app.presentation import routes
from app.database.session import SessionLocal

# 이 부분도 파일을 분리하면 좋겠지만, 아직은 2개 함수 뿐이라 __init__.py에 작성해두었습니다.
def open_session():
    g.db = SessionLocal()

def close_session(exc=None):
    db = g.pop("db", None)
    if db:
        if exc:
            db.rollback()            
        else:
            db.commit()
        db.close()
        SessionLocal.remove() 

# Flask App
# SQLAlchemy Session, Blueprint Route, App config를 반영한 App을 반환합니다.
def create_app() -> Flask:
    app = Flask(__name__) 
    
    config_name = os.getenv("APP_ENV", "default")
    app.config.from_object(config[config_name])
    
    # CORS 설정 추가
    CORS(app, resources={r"/*": {"origins": "*", "supports_credentials": True}})
    
    app.before_request(open_session)
    app.teardown_request(close_session)

    routes.register(app)
    routes.register_error_handlers(app)

    return app
