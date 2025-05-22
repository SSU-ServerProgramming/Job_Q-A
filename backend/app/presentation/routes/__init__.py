from flask import Flask

from .test import test_bp
from .comment import comment_bp
from .mypage import mypage_bp
from .board import board_bp


def register(app: Flask) -> None:
    app.register_blueprint(test_bp)
    app.register_blueprint(comment_bp)
    app.register_blueprint(mypage_bp)
    app.register_blueprint(board_bp)