from app.database.models.board import Board

def serial_board_to_dict(board: Board) -> dict:
    return {
        "board_id": board.id,
        "category_name": board.category.name if board.category else None,
        "comment_count": board.num_comment,
        "content": board.content,
        "date": board.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        "like": board.num_like,
        "title": board.title,
        "writer": board.user_id
    }