SET NAMES utf8mb4;

INSERT INTO companies(id, name, domain)
VALUES
    (1, 'Naver', 'navercorp.com'),
    (2, 'Kakao', 'kakaocorp.com'),
    (3, 'Line', 'lineworks.com');
    (4, 'example', 'example.com'),

-- INSERT INTO users (nickname, email, password, company_id)
-- VALUES  
--     ('ssumisfree', 'ssumisfree@example.com', 'password1', 1),
--     ('woojin', 'woojinwork16@example.com', 'password2', 1),
--     ('rest-point', 'rest-point@example.com', 'password3', 1),
--     ('kim_tae_young', 'kim_tae_young@example.com', 'password4', 1);

INSERT INTO categories (name) 
VALUES
    ("IT/데이터"),
    ("사진/촬영"),
    ("인문학/독서"),
    ("여행"),
    ("스포츠"),
    ("문화/예술"),
    ("언어/외국어"),
    ("음악/악기"),
    ("댄스"),
    ("봉사활동"),
    ("기타");

-- INSERT INTO boards (user_id, title, category_id, content)
-- VALUES
--     (1, '제목', 1, '내용');


-- INSERT INTO comments (user_id, board_id, content, parent_comment_id)
-- VALUES 
--     (1, 1, '댓글', NULL);