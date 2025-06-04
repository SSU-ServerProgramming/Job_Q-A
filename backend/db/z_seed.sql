SET NAMES utf8mb4;

INSERT INTO companies(id, name, domain)
VALUES
    (1, 'Naver', 'navercorp.com'),
    (2, 'Kakao', 'kakaocorp.com'),
    (3, 'Line', 'lineworks.com'),
    (4, 'example', 'example.com');

-- INSERT INTO users (nickname, email, password, company_id)
-- VALUES  
--     ('ssumisfree', 'ssumisfree@example.com', 'password1', 1),
--     ('woojin', 'woojinwork16@example.com', 'password2', 1),
--     ('rest-point', 'rest-point@example.com', 'password3', 1),
--     ('kim_tae_young', 'kim_tae_young@example.com', 'password4', 1);

INSERT INTO categories (name) 
VALUES
    ("정보기술(IT)"),
    ("의료/보건"),
    ("교육/연구"),
    ("금융/회계"),
    ("예술/디자인"),
    ("부동산"),
    ("정치/행정"),
    ("음악/악기"),
    ("유통/무역"),
    ("환경/에너지"),
    ("기타");

-- INSERT INTO boards (user_id, title, category_id, content)
-- VALUES
--     (1, '제목', 1, '내용');


-- INSERT INTO comments (user_id, board_id, content, parent_comment_id)
-- VALUES 
--     (1, 1, '댓글', NULL);
