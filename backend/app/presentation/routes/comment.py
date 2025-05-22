from flask import Blueprint, request, jsonify
from app.persistence import get_db_session
from app.persistence.repositories.comment_repository import CommentRepository
from flask import Response
import json

comment_bp = Blueprint("comment", __name__, url_prefix="/comment")

# 댓글 작성
@comment_bp.route("", methods=["POST"])
def create_comment():
    data = request.json
    db = get_db_session()
    try:
        repo = CommentRepository(db)
        result = repo.create(data)
        return jsonify(status="success", data=result), 201
    finally:
        db.close()

# 댓글 수정
@comment_bp.route("/<int:comment_id>", methods=["PUT"])
def update_comment(comment_id):
    data = request.json
    db = get_db_session()
    try:
        repo = CommentRepository(db)
        result = repo.update(comment_id, data)
        return jsonify(status="success", data=result)
    finally:
        db.close()

# 댓글 삭제
@comment_bp.route("/<int:comment_id>", methods=["DELETE"])
def delete_comment(comment_id):
    data = request.json
    db = get_db_session()
    try:
        repo = CommentRepository(db)
        repo.delete(comment_id, data["user_id"])
        return jsonify(status="success", data={})
    finally:
        db.close()

# 댓글 좋아요
@comment_bp.route("/<int:comment_id>/like", methods=["POST"])
def like_comment(comment_id):
    data = request.json
    db = get_db_session()
    try:
        repo = CommentRepository(db)
        result = repo.like(comment_id, data["user_id"])
        return jsonify(status="success", data=result)
    finally:
        db.close()

# 댓글 좋아요 취소
@comment_bp.route("/<int:comment_id>/like", methods=["DELETE"])
def unlike_comment(comment_id):
    data = request.json
    db = get_db_session()
    try:
        repo = CommentRepository(db)
        result = repo.unlike(comment_id, data["user_id"])
        return jsonify(status="success", data=result)
    finally:
        db.close()
