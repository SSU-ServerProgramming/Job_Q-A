from typing import Any
from dataclasses import dataclass, field
from flask import jsonify


@dataclass
class HttpResponse:
    body: dict[str, Any]
    http_status: int = 200
    headers: dict[str, str] = field(default_factory=dict)

    def to_flask_response(self):
        return jsonify(self.body), self.http_status, self.headers


@dataclass
class RestResponse:
    status: str
    data: Any = None
    message: str | None = None
    errors: dict[str, str] | None = None
    meta: dict[str, Any] | None = None

    @classmethod
    def success(cls, data: Any = None, message: str = "요청이 성공적으로 처리되었습니다.", meta: dict[str, Any] | None = None):
        return cls(status="success", data=data, message=message, meta=meta)

    @classmethod
    def error(cls, message: str, data: Any = None, errors: dict[str, str] | None = None):
        return cls(status="error", data=data, message=message, errors=errors)
    

class HttpResponseAdapter:
    @staticmethod
    def from_rest(
        response: RestResponse,
        http_status: int = 200,
        headers: dict[str, str] | None = None
    ) -> HttpResponse:
        body: dict[str, Any] = {
            "status": response.status,
            "data": response.data,
            "message": response.message
        }

        if response.errors:
            body["errors"] = response.errors
        if response.meta:
            body["meta"] = response.meta

        return HttpResponse(body, http_status=http_status, headers=headers or {})    