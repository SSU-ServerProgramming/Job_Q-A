from flask import Flask

from .user import user_bp
from .board import board_bp

from .auth import auth_bp
from .comment import comment_bp
from app.presentation.routes.mypage import mypage_bp
# from .auth import auth_bp

# from .category import category_bp

def register(app):
    app.register_blueprint(user_bp)
    app.register_blueprint(board_bp)

    app.register_blueprint(auth_bp)
    app.register_blueprint(comment_bp)
    app.register_blueprint(mypage_bp)
    # app.register_blueprint(auth_bp)
    # app.register_blueprint(category_bp)
