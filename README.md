# 잡잡한 세상 (Job Q&A)
> 숭실대학교 서버프로그래밍 3조 (김수민, 김우진, 김준석, 김태영)

### 1. Summary


### 2. Features

### 3. How to RUN
> docs/backend/setup.md
- [setup.md](https://github.com/SSU-ServerProgramming/Job_Q-A/blob/main/docs/backend/setup.md) 를 참고해주세요.

### 4. Tech Stack
- **iOS** : Swift
- **Back-End** : Python Flask
- **DataBase** : MySQL


### 5. Project Structure
Job_Q-A/<br>
&nbsp;&nbsp;&nbsp;├─ [/docs](https://github.com/SSU-ServerProgramming/Job_Q-A/tree/main/docs) : 교수자 제출용, 개발 문서 등<br>
&nbsp;&nbsp;&nbsp;├─ [/ios](https://github.com/SSU-ServerProgramming/Job_Q-A/tree/main/ios) : iOS souce code<br>
&nbsp;&nbsp;&nbsp;├─ [/backend](https://github.com/SSU-ServerProgramming/Job_Q-A/tree/main/backend) : backend(+db) souce code <br>
&nbsp;&nbsp;&nbsp;├─ README.md
```
backend/
├── docker/
├── db/
├── config/
├── wsgi.py
├── manage.py
├── app/
│   ├── __init__.py
│   ├── presentation/           # 1. Presentation(Flask route)
│   │   ├── __init__.py
│   │   ├── jwt.py
│   │   ├── response.py
│   │   ├── routes/
│   │   └── serializers/
│   │
│   ├── application/            # 2. Application(Service)
│   │   ├── __init__.py
│   │   └── services/
│   │
│   ├── persistence/            # 3. Persistence(Repository)
│   │   ├── __init__.py
│   │   └── repositories/
│   │
│   ├── database/               # 4. Database(ORM)
│   │   ├── __init__.py 
│   │   ├── session.py 
│   │   └── models/
│   │
│   └── config.py
├── requirements.txt
└── README.md
```