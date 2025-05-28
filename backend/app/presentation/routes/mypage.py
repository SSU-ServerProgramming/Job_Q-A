from flask import Blueprint, jsonify, request
from app.persistence import get_db_session
from app.application.services.mypage import MypageService
from app.presentation.middleware.jwt_middleware import token_required

mypage_bp = Blueprint("mypage", __name__, url_prefix="/mypage")

# 내 정보 조회
@mypage_bp.route("/user/<int:user_id>", methods=["GET"])
@token_required
def get_user_info(user_id):
    # 토큰의 user_id와 요청의 user_id가 일치하는지 확인
    if request.user['user_id'] != user_id:
        return jsonify({"status": "error", "message": "권한이 없습니다."}), 403
        
    db = get_db_session()
    try:
        service = MypageService(db)
        user = service.get_user_info(user_id)
        if not user:
            return jsonify({"status": "error", "message": "사용자를 찾을 수 없습니다."}), 404
        return jsonify({"status": "success", "data": user.to_dict_mypage()})
    finally:
        db.close()


# 내가 쓴 게시글 목록 조회
@mypage_bp.route("/user/<int:user_id>/boards", methods=["GET"])
@token_required
def get_user_boards(user_id):
    # 토큰의 user_id와 요청의 user_id가 일치하는지 확인
    if request.user['user_id'] != user_id:
        return jsonify({"status": "error", "message": "권한이 없습니다."}), 403
        
    db = get_db_session()
    try:
        service = MypageService(db)
        boards = service.get_user_boards(user_id)
        return jsonify({"status": "success", "data": boards})
    finally:
        db.close()


# 내가 쓴 댓글 목록 조회
@mypage_bp.route("/user/<int:user_id>/comments", methods=["GET"])
@token_required
def get_user_comments(user_id):
    # 토큰의 user_id와 요청의 user_id가 일치하는지 확인
    if request.user['user_id'] != user_id:
        return jsonify({"status": "error", "message": "권한이 없습니다."}), 403
        
    db = get_db_session()
    try:
        service = MypageService(db)
        comments = service.get_user_comments(user_id)
        return jsonify({"status": "success", "data": comments})
    finally:
        db.close()