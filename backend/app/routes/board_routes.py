from flask import Blueprint, jsonify, request
from ..database import get_db_connection

board = Blueprint('board', __name__)

@board.route("/boards", methods=["GET"])
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
            u.nickname as author_name,
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