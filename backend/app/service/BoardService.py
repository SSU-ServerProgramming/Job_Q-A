from flask import jsonify
from ..model import BoardModel, CommentModel

def get_all_boards():
    return BoardModel.get_all_boards()

def create_board(data):
    required_fields = {'user_id', 'title', 'category_id'}
    missing_fields = required_fields - set(data.keys())
    
    if missing_fields:
        raise ValueError(f"필수 항목이 누락되었습니다: {', '.join(missing_fields)}")
    
    return BoardModel.create_board(
        data['user_id'],
        data['title'],
        data['category_id'],
        data.get('content')
    )

def delete_board(user_id, board_id, writer_id):
        if writer_id != user_id:
            raise PermissionError("게시글 삭제 권한이 없습니다.")
        
        return BoardModel.delete_board(board_id)
        
def get_board(board_id, category_id):
    board = BoardModel.get_board(board_id, category_id)
    board['date'] = board['date'].strftime('%Y-%m-%d %H:%M:%S')
    
    comments = CommentModel.get_all_comments(board_id)
    
    for comment in comments:
        comment['date'] = comment['date'].strftime('%Y-%m-%d %H:%M:%S')
    
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
    
    return {
        "board": board,
        "comments": comment_tree,
    }

def update_board(board_id, user_id, data, writer_id, category_id):
    if user_id != writer_id:
        raise PermissionError("게시글 수정 권한이 없습니다.")
    
    updateable_fields = ['title', 'content', 'category_id']
    update_data = {k: v for k, v in data.items() if k in updateable_fields and v is not None}
    
    if not update_data:
        return BoardModel.get_board(board_id, category_id)
    
    BoardModel.update_board(board_id, update_data, category_id)
    return BoardModel.get_board(board_id, category_id)

def check_board_exists(board_id, category_id):
    result = BoardModel.check_board_exists(board_id, category_id)
    if not result:
        raise ValueError("존재하지 않는 게시글입니다.")
    return result