from flask import Blueprint, jsonify, request
from ..service import BoardService
from ..common.response import Response

board = Blueprint('board', __name__)

@board.route("/", methods=["GET"])
def get_all_boards():
    try:
        result = BoardService.get_all_boards()
        return jsonify(Response.success(data=result).to_dict()), 200
        
    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500

@board.route("/", methods=["POST"])
def create_board():
    try:
        data = request.get_json()
        if not data:
            return jsonify(Response.error("요청 데이터가 필요합니다.").to_dict()), 400

        result = BoardService.create_board(data)
        return jsonify(Response.success(data=result).to_dict()), 201

    except ValueError as e:
        return jsonify(Response.error(str(e)).to_dict()), 400

    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500

@board.route("/<int:board_id>", methods=["DELETE"])
def delete_board(board_id):
    try:
        data = request.get_json()
        if not data:
            return jsonify(Response.error("요청 데이터가 필요합니다.").to_dict()), 400

        user_id = data.get('user_id')
        category_id = data.get('category_id')
        
        if not user_id:
            return jsonify(Response.error("사용자 ID가 필요합니다.").to_dict()), 400
        if not category_id:
            return jsonify(Response.error("카테고리 ID가 필요합니다.").to_dict()), 400
        
        try:
            board_info = BoardService.check_board_exists(board_id, category_id)
            writer_id = board_info['user_id']
        except ValueError as e:
            return jsonify(Response.error(str(e)).to_dict()), 404
        
        result = BoardService.delete_board(user_id, board_id, writer_id)
        return jsonify(Response.success(data=result).to_dict()), 200

    except ValueError as e:
        return jsonify(Response.error(str(e)).to_dict()), 400

    except PermissionError as e:
        return jsonify(Response.error(str(e)).to_dict()), 403

    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500

@board.route("/<int:board_id>", methods=["GET"])
def get_board(board_id):
    try:
        category_id = request.args.get('category_id', type=int)
        result = BoardService.get_board(board_id, category_id)
        return jsonify(Response.success(data=result).to_dict()), 200
        
    except ValueError as e:
        return jsonify(Response.error(str(e)).to_dict()), 404

    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500

@board.route("/<int:board_id>", methods=["PUT"])
def update_board(board_id):
    try:
        data = request.get_json()
        if not data:
            return jsonify(Response.error("요청 데이터가 필요합니다.").to_dict()), 400

        user_id = data.get('user_id')
        category_id = data.get('category_id')
        
        if not user_id:
            return jsonify(Response.error("사용자 ID가 필요합니다.").to_dict()), 400
        if not category_id:
            return jsonify(Response.error("카테고리 ID가 필요합니다.").to_dict()), 400
            
        try:
            board_info = BoardService.check_board_exists(board_id, category_id)
            writer_id = board_info['user_id']
        except ValueError as e:
            return jsonify(Response.error(str(e)).to_dict()), 404
            
        result = BoardService.update_board(board_id, user_id, data, writer_id, category_id)
        return jsonify(Response.success(data=result).to_dict()), 200
        
    except ValueError as e:
        return jsonify(Response.error(str(e)).to_dict()), 400

    except PermissionError as e:
        return jsonify(Response.error(str(e)).to_dict()), 403

    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500