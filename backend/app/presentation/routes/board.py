from flask import Blueprint, jsonify, g

from app.application.services.board import BoardService


board_bp = Blueprint("board", __name__, url_prefix="/board")


@board_bp.route("/", methods=["GET"])
def get_all_boards():
    boards = BoardService(g.db).get_all_boards()
    board_list = [f"{b.id}: {b.user_id}, {b.category_id}, {b.title}, {b.content}, {b.num_like}, {b.num_comment}, {b.creat_at}, {b.updated_at}" for b in boards]
    return jsonify(board_list)


@board_bp.route("/", methods=["POST"])
def create_board():
    pass


@board_bp.route("/<int:board_id>", methods=["DELETE"])
def delete_board(board_id):
    pass

@board_bp.route("/<int:board_id>", methods=["GET"])
def get_board(board_id):
    pass

@board_bp.route("/<int:board_id>", methods=["PUT"])
def update_board(board_id):
    pass
