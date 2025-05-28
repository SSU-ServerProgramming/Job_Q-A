from flask import Blueprint, request, jsonify, g
from app.application.services.comment import CommentService

comment_bp = Blueprint("comment", __name__, url_prefix="/comment")


@comment_bp.route("", methods=["POST"])
def create_comment():
    data = request.json
    created = CommentService(g.db).create_comment(data)
    return jsonify({"status": "success", "data": created.to_dict_full()}), 201


@comment_bp.route("/<int:comment_id>", methods=["PUT"])
def update_comment(comment_id):
    data = request.json
    updated = CommentService(g.db).update_comment(comment_id, data)
    if updated is None:
        return jsonify({"status": "error", "message": "권한이 없거나 댓글이 존재하지 않습니다."}), 403
    return jsonify({"status": "success", "data": updated.to_dict_full()})


@comment_bp.route("/<int:comment_id>", methods=["DELETE"])
def delete_comment(comment_id):
    data = request.json
    ok = CommentService(g.db).delete_comment(comment_id, data["user_id"])
    if not ok:
        return jsonify({"status": "error", "message": "권한이 없거나 댓글이 존재하지 않습니다."}), 403
    return jsonify({"status": "success", "data": {}})


@comment_bp.route("/<int:comment_id>/like", methods=["POST"])
def like_comment(comment_id):
    data = request.json
    result = CommentService(g.db).like_comment(comment_id, data["user_id"])
    if result is None:
        return jsonify({"status": "error", "message": "댓글이 존재하지 않거나 이미 좋아요한 상태입니다."}), 400
    return jsonify({"status": "success", "data": result})


@comment_bp.route("/<int:comment_id>/like", methods=["DELETE"])
def unlike_comment(comment_id):
    data = request.json
    result = CommentService(g.db).unlike_comment(comment_id, data["user_id"])
    if result is None:
        return jsonify({"status": "error", "message": "댓글이 존재하지 않거나 이미 좋아요를 취소한 상태입니다."}), 400
    return jsonify({"status": "success", "data": result})