SET NAMES utf8mb4;

INSERT INTO companies(name)
VALUES
    ('취준'),
    ('Naver'),
    ('Kakao'),
    ('Line');

INSERT INTO users (nickname, email, password, company_name)
VALUES  
    ('ssumisfree', 'ssumisfree@example.com', 'password1', "example"),
    ('woojin', 'woojinwork16@gmail.com', 'password2', "example"),
    ('rest-point', 'rest-point@example.com', 'password3', "example"),
    ('kim_tae_young', 'kim_tae_young@example.com', 'password4', "example");

INSERT INTO categories (name) 
VALUES
    ('IT/데이터'),
    ('인사/마케팅');

INSERT INTO boards (user_id, title, category_id, content)
VALUES
    (1, '제목', 1, '내용');


INSERT INTO comments (user_id, board_id, content, parent_comment_id)
VALUES 
    (1, 1, '댓글', NULL);