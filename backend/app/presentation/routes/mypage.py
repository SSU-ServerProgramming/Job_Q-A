from flask import Blueprint, jsonify
from app.persistence import get_db_session
from app.application.services.mypage import MypageService

mypage_bp = Blueprint("mypage", __name__, url_prefix="/mypage")

# 내 정보 조회
@mypage_bp.route("/user/<int:user_id>", methods=["GET"])
def get_user_info(user_id):
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
def get_user_boards(user_id):
    db = get_db_session()
    try:
        service = MypageService(db)
        boards = service.get_user_boards(user_id)
        return jsonify({"status": "success", "data": boards})
    finally:
        db.close()


# 내가 쓴 댓글 목록 조회
@mypage_bp.route("/user/<int:user_id>/comments", methods=["GET"])
def get_user_comments(user_id):
    db = get_db_session()
    try:
        service = MypageService(db)
        comments = service.get_user_comments(user_id)
        return jsonify({"status": "success", "data": comments})
    finally:
        db.close()