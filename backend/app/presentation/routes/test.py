from flask import Blueprint, jsonify

# test
from app.persistence.repositories.user_repository import UserRepository
from app.persistence import get_db_session


test_bp = Blueprint("test", __name__, url_prefix="/test")

@test_bp.route("/")
def test():
    return jsonify(status="ok")



# test용으로 작성해두었습니다. Application에서 주요로직을 정의해야합니다.
@test_bp.route('/all_users')
def test_get_all_users():
    db = get_db_session()
    try:
        user_repo = UserRepository(db)
        users = user_repo.get_all()
        user_list = [f"{user.id}: {user.email}, {user.name}" for user in users]
        return "<br>".join(user_list) if user_list else "No users found"
    finally:
        db.close()