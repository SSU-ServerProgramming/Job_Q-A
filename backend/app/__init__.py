import os
from flask import Flask, g
from app.config import DevelopmentConfig, ProductionConfig

from app.presentation import routes
from app.database.session import SessionLocal


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


def create_app() -> Flask:
    env = os.getenv("FLASK_ENV", "production").lower()
    config_class = {
        "development": DevelopmentConfig,
        "production": ProductionConfig
    }[env]

    app = Flask(__name__) 
    app.config.from_object(config_class)
    app.before_request(open_session)
    app.teardown_request(close_session)
    

    routes.register(app)

    return app
