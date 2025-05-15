import os
from flask.cli import main

os.environ.setdefault('FLASK_APP', 'app:create_app')
os.environ.setdefault('FLASK_ENV', 'development')


if __name__ == '__main__':
    main()