import os
from flask import Flask
from app.config import DevelopmentConfig, ProductionConfig

from app.presentation import routes
# from app.database.session import init_db


def create_app() -> Flask:
    env = os.getenv("FLASK_ENV", "production").lower()
    config_class = {
        "development": DevelopmentConfig,
        "production": ProductionConfig
    }[env]

    app = Flask(__name__) 
    app.config.from_object(config_class)
    config_class.init_app(app)

    # init_db(app.config["DATABASE_URI"])


    routes.register(app)

    return app
