from flask import Blueprint, request, g
from app.application.services.comment import CommentService
from app.presentation.middleware.jwt_middleware import token_required
from app.presentation.response import HttpResponseAdapter, RestResponse

comment_bp = Blueprint("comment", __name__, url_prefix="/comment")


@comment_bp.route("", methods=["POST"])
@token_required
def create_comment():
    data = request.json
    data['user_id'] = request.user['user_id']  # 토큰에서 user_id 추출
    created = CommentService(g.db).create_comment(data)
    response = RestResponse.success(data=created.to_dict_full())
    return HttpResponseAdapter.from_rest(response, http_status=201).to_flask_response()


@comment_bp.route("/<int:comment_id>", methods=["PUT"])
@token_required
def update_comment(comment_id):
    data = request.json
    user_id = request.user['user_id']
    comment = CommentService(g.db).get_comment_by_id(comment_id)
    if not comment:
        response = RestResponse.error("댓글이 존재하지 않습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
    if comment.user_id != user_id:
        response = RestResponse.error("본인 댓글만 수정할 수 있습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    data['user_id'] = user_id
    updated = CommentService(g.db).update_comment(comment_id, data)
    response = RestResponse.success(data=updated.to_dict_full())
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@comment_bp.route("/<int:comment_id>", methods=["DELETE"])
@token_required
def delete_comment(comment_id):
    user_id = request.user['user_id']
    comment = CommentService(g.db).get_comment_by_id(comment_id)
    if not comment:
        response = RestResponse.error("댓글이 존재하지 않습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
    if comment.user_id != user_id:
        response = RestResponse.error("본인 댓글만 삭제할 수 있습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    ok = CommentService(g.db).delete_comment(comment_id, user_id)
    response = RestResponse.success()
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@comment_bp.route("/<int:comment_id>/like", methods=["POST"])
@token_required
def like_comment(comment_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    result = CommentService(g.db).like_comment(comment_id, user_id)
    if result is None:
        response = RestResponse.error("댓글이 존재하지 않거나 이미 좋아요한 상태입니다.")
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()
    response = RestResponse.success(data=result)
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@comment_bp.route("/<int:comment_id>/like", methods=["DELETE"])
@token_required
def unlike_comment(comment_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    result = CommentService(g.db).unlike_comment(comment_id, user_id)
    if result is None:
        response = RestResponse.error("댓글이 존재하지 않거나 이미 좋아요를 취소한 상태입니다.")
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()
    response = RestResponse.success(data=result)
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()