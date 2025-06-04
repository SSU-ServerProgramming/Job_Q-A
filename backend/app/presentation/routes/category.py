from flask import Blueprint, g

from app.application.services.category import CategoryService
from app.presentation.response import RestResponse, HttpResponseAdapter


category_bp = Blueprint("category", __name__, url_prefix="/category")


@category_bp.route("", methods=["GET"])
def get_all_categories():
    categories = CategoryService(g.db).get_all_categories()
    category_list = [f"{c.id}: {c.name}" for c in categories]
    response = RestResponse.success(
        data=category_list,
        message="카테고리 목록을 성공적으로 조회했습니다."
    )
    return HttpResponseAdapter.from_rest(response, http_status=200).to_flask_response()