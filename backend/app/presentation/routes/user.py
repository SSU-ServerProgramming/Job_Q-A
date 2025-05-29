from flask import Blueprint, g

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
            'company_id': user.company_id,
            'password': user.password
        } for user in users
    ]
    response = RestResponse.success(
        data=user_list,
        message="사용자 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()