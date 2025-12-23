-- =========================================================
-- Pizza Eat Ho Full DB Script
-- Schema: pizzaitho
-- MySQL
-- =========================================================

DROP DATABASE IF EXISTS pizzaitho;
CREATE DATABASE pizzaitho;
USE pizzaitho;

-- =========================================================
-- 1. USER / ADMIN
-- =========================================================

CREATE TABLE USER (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    id VARCHAR(20) NOT NULL UNIQUE,
    pw VARCHAR(100) NOT NULL,
    name VARCHAR(50),
    stamp INT DEFAULT 0
);

CREATE TABLE ADMIN (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    id VARCHAR(20) NOT NULL UNIQUE,
    pw VARCHAR(100) NOT NULL,
    name VARCHAR(50)
);

-- =========================================================
-- 2. PRODUCT / DOUGH / TOPPING
-- =========================================================

CREATE TABLE PRODUCT (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    base_price INT NOT NULL
);

CREATE TABLE DOUGH (
    dough_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    extra_price INT DEFAULT 0
);

CREATE TABLE CRUST (
    crust_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    extra_price INT DEFAULT 0
);

CREATE TABLE TOPPING (
    topping_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    price INT NOT NULL
);

CREATE TABLE PRODUCT_DEFAULT_TOPPING (
    product_id INT NOT NULL,
    topping_id INT NOT NULL,
    PRIMARY KEY (product_id, topping_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id),
    FOREIGN KEY (topping_id) REFERENCES TOPPING(topping_id)
);

-- =========================================================
-- 3. ORDER TABLES
-- =========================================================

CREATE TABLE ORDERS (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_table VARCHAR(10),
    order_time DATETIME DEFAULT NOW(),
    status ENUM('RECEIVED', 'COOKING', 'DONE') DEFAULT 'RECEIVED',
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE ORDER_DETAIL (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    dough_id INT NOT NULL,
    crust_id INT NOT NULL,
    quantity INT DEFAULT 1,
    unit_price INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id),
    FOREIGN KEY (dough_id) REFERENCES DOUGH(dough_id)
);

CREATE TABLE ORDER_DETAIL_TOPPING (
    order_detail_id INT NOT NULL,
    topping_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_detail_id, topping_id),
    FOREIGN KEY (order_detail_id) REFERENCES ORDER_DETAIL(order_detail_id),
    FOREIGN KEY (topping_id) REFERENCES TOPPING(topping_id)
);

-- =========================================================
-- 4. COMMENT (토핑 스냅샷 포함)
-- =========================================================

CREATE TABLE COMMENT (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    order_detail_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

-- =========================================================
-- 5. INITIAL DATA
-- =========================================================

-- USERS
INSERT INTO USER (id, pw, name, stamp) VALUES
('id01', 'pw01', '홍길동', 1),
('id02', 'pw02', '김철수', 3);

-- ADMIN
INSERT INTO ADMIN (id, pw, name) VALUES
('admin', 'adminpw', '매장관리자');

-- PRODUCTS
INSERT INTO PRODUCT (name, base_price) VALUES
('포테이토 피자', 11000),
('불고기 피자', 12000),
('페퍼로니 피자', 12000),
('콤비네이션 피자', 12500),
('커스텀 피자', 10000);

-- DOUGH
INSERT INTO DOUGH (name, extra_price) VALUES
('오리지널', 0),
('씬 도우', 1500),
('통밀 도우', 2000);

INSERT INTO CRUST (name, extra_price) VALUES
('없음', 0),
('치즈 크러스트', 3000),
('고구마 크러스트', 3000);


-- TOPPING (12종)
INSERT INTO TOPPING (name, price) VALUES
('감자', 1200),
('베이컨', 1500),
('양파', 500),
('버섯', 600),
('올리브', 700),
('콘옥수수', 600),
('피망', 600),
('페퍼로니', 1500),
('불고기', 2000),
('소시지', 1200),
('할라피뇨', 700),
('파인애플', 800);

-- =========================================================
-- 6. DEFAULT TOPPINGS
-- =========================================================

-- 포테이토 피자
INSERT INTO PRODUCT_DEFAULT_TOPPING VALUES
(1,1),(1,2),(1,3),(1,4),(1,6);

-- 불고기 피자
INSERT INTO PRODUCT_DEFAULT_TOPPING VALUES
(2,9),(2,3),(2,4),(2,7);

-- 페퍼로니 피자
INSERT INTO PRODUCT_DEFAULT_TOPPING VALUES
(3,8),(3,5),(3,3);

-- 콤비네이션 피자
INSERT INTO PRODUCT_DEFAULT_TOPPING VALUES
(4,10),(4,3),(4,4),(4,5),(4,7);

-- =========================================================
-- 7. EXAMPLE ORDERS
-- =========================================================

-- 주문 1: id01 → 불고기 피자 + 올리브 추가
INSERT INTO ORDERS (user_id, order_table, status)
VALUES (1, 'A-01', 'DONE');

INSERT INTO ORDER_DETAIL (order_id, product_id, dough_id, crust_id, unit_price)
VALUES (LAST_INSERT_ID(), 2, 1, 5, 12700);

INSERT INTO ORDER_DETAIL_TOPPING VALUES
(LAST_INSERT_ID(), 9, 5),
(LAST_INSERT_ID(), 3, 5),
(LAST_INSERT_ID(), 4, 5),
(LAST_INSERT_ID(), 7, 5),
(LAST_INSERT_ID(), 5, 5);

-- 주문 2: id02 → 페퍼로니 피자 (기본)
INSERT INTO ORDERS (user_id, order_table, status)
VALUES (2, 'B-02', 'DONE');

INSERT INTO ORDER_DETAIL (order_id, product_id, dough_id, crust_id, unit_price)
VALUES (LAST_INSERT_ID(), 3, 2, 4, 13500);

INSERT INTO ORDER_DETAIL_TOPPING VALUES
(LAST_INSERT_ID(), 8, 5),
(LAST_INSERT_ID(), 5, 5),
(LAST_INSERT_ID(), 3, 5);

-- =========================================================
-- 8. EXAMPLE COMMENTS
-- =========================================================

INSERT INTO COMMENT
(user_id, product_id, order_detail_id, rating, comment)
VALUES
(1, 2, 5, 4, '불고기랑 올리브 조합 최고입니다!'),

(2, 3, 4, 4, '페퍼로니는 역시 기본이 제일 맛있어요'),

(1, 1, 4, 3, '포테이토 피자 담백해서 좋아요');
