from ..common import db

def get_all_comments(board_id):
    conn = db.get_db_connection()
    cursor = conn.cursor()

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
    conn.close()
    return comments