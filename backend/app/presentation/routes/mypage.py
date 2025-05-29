from flask import Blueprint, request
from app.persistence import get_db_session
from app.application.services.mypage import MypageService
from app.presentation.middleware.jwt_middleware import token_required
from app.presentation.response import RestResponse, HttpResponseAdapter

mypage_bp = Blueprint("mypage", __name__, url_prefix="/mypage")

# 내 정보 조회
@mypage_bp.route("/user/<int:user_id>", methods=["GET"])
@token_required
def get_user_info(user_id):
    if request.user['user_id'] != user_id:
        response = RestResponse.error("권한이 없습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    
    db = get_db_session()
    try:
        service = MypageService(db)
        user = service.get_user_info(user_id)
        if not user:
            response = RestResponse.error("사용자를 찾을 수 없습니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
        
        response = RestResponse.success(
            data=user.to_dict_mypage(),
            message="사용자 정보를 성공적으로 조회했습니다."
        )
        return HttpResponseAdapter.from_rest(response).to_flask_response()
    finally:
        db.close()


# 내가 쓴 게시글 목록 조회
@mypage_bp.route("/user/<int:user_id>/boards", methods=["GET"])
@token_required
def get_user_boards(user_id):
    if request.user['user_id'] != user_id:
        response = RestResponse.error("권한이 없습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    
    db = get_db_session()
    try:
        service = MypageService(db)
        boards = service.get_user_boards(user_id)
        response = RestResponse.success(
            data=boards,
            message="내가 작성한 게시글 목록을 성공적으로 조회했습니다."
        )
        return HttpResponseAdapter.from_rest(response).to_flask_response()
    finally:
        db.close()


# 내가 쓴 댓글 목록 조회
@mypage_bp.route("/user/<int:user_id>/comments", methods=["GET"])
@token_required
def get_user_comments(user_id):
    if request.user['user_id'] != user_id:
        response = RestResponse.error("권한이 없습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    
    db = get_db_session()
    try:
        service = MypageService(db)
        comments = service.get_user_comments(user_id)
        response = RestResponse.success(
            data=comments,
            message="내가 작성한 댓글 목록을 성공적으로 조회했습니다."
        )
        return HttpResponseAdapter.from_rest(response).to_flask_response()
    finally:
        db.close()