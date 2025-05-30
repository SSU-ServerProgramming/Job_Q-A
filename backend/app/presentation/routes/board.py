from flask import Blueprint, request, g

from app.presentation.response import HttpResponseAdapter, HttpResponse, RestResponse
from app.application.services.board import BoardService
from app.presentation.middleware.jwt_middleware import token_required

from app.presentation.serializers.board_serializer import serial_board_to_dict

board_bp = Blueprint("board", __name__, url_prefix="/board")

@board_bp.route("/", methods=["GET"])
def get_all_board():
    sort = request.args.get('sort')
    if sort == 'num_likes':
        boards = BoardService(g.db).get_by_num_like()
    else:
        boards = BoardService(g.db).get_all_boards()
    response_data = [serial_board_to_dict(b) for b in boards]
    response = RestResponse.success(
        data=response_data,
        message="게시글 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/category/<int:category_id>", methods=["GET"])
def get_by_category_id(category_id):
    boards = BoardService(g.db).get_by_category_id(category_id)
    reponse_data = [serial_board_to_dict(b) for b in boards]
    response = RestResponse.success(
        data=reponse_data,
        message="카테고리별 게시글 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/detail/<int:board_id>", methods=["GET"])
def get_by_board_id(board_id):
    board = BoardService(g.db).get_by_board_id(board_id=board_id)
    response_data = serial_board_to_dict(board)
    response = RestResponse.success(
        data=response_data,
        message="게시글을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@board_bp.route("/", methods=["POST"])
@token_required
def create_board():
    data = request.get_json()
    title = data.get("title")
    content = data.get("content")
    category_id = data.get("category_id")
    user_id = request.user['user_id']  # 토큰에서 user_id 추출

    board = BoardService(g.db).create_board(user_id=user_id, title=title, content=content, category_id=category_id)
    response_data = serial_board_to_dict(board)
    response = RestResponse.success(
        data=response_data,
        message="게시글이 성공적으로 작성되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=201).to_flask_response()


@board_bp.route("/<int:board_id>", methods=["PUT"])
@token_required
def update_board(board_id):
    data = request.get_json()
    title = data.get("title")
    content = data.get("content")
    category_id = data.get("category_id")
    user_id = request.user['user_id']
    board = BoardService(g.db).get_by_board_id(board_id)
    if not board:
        response = RestResponse.error("게시글이 존재하지 않습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
    if board.user_id != user_id:
        response = RestResponse.error("본인 게시글만 수정할 수 있습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    board = BoardService(g.db).update_board(board_id=board_id, user_id=user_id, title=title, content=content, category_id=category_id)
    response_data = serial_board_to_dict(board)
    response = RestResponse.success(
        data=response_data,
        message="게시글이 성공적으로 수정되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@board_bp.route("/<int:board_id>", methods=["DELETE"])
@token_required
def delete_board(board_id):
    user_id = request.user['user_id']
    board = BoardService(g.db).get_by_board_id(board_id)
    if not board:
        response = RestResponse.error("게시글이 존재하지 않습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=404).to_flask_response()
    if board.user_id != user_id:
        response = RestResponse.error("본인 게시글만 삭제할 수 있습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=403).to_flask_response()
    BoardService(g.db).delete_board(board_id=board_id)
    response = RestResponse.success(
        data=None,
        message="게시글이 성공적으로 삭제되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/<int:board_id>/like", methods=["POST"])
@token_required
def add_like(board_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    BoardService(g.db).add_like(user_id=user_id, board_id=board_id)
    response = RestResponse.success(
        data=None,
        message="게시글에 좋아요를 성공적으로 추가했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/<int:board_id>/like", methods=["DELETE"])
@token_required
def delete_like(board_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    BoardService(g.db).delete_like(user_id=user_id, board_id=board_id)
    response = RestResponse.success(
        data=None,
        message="게시글의 좋아요를 성공적으로 취소했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()