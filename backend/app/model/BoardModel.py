from flask import jsonify
from ..common import db
from datetime import datetime

def get_all_boards():
    conn = db.get_db_connection()
    cursor = conn.cursor()
        
    sql = """
    SELECT 
        b.board_id,
        b.title,
        b.content,
        b.date,
        b.like,
        b.comment_count,
        u.nickname as writer,
        c.name as category_name
    FROM boards b
    LEFT JOIN users u ON b.user_id = u.user_id
    LEFT JOIN categories c ON b.category_id = c.category_id
    ORDER BY b.date DESC
    """
    
    cursor.execute(sql)
    boards = cursor.fetchall()
    
    for board in boards:
        board['date'] = board['date'].strftime('%Y-%m-%d %H:%M:%S')
    
    conn.close()
    
    return boards

def create_board(user_id, title, category_id, content): 
    conn = db.get_db_connection()
    cursor = conn.cursor()
    
    sql = """
    INSERT INTO boards (user_id, title, category_id, content, date)
    VALUES (%s, %s, %s, %s, %s)
    """
    
    current_time = datetime.now()
    
    cursor.execute(sql, (
        user_id,
        title,
        category_id,
        content,
        current_time
    ))
    
    conn.commit()
    board_id = cursor.lastrowid
    
    sql = """
    SELECT 
        b.board_id,
        b.title,
        b.content,
        b.date,
        b.like,
        b.comment_count,
        u.nickname as author_name,
        c.name as category_name
    FROM boards b
    LEFT JOIN users u ON b.user_id = u.user_id
    LEFT JOIN categories c ON b.category_id = c.category_id
    WHERE b.board_id = %s
    """
    
    cursor.execute(sql, (board_id,))
    new_board = cursor.fetchone()
    new_board['date'] = new_board['date'].strftime('%Y-%m-%d %H:%M:%S')
    
    conn.close()
    
    return new_board

def get_board(board_id, category_id):
    conn = db.get_db_connection()
    cursor = conn.cursor()
        
    sql = """
    SELECT 
        b.board_id,
        b.title,
        b.content,
        b.date,
        b.like,
        b.comment_count,
        b.user_id,
        u.nickname as writer,
        c.name as category_name,
        comp.name as company_name
    FROM boards b
    LEFT JOIN users u ON b.user_id = u.user_id
    LEFT JOIN categories c ON b.category_id = c.category_id
    LEFT JOIN companies comp ON u.company_id = comp.company_id
    WHERE b.board_id = %s AND b.category_id = %s
    """
    
    cursor.execute(sql, (board_id, category_id))
    board = cursor.fetchone()
    conn.close()

    if not board:
        raise ValueError("존재하지 않는 게시글입니다.")
    
    board['date'] = board['date'].strftime('%Y-%m-%d %H:%M:%S')
    
    return board

def delete_board(board_id):
    conn = db.get_db_connection()
    cursor = conn.cursor()
    delete_sql = "DELETE FROM boards WHERE board_id = %s"
    cursor.execute(delete_sql, (board_id,))
    conn.commit()
    conn.close()
    
    return {
        "message": "게시글이 성공적으로 삭제되었습니다."
    }

def update_board(board_id, update_data, category_id):
    conn = db.get_db_connection()
    cursor = conn.cursor()
    
    # date 필드는 업데이트하지 않음
    if 'date' in update_data:
        del update_data['date']
    
    set_clause = ", ".join([f"{field} = %s" for field in update_data.keys()])
    update_sql = f"""
    UPDATE boards 
    SET {set_clause}
    WHERE board_id = %s AND category_id = %s
    """
    
    values = list(update_data.values())
    values.append(board_id)
    values.append(category_id)
    
    cursor.execute(update_sql, values)
    conn.commit()
    conn.close()

def check_board_exists(board_id, category_id):
    conn = db.get_db_connection()
    cursor = conn.cursor()
        
    sql = """
    SELECT user_id
    FROM boards 
    WHERE board_id = %s AND category_id = %s
    """
    
    cursor.execute(sql, (board_id, category_id))
    result = cursor.fetchone()
    conn.close()

    return result