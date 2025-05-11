from ..common import db

def find_by_email(email):
    conn = db.get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    user = cursor.fetchone()
    conn.close()
    return user

def create_user(nickname, email, hashed_password, company_id):
    conn = db.get_db_connection()
    cursor = conn.cursor()
    
    sql = """
    INSERT INTO users (nickname, email, password, company_id)
    VALUES (%s, %s, %s, %s)
    """
    cursor.execute(sql, (nickname, email, hashed_password, company_id))
    conn.commit()
    conn.close()

def get_users():
    conn = db.get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users;")
    users = cursor.fetchall()
    conn.close()
    return users