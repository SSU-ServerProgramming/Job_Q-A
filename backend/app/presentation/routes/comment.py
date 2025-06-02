from flask import Blueprint, request, g
from app.application.services.comment import CommentService
from app.presentation.middleware.jwt_middleware import token_required
from app.presentation.response import HttpResponseAdapter, RestResponse

from app.presentation.serializers.comment_serializer import serial_comment_to_dict

comment_bp = Blueprint("comment", __name__, url_prefix="/comment")


@comment_bp.route("/", methods=["POST"])
@token_required
def create_comment():
    try:
        data = request.json
        user_id = request.user['user_id']
        board_id = data.get('board_id')
        content = data.get('content')
        parent_comment_id = data.get('parent_comment_id')
        CommentService(g.db).create_comment(user_id=user_id, board_id=board_id, content=content, parent_comment_id=parent_comment_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="댓글이 성공적으로 작성되었습니다."), http_status=201).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()


@comment_bp.route("/<int:comment_id>", methods=["PUT"])
@token_required
def update_comment(comment_id):
    try:
        data = request.json
        user_id = request.user['user_id']
        content = data.get('content')
        comment_id = int(request.view_args['comment_id'])
        comment = CommentService(g.db).get_comment_by_id(comment_id)
        if not comment:
            return HttpResponseAdapter.from_rest(RestResponse.error("댓글이 존재하지 않습니다."), http_status=404).to_flask_response()
        if comment.user_id != user_id:
            return HttpResponseAdapter.from_rest(RestResponse.error("본인 댓글만 수정할 수 있습니다."), http_status=403).to_flask_response()
        CommentService(g.db).update_comment(comment_id=comment_id, user_id=user_id, content=content)
        return HttpResponseAdapter.from_rest(
            RestResponse.success(message="댓글이 성공적으로 수정되었습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()


@comment_bp.route("/<int:comment_id>", methods=["DELETE"])
@token_required
def delete_comment(comment_id):
    try:
        user_id = request.user['user_id']
        comment_id = int(request.view_args['comment_id'])
        comment = CommentService(g.db).get_comment_by_id(comment_id)
        if not comment:
            return HttpResponseAdapter.from_rest(RestResponse.error("댓글이 존재하지 않습니다."), http_status=404).to_flask_response()
        if comment.user_id != user_id:
            return HttpResponseAdapter.from_rest(RestResponse.error("본인 댓글만 삭제할 수 있습니다."), http_status=403).to_flask_response()
        CommentService(g.db).delete_comment(comment_id, user_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="댓글이 성공적으로 삭제되었습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()


@comment_bp.route("/<int:comment_id>/like", methods=["POST"])
@token_required
def like_comment(comment_id):
    try:
        user_id = request.user['user_id']
        comment_id = int(request.view_args['comment_id'])
        CommentService(g.db).like_comment(comment_id, user_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="댓글에 좋아요를 성공적으로 추가했습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()


@comment_bp.route("/<int:comment_id>/like", methods=["DELETE"])
@token_required
def unlike_comment(comment_id):
    try:
        user_id = request.user['user_id']
        comment_id = int(request.view_args['comment_id'])
        CommentService(g.db).unlike_comment(comment_id, user_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="댓글의 좋아요를 성공적으로 취소했습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()