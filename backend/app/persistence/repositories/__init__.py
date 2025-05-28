from .user import UserRepository
from .board import BoardRepository
from .board_likes import BoardLikesRepository
from .category import CategoryRepository
from .comment import CommentRepository

__all__ = [UserRepository, BoardRepository, BoardLikesRepository, CategoryRepository, CommentRepository]