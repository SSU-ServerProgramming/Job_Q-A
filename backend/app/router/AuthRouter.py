from flask import Blueprint, jsonify, request
from ..service import AuthService
from ..common.response import Response

auth = Blueprint('auth', __name__)

@auth.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        if not data:
            return jsonify(Response.error("요청 데이터가 필요합니다.").to_dict()), 400

        result = AuthService.register(data)
        if isinstance(result, dict) and 'message' in result:
            result = {k: v for k, v in result.items() if k != 'message'}
        return jsonify(Response.success(data=result).to_dict()), 201

    except ValueError as e:
        return jsonify(Response.error(str(e)).to_dict()), 400

    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500

@auth.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        if not data:
            return jsonify(Response.error("요청 데이터가 필요합니다.").to_dict()), 400

        result = AuthService.login(data)
        if isinstance(result, dict) and 'message' in result:
            result = {k: v for k, v in result.items() if k != 'message'}
        return jsonify(Response.success(data=result).to_dict()), 200

    except ValueError as e:
        return jsonify(Response.error(str(e)).to_dict()), 400

    except PermissionError as e:
        return jsonify(Response.error(str(e)).to_dict()), 401

    except Exception as e:
        return jsonify(Response.error(str(e)).to_dict()), 500