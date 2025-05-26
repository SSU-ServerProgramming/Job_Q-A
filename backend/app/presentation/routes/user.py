from flask import Blueprint, jsonify, g

from app.application.services.user import UserService
from app.presentation.response import RestResponse, HttpResponseAdapter


user_bp = Blueprint("user", __name__, url_prefix="/user")


@user_bp.route("/", methods=["GET"])
def get_all_user():
    users = UserService(g.db).get_all_users()
    user_list = [
        {
            'id': user.id,
            'email': user.email,
            'nickname': user.nickname,
            'company_id': user.company_id
        } for user in users
    ]
    response = RestResponse.success(data=user_list)
    return HttpResponseAdapter.from_rest(response).to_flask_response()