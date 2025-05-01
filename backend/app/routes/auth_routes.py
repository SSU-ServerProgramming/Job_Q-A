from flask import Blueprint, jsonify, request
import bcrypt
from app.database import get_db_connection

auth = Blueprint('auth', __name__)

@auth.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()

        nickname = data.get("nickname")
        email = data.get("email")
        password = data.get("password")
        company_id = data.get("company_id")

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            conn.close()
            return jsonify({"error": "이미 존재하는 이메일입니다."}), 400

        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

        sql = """
        INSERT INTO users (nickname, email, password, company_id)
        VALUES (%s, %s, %s, %s)
        """
        cursor.execute(sql, (nickname, email, hashed_password, company_id))
        conn.commit()
        conn.close()

        return jsonify({"message": "회원가입 성공"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@auth.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()

        email = data.get("email")
        password = data.get("password")

        conn = get_db_connection()
        cursor = conn.cursor()

        sql = "SELECT * FROM users WHERE email = %s"
        cursor.execute(sql, (email,))
        user = cursor.fetchone()
        conn.close()

        if not user:
            return jsonify({"error": "존재하지 않는 사용자입니다."}), 404

        if not bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
            return jsonify({"error": "비밀번호가 일치하지 않습니다."}), 401

        return jsonify({
            "message": "로그인 성공",
            "nickname": user['nickname'],
            "email": user['email'],
            "user_id": user['user_id']
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500