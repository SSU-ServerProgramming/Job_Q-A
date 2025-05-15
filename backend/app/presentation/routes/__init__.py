from flask import Flask

from .test import test_bp


def register(app: Flask) -> None:
    app.register_blueprint(test_bp)
