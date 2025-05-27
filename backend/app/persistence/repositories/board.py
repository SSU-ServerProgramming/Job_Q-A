from sqlalchemy import or_

from .base import BaseRepository
from app.database.models.board import Board
from app.database.models.board_likes import BoardLikes


class BoardRepository(BaseRepository):
    def get_by_id(self, board_id: int) -> Board | None:
        """ID로 게시글을 조회합니다."""
        return self.session.query(Board).filter(Board.id == board_id).first()
    
    def get_by_user_id(self, user_id: int) -> list[Board]:
        """User ID로 게시글을 최신 생성순으로 조회합니다."""
        result = (
            self.session.query(Board)
            .filter(Board.user_id == user_id)
            .order_by(Board.created_at.desc())
        )
        return result
    
    def get_by_category_id(self, category_id: int, skip: int = 0, limit: int = 100) -> list[Board]:
        """Category ID로 게시글을 최신 생성순으로 조회합니다.(페이징)"""
        result = (
            self.session.query(Board)
            .filter(Board.category_id == category_id)
            .order_by(Board.created_at.desc())
            .offset(skip).limit(limit).all()
        )
        return result
    
    def get_by_keyword(self, keyword: str, skip: int = 0, limit: int = 100) -> list[Board]:
        """제목이나 본문에 키워드가 포함된 게시글을 최신 생성순으로 조회합니다.(페이징)"""
        result = (
            self.session.query(Board)
            .filter(or_(
                Board.title.like(f"%{keyword}%"),
                Board.content.like(f"%{keyword}%"))
            )
            .order_by(Board.created_at)
            .offset(skip)
            .limit(limit)
            .all()
        )
        return result

    def get_by_num_like(self, skip: int = 0, limit: int = 100) -> list[Board]:
        """좋아요 개수가 많은 순으로 정렬되어 게시글을 조회합니다(페이징)"""
        result = (
            self.session.query(Board)
            .order_by(Board.num_like.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )
        return result
    
    def get_by_num_comment(self, skip: int = 0, limit: int = 100) -> list[Board]:
        """좋아요 개수가 많은 순으로 정렬되어 게시글을 조회합니다(페이징)"""
        result = (
            self.session.query(Board)
            .order_by(Board.num_comment.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )
        return result
    
    def get_all_board(self, skip: int = 0, limit: int = 100) -> list[Board]:
        """최근 생성된 순으로 게시글을 조회합니다.(페이징)"""
        result = (
            self.session.query(Board)
            .order_by(Board.created_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )
        return result
    
    def create(self, board: Board) -> Board:
        """새로운 게시글(Board)을 생성합니다."""
        self.session.add(board)
        self.session.commit()
        return board
    
    def update(self, board: Board) -> Board:
        """기존 게시글을 업데이트 합니다."""
        self.session.merge(board)
        self.session.commit()
        return board
    
    def delete(self, board_id: int) -> None:
        """게시글을 삭제합니다."""
        board = self.get_by_id(board_id)
        if board:
            self.session.delete(board)
            self.session.commit()
