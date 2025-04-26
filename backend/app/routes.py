# Flask, MySQL이 Docker위에서 잘 작동하는지 테스트 하기 위한 간단한 코드입니다.
# ./db/init.sql, seed.sql과 같은 파일들도 실제 프로젝트와 무관합니다.


import os
from flask import Blueprint, jsonify, request
import pymysql


main = Blueprint('main', __name__)

def get_db_connection():
    return pymysql.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
        database=os.environ.get("DB_NAME"),
        port=3306,
        cursorclass=pymysql.cursors.DictCursor
    )

@main.route("/")
def test():
    return "Docker Container Test"


@main.route("/users")
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
    
@main.route("/register", methods=["POST"])
def register():
    try:
        data = request.get_json()

        nickname = data.get("nickname")
        email = data.get("email")
        password = data.get("password")
        company_id = data.get("company_id")

        conn = get_db_connection()
        cursor = conn.cursor()

        sql = """
        INSERT INTO users (nickname, email, password, company_id)
        VALUES (%s, %s, %s, %s)
        """
        cursor.execute(sql, (nickname, email, password, company_id))
        conn.commit()
        conn.close()

        return jsonify({"message": "회원가입 성공"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500