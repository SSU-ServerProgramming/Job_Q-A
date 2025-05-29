SET NAMES utf8mb4;
-- companies table
CREATE TABLE IF NOT EXISTS companies (
  id       INT NOT NULL AUTO_INCREMENT,
  name     VARCHAR(45) NOT NULL,
  domain   VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- users table
CREATE TABLE IF NOT EXISTS users (
  id             INT NOT NULL AUTO_INCREMENT,
  email          VARCHAR(45) NOT NULL,
  nickname       VARCHAR(45) NOT NULL,
  password       VARCHAR(200) NOT NULL,
  company_id     INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email           (email),
  KEY        idx_users_company_id     (company_id),
  CONSTRAINT fk_users_company_id
    FOREIGN KEY (company_id)
    REFERENCES companies (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- categories table
CREATE TABLE IF NOT EXISTS categories (
  id       INT NOT NULL AUTO_INCREMENT,
  name     VARCHAR(45) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_categories_name      (name)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

-- boards table
CREATE TABLE IF NOT EXISTS boards (
  id               INT NOT NULL AUTO_INCREMENT,
  user_id          INT NOT NULL,
  category_id      INT NOT NULL,
  title            VARCHAR(45) NOT NULL,
  content          VARCHAR(2000) DEFAULT NULL,
  num_like         INT NOT NULL DEFAULT 0,
  num_comment      INT NOT NULL DEFAULT 0,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY        idx_boards_user_id      (user_id),
  KEY        idx_boards_category_id  (category_id),
  CONSTRAINT fk_boards_user
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_boards_category
    FOREIGN KEY (category_id)
    REFERENCES categories (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- comments table
CREATE TABLE IF NOT EXISTS comments (
  id                  INT NOT NULL AUTO_INCREMENT,
  user_id             INT NOT NULL,
  board_id            INT NOT NULL,
  parent_comment_id   INT NULL,
  content             VARCHAR(200) NOT NULL,
  num_like            INT NOT NULL DEFAULT 0,
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY        idx_comments_user_id   (user_id),
  KEY        idx_comments_board_id  (board_id),
  CONSTRAINT fk_comments_user
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_comments_board
    FOREIGN KEY (board_id)
    REFERENCES boards (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_comments_parent
    FOREIGN KEY (parent_comment_id)
    REFERENCES comments (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;
-- board_likes table
CREATE TABLE IF NOT EXISTS board_likes (
  user_id   INT NOT NULL,
  board_id  INT NOT NULL,

  PRIMARY KEY (user_id, board_id),
  KEY idx_board_likes_user_id (user_id),
  KEY idx_board_likes_board_id (board_id),

  CONSTRAINT fk_board_likes_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_board_likes_board FOREIGN KEY (board_id)
    REFERENCES boards (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- comment_likes table
CREATE TABLE IF NOT EXISTS comment_likes (
  user_id     INT NOT NULL,
  comment_id  INT NOT NULL,

  PRIMARY KEY (user_id, comment_id),
  KEY idx_comment_likes_user_id (user_id),
  KEY idx_comment_likes_comment_id (comment_id),

  CONSTRAINT fk_comment_likes_user FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_comment_likes_comment FOREIGN KEY (comment_id)
    REFERENCES comments (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;


