# /config에서 설정한 환경변수로 Flask config설정
import os


class Config():
    DEBUG = False
    TESTING = False

    DATABASE_URI = (
        f"mysql+pymysql://"
        f"{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@"
        f"{os.getenv('DB_HOST')}:{os.getenv('DB_PORT', 3306)}/"
        f"{os.getenv('DB_NAME')}?charset=utf8mb4"
    )

    @staticmethod
    def init_app(app):
        pass


class DevelopmentConfig(Config):
    DEBUG = True
    TESTING = False


class ProductionConfig(Config):
    DEBUG = False
    TESTING = False


config = {
    "development": DevelopmentConfig,
    "production": ProductionConfig,
    "default" : DevelopmentConfig
}