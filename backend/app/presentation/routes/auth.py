from flask import Blueprint, request, g

from app.application.services.auth import AuthService
from app.presentation.response import RestResponse, HttpResponseAdapter
from app.presentation.jwt import verify_token, create_access_token

from app.presentation.serializers.user_serializer import serial_user_to_dict_company

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")

@auth_bp.route("/register", methods=["POST"])
def register():
    try:
        data = request.get_json()
        if not data:
            response = RestResponse.error("요청 데이터가 필요합니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

        result = AuthService(g.db).register(data)
        response = RestResponse.success(data=result, message="회원가입이 성공적으로 완료되었습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=201).to_flask_response()

    except ValueError as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

    except Exception as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=500).to_flask_response()

@auth_bp.route("/login", methods=["POST"])
def login():
    try:
        data = request.get_json()
        
        if 'email' not in data:
            response = RestResponse.error("이메일이 필요합니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()
        
        if 'password' not in data:
            response = RestResponse.error("비밀번호가 필요합니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

        result = AuthService(g.db).login(data)
        response = RestResponse.success(data=result, message="로그인이 성공적으로 완료되었습니다.")
        return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()

    except ValueError as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

    except Exception as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=500).to_flask_response()

@auth_bp.route("/refresh", methods=["POST"])
def refresh():
    try:
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            response = RestResponse.error("Bearer 토큰이 필요합니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=401).to_flask_response()

        refresh_token = auth_header.split(' ')[1]
        payload = verify_token(refresh_token)
        if payload['type'] != 'refresh':
            response = RestResponse.error("유효하지 않은 리프레시 토큰입니다.", data=None)
            return HttpResponseAdapter.from_rest(response, http_status=401).to_flask_response()

        new_access_token = create_access_token(payload['user_id'])
        response = RestResponse.success(
            data={'access_token': new_access_token},
            message="액세스 토큰이 성공적으로 갱신되었습니다."
        )
        return HttpResponseAdapter.from_rest(response).to_flask_response()

    except ValueError as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=401).to_flask_response()

    except Exception as e:
        response = RestResponse.error(str(e), data=None)
        return HttpResponseAdapter.from_rest(response, http_status=500).to_flask_response()
    
@auth_bp.route("/company", methods=["POST"])
def link_company():
    data = request.get_json()
    user_id = data.get("user_id")
    company_email = data.get("company_email")

    result = AuthService(g.db).link_company(user_id, company_email)

    if result is None:
        response = RestResponse.error("회사 연동에 실패했습니다.", data=None)
        return HttpResponseAdapter.from_rest(response, http_status=400).to_flask_response()

    response = RestResponse.success(
        data=serial_user_to_dict_company(result),
        message="회사 정보가 성공적으로 등록되었습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()