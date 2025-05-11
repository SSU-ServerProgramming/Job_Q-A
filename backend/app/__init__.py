from flask import Flask

def create_app():
    app = Flask(__name__)
    
    from .router.AuthRouter import auth
    from .router.UserRouter import user
    from .router.MainRouter import main
    from .router.CategoryRouter import category
    from .router.BoardRouter import board

    app.register_blueprint(auth, url_prefix='/auth')
    app.register_blueprint(user, url_prefix='/user')
    app.register_blueprint(main, url_prefix='/')
    app.register_blueprint(category, url_prefix='/category')
    app.register_blueprint(board, url_prefix='/board')

    return app