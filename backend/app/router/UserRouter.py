from flask import Blueprint, jsonify
from ..service import UserService

user = Blueprint('user', __name__)

@user.route("/", methods=["GET"])
def get_all_users():
    try:
        result = UserService.get_all_users()
        return jsonify({
            "status": "success",
            "data": result
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500