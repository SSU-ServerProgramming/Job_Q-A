from flask import Blueprint, request, g
from app.application.services.comment import CommentService
from app.presentation.middleware.jwt_middleware import token_required
from app.presentation.response import HttpResponseAdapter, RestResponse

from app.presentation.serializers.comment_serializer import serial_comment_to_dict

comment_bp = Blueprint("comment", __name__, url_prefix="/comment")


@comment_bp.route("/", methods=["POST"])
@token_required
def create_comment():
    data = request.json
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    board_id = data.get('board_id')
    content = data.get('content')
    parent_comment_id = data.get('parent_comment_id')

    created = CommentService(g.db).create_comment(user_id=user_id, board_id=board_id, content=content, parent_comment_id=parent_comment_id)
    response = RestResponse.success(
        data = serial_comment_to_dict(created),
        message="댓글이 성공적으로 작성되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=201).to_flask_response()


@comment_bp.route("/<int:comment_id>", methods=["PUT"])
@token_required
def update_comment(comment_id):
    data = request.json
    user_id = request.user['user_id']
    content = data.get("content")
    comment = CommentService(g.db).get_comment_by_id(comment_id)

    if not comment:
        response = RestResponse.error("댓글이 존재하지 않습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
    
    if comment.user_id != user_id:
        response = RestResponse.error("본인 댓글만 수정할 수 있습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    
    data['user_id'] = user_id
    updated = CommentService(g.db).update_comment(comment_id=comment_id, user_id=user_id, content=content)
    response = RestResponse.success(
        data = serial_comment_to_dict(updated),
        message="댓글이 성공적으로 수정되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@comment_bp.route("/<int:comment_id>", methods=["DELETE"])
@token_required
def delete_comment(comment_id):
    user_id = request.user['user_id']
    comment = CommentService(g.db).get_comment_by_id(comment_id)

    if not comment:
        response = RestResponse.error("댓글이 존재하지 않습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
    
    if comment.user_id != user_id:
        response = RestResponse.error("본인 댓글만 삭제할 수 있습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    
    ok = CommentService(g.db).delete_comment(comment_id, user_id)
    response = RestResponse.success(
        data = None,
        message="댓글이 성공적으로 삭제되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@comment_bp.route("/<int:comment_id>/like", methods=["POST"])
@token_required
def like_comment(comment_id):
    try:
        user_id = request.user['user_id']  # 토큰에서 user_id 추출
        result = CommentService(g.db).like_comment(comment_id, user_id)

        if result is None:
            response = RestResponse.error("댓글이 존재하지 않거나 이미 좋아요한 상태입니다.", data = None)
            return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()
        
        response = RestResponse.success(
            data = serial_comment_to_dict(result),
            message = "댓글에 좋아요를 성공적으로 추가했습니다."
        )
        return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()
    except ValueError as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()


@comment_bp.route("/<int:comment_id>/like", methods=["DELETE"])
@token_required
def unlike_comment(comment_id):
    try:
        user_id = request.user['user_id']  # 토큰에서 user_id 추출
        result = CommentService(g.db).unlike_comment(comment_id, user_id)

        if result is None:
            response = RestResponse.error("댓글이 존재하지 않거나 이미 좋아요를 취소한 상태입니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()
        
        response = RestResponse.success(
            data = serial_comment_to_dict(result),
            message = "댓글의 좋아요를 성공적으로 취소했습니다."
        )
        return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()
    except ValueError as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()