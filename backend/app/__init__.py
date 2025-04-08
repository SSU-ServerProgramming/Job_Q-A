# Flask, MySQL이 Docker위에서 잘 작동하는지 테스트 하기 위한 간단한 코드입니다.
# ./db/init.sql, seed.sql과 같은 파일들도 실제 프로젝트와 무관합니다.


import os
from flask import Flask, jsonify
import pymysql


app = Flask(__name__)

@app.route("/")
def test():
    return "Docker Container Test"

def get_db_connection():
    return pymysql.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
        database=os.environ.get("DB_NAME"),
        port=3306,
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route("/users")
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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)