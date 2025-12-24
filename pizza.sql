-- =========================================================
-- Pizza Eat Ho Full DB Script
-- Schema: pizzaitho
-- MySQL
-- =========================================================

DROP DATABASE IF EXISTS pizzaitho;
CREATE DATABASE pizzaitho CHARACTER SET utf8mb4;
USE pizzaitho;

-- =========================================================
-- 1. USER / ADMIN
-- =========================================================

CREATE TABLE `USER` (
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
-- 2. PRODUCT / DOUGH / CRUST / TOPPING
-- =========================================================

CREATE TABLE PRODUCT (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    image VARCHAR(255),
    base_price INT NOT NULL
);

CREATE TABLE DOUGH (
    dough_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    image VARCHAR(255),
    extra_price INT DEFAULT 0
);

CREATE TABLE CRUST (
    crust_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    image VARCHAR(255),
    extra_price INT DEFAULT 0
);

CREATE TABLE TOPPING (
    topping_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    image VARCHAR(255),
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
    order_table VARCHAR(50),
    order_time DATETIME DEFAULT NOW(),
    status ENUM('RECEIVED', 'COOKING', 'DONE') DEFAULT 'RECEIVED',
    fcm_token VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id)
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
    FOREIGN KEY (dough_id) REFERENCES DOUGH(dough_id),
    FOREIGN KEY (crust_id) REFERENCES CRUST(crust_id)
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
-- 4. COMMENT
-- =========================================================

CREATE TABLE COMMENT (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    order_detail_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id),
    FOREIGN KEY (order_detail_id) REFERENCES ORDER_DETAIL(order_detail_id)
);

-- =========================================================
-- 5. INITIAL DATA
-- =========================================================

INSERT INTO `USER` (id, pw, name, stamp) VALUES
('id01', 'pw01', 'Hong', 1),
('id02', 'pw02', 'Kim', 3);

INSERT INTO ADMIN (id, pw, name) VALUES
('admin', 'adminpw', 'Manager');

INSERT INTO PRODUCT (name, description, image, base_price) VALUES
('Potato Pizza', 'Classic potato topping pizza', 'url', 11000),
('Bulgogi Pizza', 'Savory bulgogi pizza', 'url', 12000),
('Pepperoni Pizza', 'Pepperoni and cheese', 'url', 12000),
('Combination Pizza', 'Mixed topping pizza', 'url', 12500),
('Custom Pizza', 'Build your own pizza', 'url', 10000);

INSERT INTO DOUGH (name, image, extra_price) VALUES
('Original', 'url', 0),
('Thin', 'url', 1500),
('Cheese', 'url', 2000);

INSERT INTO CRUST (name, image, extra_price) VALUES
('None', 'url', 0),
('Cheese Crust', 'url', 3000),
('Sweet Potato Crust', 'url', 3000);

INSERT INTO TOPPING (name, image, price) VALUES
('Potato', 'url', 1200),
('Bacon', 'url', 1500),
('Onion', 'url', 500),
('Mushroom', 'url', 600),
('Olive', 'url', 700),
('Corn', 'url', 600),
('Ham', 'url', 600),
('Pepperoni', 'url', 1500),
('Bulgogi', 'url', 2000),
('Sausage', 'url', 1200),
('Jalapeno', 'url', 700),
('Pineapple', 'url', 800);

-- =========================================================
-- 6. DEFAULT TOPPINGS
-- =========================================================

INSERT INTO PRODUCT_DEFAULT_TOPPING VALUES
(1,1),(1,2),(1,3),(1,4),(1,6),
(2,9),(2,3),(2,4),(2,7),
(3,8),(3,5),(3,3),
(4,10),(4,3),(4,4),(4,5),(4,7);

-- =========================================================
-- 7. EXAMPLE ORDERS
-- =========================================================

INSERT INTO ORDERS (user_id, order_table, status)
VALUES (1, 'A-01', 'DONE');

INSERT INTO ORDER_DETAIL (order_id, product_id, dough_id, crust_id, unit_price)
VALUES (LAST_INSERT_ID(), 2, 1, 1, 12700);

INSERT INTO ORDER_DETAIL_TOPPING VALUES
(LAST_INSERT_ID(), 9, 1),
(LAST_INSERT_ID(), 3, 1),
(LAST_INSERT_ID(), 4, 1),
(LAST_INSERT_ID(), 7, 1),
(LAST_INSERT_ID(), 5, 1);

INSERT INTO ORDERS (user_id, order_table, status)
VALUES (2, 'B-02', 'DONE');

INSERT INTO ORDER_DETAIL (order_id, product_id, dough_id, crust_id, unit_price)
VALUES (LAST_INSERT_ID(), 3, 2, 1, 13500);

INSERT INTO ORDER_DETAIL_TOPPING VALUES
(LAST_INSERT_ID(), 8, 1),
(LAST_INSERT_ID(), 5, 1),
(LAST_INSERT_ID(), 3, 1);

-- =========================================================
-- 8. COMMENTS
-- =========================================================

INSERT INTO COMMENT (user_id, product_id, order_detail_id, rating, comment) VALUES
(1, 2, 1, 4, 'Great bulgogi and olive combo'),
(2, 3, 2, 4, 'Pepperoni is solid'),
(1, 1, 2, 3, 'Potato pizza is nice');
