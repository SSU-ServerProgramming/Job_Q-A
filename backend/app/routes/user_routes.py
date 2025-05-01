from flask import Blueprint, jsonify
from ..database import get_db_connection

user = Blueprint('user', __name__)

@user.route("/")
def get_users():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users;")
        users = cursor.fetchall()
        conn.close()
        return jsonify(users)
    except Exception as e:
        return jsonify({"error": str(e)}), 500