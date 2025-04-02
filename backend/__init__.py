from flask import Flask, jsonify
import pymysql


app = Flask(__name__)

@app.route("/")
def test():
    return "Docker Container TEST"

def get_db_connection():
    return pymysql.connect(
        host="db",
        user="woojin",
        password="12345678*",
        database="test_db",
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