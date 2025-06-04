from app.database.models.comment import Comment


def serialize_comment(comment: Comment) -> dict:
    return {
        "comment_id": comment.id,
        "parent_comment_id": comment.parent_comment_id,
        "writer": comment.author.nickname,
        "like": comment.num_like,
        "content": comment.content
    }

def serialize_comment_detail(comment: Comment) -> dict:
    """게시글 상세 조회에서 사용(is_mine추가)"""
    return {
        "comment_id": comment.id,
        "parent_comment_id": comment.parent_comment_id,
        "writer": comment.author.nickname,
        "like": comment.num_like,
        "content": comment.content,
        "is_mine": comment.is_mine
    }

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
