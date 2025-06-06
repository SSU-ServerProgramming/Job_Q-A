from flask import Blueprint, request, g

from app.presentation.response import HttpResponseAdapter, HttpResponse, RestResponse
from app.application.services.board import BoardService
from app.presentation.middleware.jwt_middleware import token_required

from app.presentation.serializers.board_serializer import *
from app.presentation.serializers.comment_serializer import *

board_bp = Blueprint("board", __name__, url_prefix="/board")

@board_bp.route("/", methods=["GET"])
def get_all_board():
    sort = request.args.get('sort')
    if sort == 'num_likes':
        boards = BoardService(g.db).get_by_num_like()
    else:
        boards = BoardService(g.db).get_all_boards()
    response_data = [serialize_board(b) for b in boards]
    response = RestResponse.success(
        data=response_data,
        message="게시글 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/category/<int:category_id>", methods=["GET"])
def get_by_category_id(category_id):
    boards = BoardService(g.db).get_by_category_id(category_id)
    reponse_data = [serialize_board(b) for b in boards]
    response = RestResponse.success(
        data=reponse_data,
        message="카테고리별 게시글 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/detail/<int:board_id>", methods=["GET"])
@token_required
def get_by_board_id(board_id):
    user_id = request.user['user_id']
    board, comments = BoardService(g.db).get_by_board_id(board_id, user_id)
    
    response_data = {
        "board": serialize_board_detail(board),
        "comments": [serialize_comment_detail(c) for c in comments]
    }
    response = RestResponse.success(
        data=response_data,
        message="게시글을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/", methods=["POST"])
@token_required
def create_board():
    try:
        data = request.get_json()
        title = data.get("title")
        content = data.get("content")
        category_id = data.get("category_id")
        user_id = request.user['user_id'] # 토큰에서 user_id 추출
        BoardService(g.db).create_board(user_id=user_id, title=title, content=content, category_id=category_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="게시글이 성공적으로 작성되었습니다."), http_status=201).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()


@board_bp.route("/<int:board_id>", methods=["PUT"])
@token_required
def update_board(board_id):
    try:
        data = request.get_json()
        title = data.get("title")
        content = data.get("content")
        category_id = data.get("category_id")
        user_id = request.user['user_id']
        board_id = int(request.view_args['board_id'])
        board, _ = BoardService(g.db).get_by_board_id(board_id)
        if not board:
            return HttpResponseAdapter.from_rest(RestResponse.error("게시글이 존재하지 않습니다."), http_status=404).to_flask_response()
        if board.user_id != user_id:
            return HttpResponseAdapter.from_rest(RestResponse.error("본인 게시글만 수정할 수 있습니다."), http_status=403).to_flask_response()
        BoardService(g.db).update_board(board_id=board_id, user_id=user_id, title=title, content=content, category_id=category_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="게시글이 성공적으로 수정되었습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()


@board_bp.route("/<int:board_id>", methods=["DELETE"])
@token_required
def delete_board(board_id):
    try:
        user_id = request.user['user_id']
        board_id = int(request.view_args['board_id'])
        board, _ = BoardService(g.db).get_by_board_id(board_id)
        if not board:
            return HttpResponseAdapter.from_rest(RestResponse.error("게시글이 존재하지 않습니다."), http_status=404).to_flask_response()
        if board.user_id != user_id:
            return HttpResponseAdapter.from_rest(RestResponse.error("본인 게시글만 삭제할 수 있습니다."), http_status=403).to_flask_response()
        BoardService(g.db).delete_board(board_id=board_id)
        return HttpResponseAdapter.from_rest(
            RestResponse.success(message="게시글이 성공적으로 삭제되었습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()

@board_bp.route("/<int:board_id>/like", methods=["POST"])
@token_required
def add_like(board_id):
    try:
        user_id = request.user['user_id'] # 토큰에서 user_id 추출
        board_id = int(request.view_args['board_id'])
        BoardService(g.db).add_like(user_id=user_id, board_id=board_id)
        return HttpResponseAdapter.from_rest(
            RestResponse.success(message="게시글에 좋아요를 성공적으로 추가했습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()

@board_bp.route("/<int:board_id>/like", methods=["DELETE"])
@token_required
def delete_like(board_id):
    try:
        user_id = request.user['user_id']
        board_id = int(request.view_args['board_id'])
        BoardService(g.db).delete_like(user_id=user_id, board_id=board_id)
        return HttpResponseAdapter.from_rest(RestResponse.success(message="게시글의 좋아요를 성공적으로 취소했습니다."), http_status=200).to_flask_response()
    except ValueError as e:
        return HttpResponseAdapter.from_rest(RestResponse.error(str(e)), http_status=400).to_flask_response()