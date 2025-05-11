from flask import Blueprint, jsonify, request
from ..service import BoardService

board = Blueprint('board', __name__)

@board.route("/", methods=["GET"])
def get_all_boards():
    try:
        result = BoardService.get_all_boards()
        return jsonify(result), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/", methods=["POST"])
def create_board():
    try:
        data = request.get_json()
        if not data:
            return jsonify({
                "status": "error",
                "message": "요청 데이터가 필요합니다."
            }), 400

        result = BoardService.create_board(data)
        return jsonify(result), 201

    except ValueError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/<int:board_id>", methods=["DELETE"])
def delete_board(board_id):
    try:
        user_id = request.args.get('user_id', type=int)
        if not user_id:
            return jsonify({
                "status": "error",
                "message": "사용자 ID가 필요합니다."
            }), 400

        result = BoardService.delete_board(user_id, board_id)
        return jsonify(result), 200

    except ValueError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except PermissionError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 403

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/<int:board_id>", methods=["GET"])
def get_board(board_id):
    try:
        result = BoardService.get_board(board_id)
        return jsonify(result), 200
        
    except ValueError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 404

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/<int:board_id>", methods=["PUT"])
def update_board(board_id):
    try:
        data = request.get_json()
        if not data:
            return jsonify({
                "status": "error",
                "message": "요청 데이터가 필요합니다."
            }), 400

        user_id = data.get('user_id')
        if not user_id:
            return jsonify({
                "status": "error",
                "message": "사용자 ID가 필요합니다."
            }), 400
            
        result = BoardService.update_board(board_id, user_id, data)
        return jsonify(result), 200
        
    except ValueError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except PermissionError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 403

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500