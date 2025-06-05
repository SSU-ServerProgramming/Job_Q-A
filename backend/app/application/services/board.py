# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.board import BoardRepository
from app.persistence.repositories.comment import CommentRepository
from app.persistence.repositories.board_likes import BoardLikesRepository
from app.persistence.repositories.comment_like import CommentLikesRepository

from .base import BaseService

from app.database.models import Board
from app.database.models import Comment

import copy

class BoardService(BaseService):
    def get_all_boards(self, skip: int = 0, limit: int = 100) -> list[Board]:
        """모든 게시물을 반환합니다.(페이징)"""
        # try:
        repo = BoardRepository(self.session)
        return repo.get_all_boards(skip=skip, limit=limit)
        # except Persis
    
    def get_by_category_id(self, category_id, skip:int = 0, limit:int = 100) -> list[Board]:
        """카테고리별 모든 게시물을 반환합니다."""
        repo = BoardRepository(self.session)
        return repo.get_by_category_id(category_id=category_id, skip=skip, limit=limit)
    
    def get_by_num_like(self, skip:int = 0, limit:int = 100) -> list[Board]:
        """좋아요 개수가 많은 순으로 모든 게시물을 반환합니다."""
        repo = BoardRepository(self.session)
        return repo.get_by_num_like(skip=skip, limit=limit)
    
    def get_by_board_id(self, board_id:int):
        """board id에 대응되는 게시물을 반환합니다.
        현재 Board, Comment 객체에 동적으로 is_liked을 임시로 추가해두었습니다.
        """
        board_repo = BoardRepository(self.session)
        board_like_repo = BoardLikesRepository(self.session)
        comment_repo = CommentRepository(self.session)
        comment_like_repo = CommentLikesRepository(self.session)
        
        board = board_repo.get_by_id(board_id=board_id)
        comments = comment_repo.get_by_board_id(board_id=board_id)
        
        board_result = copy.deepcopy(board)
        comments_result = copy.deepcopy(comments)

        if board_like_repo.get_by_user_board_id(board.user_id, board.id) is not None:
            if board.user_id == (board_like_repo.get_by_user_board_id(board.user_id, board.id)).user_id:
                board_result.is_liked = True
            else:
                board_result.is_liked = False
        else:
            board_result.is_liked = False
    
        for c in comments_result:
            if comment_like_repo.get_by_user_comment_id(c.user_id, c.id) is not None:
                if c.user_id == (comment_like_repo.get_by_user_comment_id(c.user_id, c.id)).user_id:
                    c.is_liked = True
                else:
                    c.is_liked = False
            else:
                c.is_liked = False
            
        return board_result, comments_result

    def create_board(self, user_id:int, title:str, category_id:int, content:str):
        """새로운 게시글을 생성합니다."""
        new_board = Board(
            user_id = user_id,
            category_id = category_id,
            title = title,
            content = content,
            num_like = 0,
            num_comment = 0
        )
        repo = BoardRepository(self.session)
        result = repo.create(board=new_board)
        self.session.commit()
        return result
    
    def update_board(self, board_id:int, user_id:int, category_id:int, title:str, content:str) -> Board:
        """게시물을 수정합니다."""
        repo = BoardRepository(self.session)
        board = repo.get_by_id(board_id)
        board.category_id = category_id
        board.title = title
        board.content = content
        result = repo.update(board=board)
        self.session.commit()
        return result
    
    def delete_board(self, board_id: int) -> None:
        repo = BoardRepository(self.session)
        board = repo.get_by_id(board_id)
        if board is None:
            raise ValueError("게시물이 존재하지 않습니다.")
        repo.delete(board_id)
        self.session.commit()

    def add_like(self, user_id: int, board_id: int):
        """게시물에 좋아요를 추가합니다."""
        board_repo = BoardRepository(self.session)
        like_repo = BoardLikesRepository(self.session)

        board = board_repo.get_by_id(board_id)
        if board is None:
            raise ValueError("게시물이 존재하지 않습니다.")

        if like_repo.get_by_user_board_id(user_id, board_id):
            raise ValueError("이미 좋아요를 누른 게시물입니다.")

        like_repo.insert_like(user_id=user_id, board_id=board_id)

        board.num_like += 1
        self.session.commit()

    def delete_like(self, user_id: int, board_id: int) -> None:
        """게시물에 좋아요를 취소합니다."""
        board_repo = BoardRepository(self.session)
        like_repo = BoardLikesRepository(self.session)

        board = board_repo.get_by_id(board_id)
        if board is None:
            raise ValueError("게시물이 존재하지 않습니다.")

        like = like_repo.get_by_user_board_id(user_id=user_id, board_id=board_id)
        if not like:
            raise ValueError("좋아요 기록이 존재하지 않습니다.")

        like_repo.delete_like(user_id=user_id, board_id=board_id)
        board.num_like = max(0, board.num_like - 1)
        self.session.commit()

# 아직 오류 처리 안했음
