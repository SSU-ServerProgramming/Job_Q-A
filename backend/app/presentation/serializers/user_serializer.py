from app.database.models.user import User


def serial_user_to_dict_mypage(user) -> dict:
    return {
        "user_id": user.id,
        "email": user.email,
        "nickname": user.nickname,
        "company_name": user.company.name if user.company else None
    }