from flask import Blueprint, request, g

from app.presentation.response import HttpResponseAdapter, HttpResponse, RestResponse
from app.application.services.board import BoardService
from app.presentation.middleware.jwt_middleware import token_required

board_bp = Blueprint("board", __name__, url_prefix="/board")

# 임시로 이곳에 구현해둠
def board_to_response_dict(board):
    return {
        "board_id": board.id,
        "category_name": board.category.name if board.category else None,
        "comment_count": board.num_comment,
        "content": board.content,
        "date": board.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        "like": board.num_like,
        "title": board.title,
        "writer": board.user_id,
    }

@board_bp.route("/", methods=["GET"])
def get_all_board():
    sort = request.args.get('sort')
    if sort == 'num_likes':
        boards = BoardService(g.db).get_by_num_like()
    else:
        boards = BoardService(g.db).get_all_boards()
    response_data = [board_to_response_dict(b) for b in boards]
    response = RestResponse.success(data=response_data)
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/category/<int:category_id>", methods=["GET"])
def get_by_category_id(category_id):
    boards = BoardService(g.db).get_by_category_id(category_id)
    reponse_data = [board_to_response_dict(b) for b in boards]
    response = RestResponse.success(data=reponse_data)
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/detail/<int:board_id>", methods=["GET"])
def get_by_board_id(board_id):
    board = BoardService(g.db).get_by_board_id(board_id=board_id)
    response_data = board_to_response_dict(board)
    response = RestResponse.success(data=response_data)
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
    response_data = board_to_response_dict(board)
    response = RestResponse.success(data=response_data)
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@board_bp.route("/<int:board_id>", methods=["PUT"])
@token_required
def update_board(board_id):
    data = request.get_json()
    title = data.get("title")
    content = data.get("content")
    category_id = data.get("category_id")
    user_id = request.user['user_id']  # 토큰에서 user_id 추출

    board = BoardService(g.db).update_board(board_id=board_id, user_id=user_id, title=title, content=content, category_id=category_id)
    response_data = board_to_response_dict(board)
    response = RestResponse.success(data=response_data)
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()


@board_bp.route("/<int:board_id>", methods=["DELETE"])
@token_required
def delete_board(board_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    BoardService(g.db).delete_board(board_id=board_id, user_id=user_id)
    response = RestResponse.success()
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/<int:board_id>/like", methods=["POST"])
@token_required
def add_like(board_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    BoardService(g.db).add_like(user_id=user_id, board_id=board_id)
    response = RestResponse.success()
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

@board_bp.route("/<int:board_id>/like", methods=["DELETE"])
@token_required
def delete_like(board_id):
    user_id = request.user['user_id']  # 토큰에서 user_id 추출
    BoardService(g.db).delete_like(user_id=user_id, board_id=board_id)
    response = RestResponse.success()
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

