from flask import Blueprint, jsonify
from ..database import get_db_connection

category = Blueprint('category', __name__)

@category.route("/categories", methods=["GET"])
def get_all_categories():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        sql = """
        SELECT 
            category_id,
            name
        FROM categories
        ORDER BY category_id
        """
        
        cursor.execute(sql)
        categories = cursor.fetchall()
        conn.close()
        
        return jsonify({
            "status": "success",
            "data": categories,
            "count": len(categories)
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500
