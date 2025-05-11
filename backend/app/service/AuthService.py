from ..model import UserModel
import bcrypt

def register(data):
    email = data['email']
    password = data['password']
    nickname = data['nickname']
    company_id = data['company_id']
    
    if UserModel.find_by_email(email):
        raise ValueError("이미 존재하는 이메일입니다.")
    
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
    
    UserModel.create_user(nickname, email, hashed_password, company_id)
    
    return {"message": "회원가입 성공"}

def login(data):
    email = data['email']
    password = data['password']
    
    user = UserModel.find_by_email(email)
    if not user:
        raise ValueError("존재하지 않는 사용자입니다.")

    if not bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
        raise ValueError("비밀번호가 일치하지 않습니다.")

    return {
        "message": "로그인 성공",
        "nickname": user['nickname'],
        "email": user['email'],
        "user_id": user['user_id']
    }