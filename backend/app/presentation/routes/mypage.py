from flask import Blueprint, request, g
from app.application.services.mypage import MypageService
from app.presentation.middleware.jwt_middleware import token_required
from app.presentation.response import RestResponse, HttpResponseAdapter

from app.presentation.serializers.user_serializer import serial_user_to_dict_mypage
from app.presentation.serializers.comment_serializer import serial_comment_to_dict_mypage
from app.presentation.serializers.board_serializer import serial_board_to_dict

mypage_bp = Blueprint("mypage", __name__, url_prefix="/mypage")

# 내 정보 조회
@mypage_bp.route("/user", methods=["GET"])
@token_required
def get_user_info():
    user_id = request.user['user_id']

    try:
        user_id, email, nickname, company_name = MypageService(g.db).get_user_info(user_id=user_id)
        data = serial_user_to_dict_mypage(user_id, email, nickname, company_name)
        response = RestResponse.success(data=data, message="사용자 정보를 성공적으로 조회했습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()
    
    except ValueError as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()


# 내가 쓴 게시글 목록 조회
@mypage_bp.route("/user/boards", methods=["GET"])
@token_required
def get_user_boards():
    user_id = request.user['user_id']
    boards = MypageService(g.db).get_user_boards(user_id)
    data = [serial_board_to_dict(board) for board in boards]

    response = RestResponse.success(
        data=data,
        message="내가 작성한 게시글 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


# 내가 쓴 댓글 목록 조회
@mypage_bp.route("/user/comments", methods=["GET"])
@token_required
def get_user_comments():
    user_id = request.user['user_id']
    comments = MypageService(g.db).get_user_comments(user_id)
    data = [serial_comment_to_dict_mypage(c) for c in comments]

    response = RestResponse.success(
        data=data,
        message="내가 작성한 댓글 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()