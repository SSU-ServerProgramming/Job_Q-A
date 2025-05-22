from flask import Blueprint, jsonify
from app.persistence import get_db_session
from app.persistence.repositories.user_repository import UserRepository
from app.persistence.repositories.board_repository import BoardRepository
from app.persistence.repositories.comment_repository import CommentRepository

mypage_bp = Blueprint("mypage", __name__, url_prefix="/mypage")

# 마이페이지 - 내 정보 조회
@mypage_bp.route("/user/<int:user_id>", methods=["GET"])
def get_user_info(user_id):
    db = get_db_session()
    try:
        repo = UserRepository(db)
        result = repo.get_info_for_mypage(user_id)
        return jsonify(status="success", data=result)
    finally:
        db.close()

# 마이페이지 - 내가 쓴 게시글 목록 조회
@mypage_bp.route("/user/<int:user_id>/boards", methods=["GET"])
def get_user_boards(user_id):
    db = get_db_session()
    try:
        repo = BoardRepository(db)
        result = repo.get_by_user(user_id)
        return jsonify(status="success", data=result)
    finally:
        db.close()

# 마이페이지 - 내가 쓴 댓글 목록 조회
@mypage_bp.route("/user/<int:user_id>/comments", methods=["GET"])
def get_user_comments(user_id):
    db = get_db_session()
    try:
        repo = CommentRepository(db)
        result = repo.get_by_user(user_id)
        return jsonify(status="success", data=result)
    finally:
        db.close()
