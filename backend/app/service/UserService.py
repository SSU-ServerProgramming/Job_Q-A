from ..model import UserModel

def get_all_users():
    return UserModel.get_users()