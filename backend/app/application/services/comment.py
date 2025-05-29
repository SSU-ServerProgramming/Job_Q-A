from app.persistence.repositories.comment import CommentRepository
from app.persistence.repositories.board import BoardRepository
from app.database.models.comment import Comment
from .base import BaseService


class CommentService(BaseService):
    # 사용자가 작성한 댓글 목록 조회
    def get_by_user(self, user_id: int) -> list[dict]:
        repo = CommentRepository(self.session)
        comments = repo.get_by_user(user_id)
        return [c.to_dict_mypage() for c in comments]
    
    # 댓글 생성
    def create_comment(self, data: dict) -> Comment:
        comment = Comment(
            user_id=data["user_id"],
            board_id=data["board_id"],
            content=data["content"],
            parent_comment_id=data.get("parent_comment_id")
        )
        created_comment = CommentRepository(self.session).create(comment)
        
        # 게시글의 댓글 수 증가
        board_repo = BoardRepository(self.session)
        board = board_repo.get_by_id(data["board_id"])
        if board:
            board.num_comment += 1
            board_repo.update(board)
        
        return created_comment
    
    def get_comment_by_id(self, comment_id: int) -> Comment | None:
        repo = CommentRepository(self.session)
        return repo.get_by_id(comment_id)
    
    # 댓글 수정
    def update_comment(self, comment_id: int, data: dict) -> Comment | None:
        repo = CommentRepository(self.session)
        comment = repo.get_by_id(comment_id)
        if comment is None or comment.user_id != data["user_id"]:
            return None
        comment.content = data["content"]
        return repo.update(comment)
    
    # 댓글 삭제
    def delete_comment(self, comment_id: int, user_id: int) -> bool:
        repo = CommentRepository(self.session)
        comment = repo.get_by_id(comment_id)
        if comment is None or comment.user_id != user_id:
            return False
        
        # 게시글의 댓글 수 감소
        board_repo = BoardRepository(self.session)
        board = board_repo.get_by_id(comment.board_id)
        if board:
            board.num_comment -= 1
            board_repo.update(board)
        
        repo.delete(comment)
        return True
    
    # 댓글 좋아요
    def like_comment(self, comment_id: int, user_id: int) -> dict | None:
        repo = CommentRepository(self.session)
        comment = repo.get_by_id(comment_id)
        if comment is None or repo.has_user_liked(comment_id, user_id):
            return None
        updated = repo.add_like(comment, user_id)
        return {"comment_id": updated.id, "like": updated.num_like}

    # 댓글 좋아요 취소
    def unlike_comment(self, comment_id: int, user_id: int) -> dict | None:
        repo = CommentRepository(self.session)
        comment = repo.get_by_id(comment_id)
        if comment is None:
            return None
        updated = repo.remove_like(comment, user_id)
        if updated is None:
            return None
        return {"comment_id": updated.id, "like": updated.num_like}