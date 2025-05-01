from flask import Blueprint, jsonify, request
from ..database import get_db_connection
from datetime import datetime

board = Blueprint('board', __name__)

@board.route("/", methods=["GET"])
def get_all_boards():
    try:
        conn = get_db_connection()
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
        
        return jsonify({
            "status": "success",
            "data": boards,
            "count": len(boards)
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/", methods=["POST"])
def create_board():
    try:
        data = request.get_json()
        
        required_fields = ['user_id', 'title', 'category_id']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    "status": "error",
                    "message": f"필수 항목이 누락되었습니다: {field}"
                }), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        sql = """
        INSERT INTO boards (user_id, title, category_id, content, date)
        VALUES (%s, %s, %s, %s, %s)
        """
        
        current_time = datetime.now()
        
        cursor.execute(sql, (
            data['user_id'],
            data['title'],
            data['category_id'],
            data['content'],
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
        
        return jsonify({
            "status": "success",
            "message": "게시글이 성공적으로 작성되었습니다.",
            "data": new_board
        }), 201
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500