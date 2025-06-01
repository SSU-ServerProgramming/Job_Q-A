from app.database.models.user import User


def serial_user_to_dict_mypage(user, company) -> dict:
    return {
        "user_id": user.id,
        "email": user.email,
        "nickname": user.nickname,
        "company_name": company.company_name,
        # "company_id": user.company_id,
    }

def serial_user_to_dict_company(user: User) -> dict:
    return {
        "user_id": user.id,
        "email": user.email,
        "company_id": user.company_id
    }