# How to Set Up On Docker?
> Docker container에서 개발환경을 구성하기 위한 가이드

### 1. Tech Stack
    iOS : swiftUI
    Backend : Flask 3.1 / Python 3.10
    DataBase : MySQL 8.0

### 2. Install Docker on your computer
- [www.docker.com](https://www.docker.com/) : 도커 공식 홈페이지 방문 후, 운영체제에 맞는 Docker Desktop 설치

### 3. Clone Our Repo
```bash
git clone https://github.com/SSU-ServerProgramming/Job_Q-A.git
cd ./Job_Q-A
``` 

### 4. Edit **.env** files
- [.env.backend](https://github.com/SSU-ServerProgramming/Job_Q-A/backend/docker/blob/main/.env.backend.example) : Flask 설정을 위한 설정파일
- [.env.db](https://github.com/SSU-ServerProgramming/Job_Q-A/backend/docker/blob/main/.env.db.example) : MySQL 설정을 위한 설정파일
1. .env.backend / .env.db 생성
    ```bash
    cd Job_Q-A/backend/docker
    cp ./.env.backend.example .env.backend
    cp ./.env.db.example .env.db
    ```
2. .env 파일 수정
    ```
    // .env.backend
    FLASK_APP=__init__.py
    FLASK_DEBUG=1
    DB_HOST=db
    DB_NAME=testdb
    DB_USER=EDIT_HERE // 수정(.env.db/MYSQL_USER과 같아야함)
    DB_PASSWORD=EDIT_HERE // 수정(.env.db/MYSQL_PASSWORD와 같아야함)
    ```
    ```
    // .env.db
    MYSQL_DATABASE=test_db
    MYSQL_ROOT_PASSWORD=EDIT_HERE // 수정
    MYSQL_USER=EDIT_HERE // 수정
    MYSQL_PASSWORD=EDIT_HERE //수정
    ```

### 5. Docker Container Build & Run
- **docker compose up --build** : 처음 실행할때, requirements.txt, .env등의 파일이 변경되었을때(docker compose down도 같이)
- **docker compose up** : 새로 빌드하지 않고, 실행할때


### 6. Result
- 웹 브라우저에서 **localhost:8000**에 접속해 결과가 나오는지 확인!
- **localhost:8000** : Docker Container Test 문구가 나옴.
- **localhost:8000/users** : db에 있는 더미데이터가 나옴