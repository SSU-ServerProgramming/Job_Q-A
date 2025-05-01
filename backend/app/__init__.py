from flask import Flask

def create_app():
    app = Flask(__name__)
    
    from .routes.auth_routes import auth
    from .routes.user_routes import user
    from .routes.main_routes import main
    from .routes.board_routes import board
    from .routes.category_routes import category
    
    app.register_blueprint(auth, url_prefix='/auth')
    app.register_blueprint(user, url_prefix='/user')
    app.register_blueprint(main, url_prefix='/')
    app.register_blueprint(board, url_prefix='/board')
    app.register_blueprint(category, url_prefix='/category')
    
    return app