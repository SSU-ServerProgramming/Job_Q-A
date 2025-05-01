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

@board.route("/<int:board_id>", methods=["DELETE"])
def delete_board(board_id):
    try:
        user_id = request.args.get('user_id', type=int)
        if not user_id:
            return jsonify({
                "status": "error",
                "message": "사용자 ID가 필요합니다."
            }), 400

        conn = get_db_connection()
        cursor = conn.cursor()
        
        check_sql = """
        SELECT user_id 
        FROM boards 
        WHERE board_id = %s
        """
        cursor.execute(check_sql, (board_id,))
        board = cursor.fetchone()
        
        if not board:
            conn.close()
            return jsonify({
                "status": "error",
                "message": "존재하지 않는 게시글입니다."
            }), 404
            
        if board['user_id'] != user_id:
            conn.close()
            return jsonify({
                "status": "error",
                "message": "게시글 삭제 권한이 없습니다."
            }), 403
        
        delete_sql = "DELETE FROM boards WHERE board_id = %s"
        cursor.execute(delete_sql, (board_id,))
        conn.commit()
        conn.close()
        
        return jsonify({
            "status": "success",
            "message": "게시글이 성공적으로 삭제되었습니다."
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/<int:board_id>", methods=["GET"])
def get_board_detail(board_id):
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
            b.user_id,
            u.nickname as writer,
            c.name as category_name,
            comp.name as company_name
        FROM boards b
        LEFT JOIN users u ON b.user_id = u.user_id
        LEFT JOIN categories c ON b.category_id = c.category_id
        LEFT JOIN companies comp ON u.company_id = comp.company_id
        WHERE b.board_id = %s
        """
        
        cursor.execute(sql, (board_id,))
        board = cursor.fetchone()
        
        if not board:
            conn.close()
            return jsonify({
                "status": "error",
                "message": "존재하지 않는 게시글입니다."
            }), 404
        
        board['date'] = board['date'].strftime('%Y-%m-%d %H:%M:%S')
        
        comment_sql = """
        SELECT 
            c.comment_id,
            c.content,
            c.date,
            c.like,
            c.parent_comment_id,
            u.nickname as writer,
            comp.name as company_name
        FROM comments c
        LEFT JOIN users u ON c.user_id = u.user_id
        LEFT JOIN companies comp ON u.company_id = comp.company_id
        WHERE c.board_id = %s
        ORDER BY 
            CASE WHEN c.parent_comment_id = 0 THEN c.comment_id ELSE c.parent_comment_id END,
            c.date ASC
        """
        
        cursor.execute(comment_sql, (board_id,))
        comments = cursor.fetchall()
        
        for comment in comments:
            comment['date'] = comment['date'].strftime('%Y-%m-%d %H:%M:%S')
        
        conn.close()
        
        comment_tree = []
        comment_map = {}
        
        for comment in comments:
            comment['replies'] = []
            comment_map[comment['comment_id']] = comment
            
            if comment['parent_comment_id'] == 0:
                comment_tree.append(comment)
            else:
                parent = comment_map.get(comment['parent_comment_id'])
                if parent:
                    parent['replies'].append(comment)
        
        return jsonify({
            "status": "success",
            "data": {
                "board": board,
                "comments": comment_tree
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@board.route("/<int:board_id>", methods=["PUT"])
def update_board(board_id):
    try:
        data = request.get_json()
        user_id = data.get('user_id')
        
        if not user_id:
            return jsonify({
                "status": "error",
                "message": "사용자 ID가 필요합니다."
            }), 400
            
        updateable_fields = ['title', 'content', 'category_id']
        update_data = {k: v for k, v in data.items() if k in updateable_fields and v is not None}
            
        conn = get_db_connection()
        cursor = conn.cursor()
        
        check_sql = """
        SELECT user_id 
        FROM boards 
        WHERE board_id = %s
        """
        cursor.execute(check_sql, (board_id,))
        board = cursor.fetchone()
        
        if not board:
            conn.close()
            return jsonify({
                "status": "error",
                "message": "존재하지 않는 게시글입니다."
            }), 404
            
        if board['user_id'] != user_id:
            conn.close()
            return jsonify({
                "status": "error",
                "message": "게시글 수정 권한이 없습니다."
            }), 403
            
        if update_data:
            set_clause = ", ".join([f"{field} = %s" for field in update_data.keys()])
            update_sql = f"""
            UPDATE boards 
            SET {set_clause}
            WHERE board_id = %s
            """
            
            values = list(update_data.values())
            values.append(board_id)
            
            cursor.execute(update_sql, values)
            conn.commit()
        
        select_sql = """
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
        WHERE b.board_id = %s
        """
        
        cursor.execute(select_sql, (board_id,))
        updated_board = cursor.fetchone()
        updated_board['date'] = updated_board['date'].strftime('%Y-%m-%d %H:%M:%S')
        
        conn.close()
        
        return jsonify({
            "status": "success",
            "message": "게시글이 성공적으로 수정되었습니다.",
            "data": updated_board
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500