from flask import Flask

from .user import user_bp
from .board import board_bp

from .auth import auth_bp
from .comment import comment_bp
from app.presentation.routes.mypage import mypage_bp
# from .auth import auth_bp

# from .category import category_bp

from flask import Blueprint
from app.presentation.middleware.jwt_middleware import AuthenticationError
from app.presentation.response import HttpResponseAdapter, RestResponse

def register(app):
    app.register_blueprint(user_bp)
    app.register_blueprint(board_bp)

    app.register_blueprint(auth_bp)
    app.register_blueprint(comment_bp)
    app.register_blueprint(mypage_bp)
    # app.register_blueprint(auth_bp)
    # app.register_blueprint(category_bp)

def register_error_handlers(app):
    @app.errorhandler(AuthenticationError)
    def handle_auth_error(error):
        response = RestResponse.error(error.message)
        return HttpResponseAdapter.from_rest(response, http_status=error.status_code).to_flask_response()

    # 다른 에러 핸들러들도 여기에 추가 가능
