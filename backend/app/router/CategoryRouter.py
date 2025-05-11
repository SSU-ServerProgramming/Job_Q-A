from flask import Blueprint, jsonify
from ..service import CategoryService

category = Blueprint('category', __name__)

@category.route("/", methods=["GET"])
def get_all_categories():
    try:
        result = CategoryService.get_all_categories()
        return jsonify({
            "status": "success",
            "data": result
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500
