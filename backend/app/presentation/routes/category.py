# from flask import Blueprint, jsonify, g

# from app.application.services.category import CategoryService


# category_bp = Blueprint("category", __name__, url_prefix="/categoty")


# @category_bp.route("/", methods=["GET"])
# def get_all_categories():
#     categories = CategoryService(g.db).get_all_categories()
#     category_list = [f"{c.id}: {c.name}" for c in categories]
#     return jsonify(category_list)