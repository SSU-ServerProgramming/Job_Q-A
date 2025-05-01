SET NAMES utf8mb4;

INSERT INTO companies(name)
VALUES
    ('취준'),
    ('Naver'),
    ('Kakao'),
    ('Line');

INSERT INTO categories(name)
VALUES
    ('IT/개발'),
    ('경영/기획'),
    ('마케팅'),
    ('디자인'),
    ('데이터'),
    ('금융'),
    ('인사/HR'),
    ('영업');

INSERT INTO users (nickname, email, password, company_id)
VALUES  
    ('ssumisfree', 'ssumisfree@example.com', 'password1', 1),
    ('woojin', 'woojinwork16@gmail.com', 'password2', 2),
    ('rest-point', 'rest-point@example.com', 'password3', 3),
    ('kim_tae_young', 'kim_tae_young@example.com', 'password4', 4);