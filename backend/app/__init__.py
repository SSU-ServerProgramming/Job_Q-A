import os
from flask import Flask, g
from app.config import DevelopmentConfig, ProductionConfig

from app.presentation import routes
from app.database.session import SessionLocal


def create_app() -> Flask:
    env = os.getenv("FLASK_ENV", "production").lower()
    config_class = {
        "development": DevelopmentConfig,
        "production": ProductionConfig
    }[env]

    app = Flask(__name__) 
    app.config.from_object(config_class)
    config_class.init_app(app)

    @app.before_request
    def open_session():
        # 요청 시작할 때 한 번만 세션 생성
        g.db = SessionLocal()

    @app.teardown_request
    def close_session(exc=None):
        db = g.pop("db", None)
        if db:
            if exc:
                db.rollback()
            else:
                db.commit()
            db.close()
            SessionLocal.remove() 


    routes.register(app)

    return app
