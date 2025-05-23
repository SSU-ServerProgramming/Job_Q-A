from flask import Blueprint, jsonify, g

from app.application.services.user import UserService


user_bp = Blueprint("user", __name__, url_prefix="/user")


@user_bp.route("/", methods=["GET"])
def get_all_user():
    users = UserService(g.db).get_all_users()
    user_list = [f"{user.id}: {user.email}, {user.name}" for user in users]
    return jsonify(user_list)