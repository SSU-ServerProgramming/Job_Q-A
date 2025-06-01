from app.database.models.user import User


def serial_user_to_dict_mypage(user) -> dict:
    return {
        "user_id": user.id,
        "email": user.email,
        "nickname": user.nickname,
        "company_name": user.company_name or "취준생"
    }

def serial_user_to_dict_company(user: User) -> dict:
    return {
        "user_id": user.id,
        "email": user.email,
        "company_name": user.company_name or "취준생"
    }