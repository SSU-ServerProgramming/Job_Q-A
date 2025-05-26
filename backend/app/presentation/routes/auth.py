from flask import Blueprint, request, g

from app.application.services.auth import AuthService
from app.presentation.response import RestResponse, HttpResponseAdapter


auth_bp = Blueprint("auth", __name__, url_prefix="/auth")

@auth_bp.route("/register", methods=["POST"])
def register():
    try:
        data = request.get_json()
        if not data:
            response = RestResponse.error("요청 데이터가 필요합니다.")
            return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

        result = AuthService(g.db).register(data)
        response = RestResponse.success(data=result)
        return HttpResponseAdapter.from_rest(response, http_status=201).to_flask_response()

    except ValueError as e:
        response = RestResponse.error(str(e))
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

    except Exception as e:
        response = RestResponse.error(str(e))
        return HttpResponseAdapter.from_rest(response, http_status=500).to_flask_response()