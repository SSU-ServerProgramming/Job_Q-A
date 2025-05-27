# Application(service)에서는 주요 오류처리 로직이 동반되어야 합니다.
from app.persistence.repositories.board import BoardRepository
from app.persistence.repositories.board_likes import BoardLikesRepository
from .base import BaseService

from app.database.models import Board


class BoardService(BaseService):
    def get_all_board(self, skip: int = 0, limit: int = 100):
        """모든 게시물을 반환합니다.(페이징)"""
        repo = BoardRepository(self.session)
        return repo.get_all_board(skip=skip, limit=limit)
    
    def get_by_category_id(self, category_id, skip:int = 0, limit:int = 100):
        """카테고리별 모든 게시물을 반환합니다."""
        repo = BoardRepository(self.session)
        return repo.get_by_category_id(category_id=category_id, skip=skip, limit=limit)
    
    def get_by_num_like(self, skip:int = 0, limit:int = 100):
        """좋아요 개수가 많은 순으로 모든 게시물을 반환합니다."""
        repo = BoardRepository(self.session)
        return repo.get_by_num_like(skip=skip, limit=limit)
    
    def get_by_board_id(self, board_id:int):
        """board id에 대응되는 게시물을 반환합니다."""
        repo = BoardRepository(self.session)
        board = repo.get_by_id(board_id=board_id)
        return board
        # if not board:
        #     raise Exception("Board Not found")
        # else:
        #     return board

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
        return repo.create(board=new_board)
    
    def update_board(self, board_id:int, user_id:int, category_id:int, title:str, content:str):
        """게시물을 수정합니다."""
        repo = BoardRepository(self.session)
        board = repo.get_by_id(board_id)
        board.category_id = category_id
        board.title = title
        board.content = content
        return repo.update(board=board)
    
    def delete_board(self, board_id: int) -> None:
        repo = BoardRepository(self.session)
        board = repo.get_by_id(board_id)
        if board is None:
            raise ValueError("게시물이 존재하지 않습니다.")
        repo.delete(board_id)

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
        # self.session.commit()

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
        # self.session.commit()

# 아직 오류 처리 안했음