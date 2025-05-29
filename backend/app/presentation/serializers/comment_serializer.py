from app.database.models.comment import Comment


def serial_comment_to_dict(comment: Comment) -> dict:
    return {
        "board_id": comment.board_id,
        "comment_id": comment.id,
        "content": comment.content,
        "date": comment.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        "user_id": comment.user_id
    }

def serial_comment_to_dict_mypage(comment: Comment) -> dict:
    return {
        "board_id": comment.board_id,
        "comment_id": comment.id,
        "content": comment.content,
        "date": comment.updated_at.strftime("%Y-%m-%d %H:%M:%S")
    }