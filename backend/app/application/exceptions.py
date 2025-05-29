# Application 전역 에러
class ApplicationError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Appliacation Error")

# JWT
class MissingdTokenError(Exception):
    def __init__(self, exception):
        self.exception = exception
        super().__init__("Token Missing")

class InvalidTokenError(Exception):
    def __init__(self, exception):
        self.exception = exception
        super().__init__("Token Invalid")

class ExpiredTokenError(Exception):
    def __init__(self, exception):
        self.exception = exception
        super().__init__("Token Expired")

# User
class UserNotFoundError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("User Not Found")

class DuplicateEmailError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Email is Duplicated")

class MissingCredentialsError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("ID/PW is Missing")

class InvalidCredentialsError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("ID/PW is Invalid")

# 자신이 쓴 게시물, 댓글이 아닐때
class PermisionError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Permission Denied")


# Board
class BoardNotFoundError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Board Not Found")

class BoardLikedError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Duplicated Like Operation(Board)")

# Comment
class CommentNotFoundError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Comment Not Found")

class CommentLikedError(Exception):
    def __init__(self, exception:Exception | None = None):
        self.exception = exception
        self.super().__init__("Duplicated Like Operation(Comment)")



