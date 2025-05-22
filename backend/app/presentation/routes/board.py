from flask import Blueprint, request, jsonify
from app.persistence import get_db_session
from app.database.models.board import Board

board_bp = Blueprint("board", __name__, url_prefix="/board")

@board_bp.route("", methods=["POST"])
def create_board():
    data = request.json
    db = get_db_session()
    try:
        board = Board(
            user_id=data["user_id"],
            title=data["title"],
            category_id=data["category_id"],
            content=data["content"]
        )
        db.add(board)
        db.flush()
        return jsonify(status="success", data={"board_id": board.id}), 201
    finally:
        db.close()