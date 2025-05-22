import os
from flask.cli import main

os.environ.setdefault('FLASK_APP', 'app:create_app')
os.environ.setdefault('FLASK_DEBUG', '1')

if os.getenv("APP_ENV", "production"):
    os.environ.setdefault('FLASK_ENV', 'production')
else: 
    os.environ.setdefault('FLASK_ENV', 'development')


if __name__ == '__main__':
    main()