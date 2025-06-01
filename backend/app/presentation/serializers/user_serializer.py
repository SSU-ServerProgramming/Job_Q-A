def serial_user_to_dict_mypage(user_id, email, nickname, company_name) -> dict:
    return {
        "user_id": user_id,
        "email": email,
        "nickname": nickname,
        "company_name": company_name
    }

def serial_user_to_dict_company(user) -> dict:
    return {
        "user_id": user.id,
        "email": user.email,
        "company_id": user.company_id
    }