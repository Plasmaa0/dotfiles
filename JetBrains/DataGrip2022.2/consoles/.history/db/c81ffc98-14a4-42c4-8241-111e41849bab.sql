select count(*) from sells;
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION IF EXISTS customer_stat(integer, timestamp without time zone, timestamp without time zone);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION customer_stat(p_id INT, p_start TIMESTAMP, p_end TIMESTAMP)
    RETURNS TABLE
            (
                total         FLOAT,
                order_time    TIMESTAMP,
                finish_status BOOLEAN
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT ROUND(total_cost), time as order_time, is_finished
        FROM orders
        WHERE (time BETWEEN p_start AND p_end)
          AND (customer_id = p_id)
        ORDER BY time DESC;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION IF EXISTS seller_stat(integer, timestamp without time zone, timestamp without time zone);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION seller_stat(p_id INT, p_start TIMESTAMP, p_end TIMESTAMP)
    RETURNS TABLE
            (
                good_description VARCHAR,
                items_selled     BIGINT,
                single_cost      FLOAT,
                total_cost       FLOAT
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT description, SUM(amount) as total_amount, cost, ROUND(cost * SUM(amount)) AS total
        FROM goods
                 JOIN sells ON sells.good_id = goods.id
                 JOIN orders on orders.id = sells.order_id
        WHERE (time BETWEEN p_start AND p_end)
          AND seller_id = p_id
        GROUP BY description, cost
        ORDER BY total DESC;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
DROP VIEW IF EXISTS goods_top;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW goods_top AS
SELECT good_id, description, cost, SUM(amount) AS selled_amount
FROM sells
         JOIN goods ON goods.id = sells.good_id
GROUP BY good_id, description, cost
ORDER BY selled_amount DESC;
;-- -. . -..- - / . -. - .-. -.--
DROP VIEW IF EXISTS sellers_top;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW sellers_top AS
SELECT sellers.id, sellers.name, SUM(amount*cost) as goods_selled
FROM sellers
         JOIN goods g on sellers.id = g.seller_id
         JOIN sells s on g.id = s.good_id
GROUP BY sellers.id, sellers.name
ORDER BY goods_selled DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT description, SUM(amount) as total_amount, cost, ROUND(cost * SUM(amount)) AS total
        FROM goods
                 JOIN sells ON sells.good_id = goods.id
                 JOIN orders on orders.id = sells.order_id
        WHERE (time BETWEEN '2010-01-01' AND '2014-01-01')
          AND seller_id = 10
        GROUP BY description, cost
        ORDER BY total DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT description, SUM(amount) as total_amount, cost, ROUND(cost * SUM(amount)) AS total
FROM goods
         JOIN sells ON sells.good_id = goods.id
         JOIN orders on orders.id = sells.order_id
WHERE (time BETWEEN '2010-01-01' AND '2014-01-01')
  AND seller_id = 10
GROUP BY description, cost
ORDER BY total DESC;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_sells_order_good_id ON sells(order_id, good_id);
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_sells_order_good_id;
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_sells_good_id;
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_seller_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_seller_id ON goods(seller_id);
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_test ON sells(amount);
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_test ON sells(SUM(amount));
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_test;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_sells_order_good_id ON sells(order_id, good_id, amount);
;-- -. . -..- - / . -. - .-. -.--
SELECT ROUND(total_cost), time as order_time, is_finished
        FROM orders
        WHERE (time BETWEEN '2010-01-01' AND '2014-01-01')
          AND (customer_id = 4979)
        ORDER BY time DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT ROUND(total_cost), time as order_time, is_finished
        FROM orders
        WHERE (time BETWEEN '2010-01-01' AND '2014-01-01')
          AND (customer_id = 2)
        ORDER BY time DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT ROUND(total_cost), time as order_time, is_finished
        FROM orders
        WHERE (time BETWEEN '2010-01-01' AND '2014-01-01')
          AND (customer_id = 23)
        ORDER BY time DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT ROUND(total_cost), time as order_time, is_finished
FROM orders
WHERE (time BETWEEN '2010-01-01' AND '2014-01-01')
  AND (customer_id = 4118)
ORDER BY time DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT ROUND(total_cost), time as order_time, is_finished
FROM orders
WHERE (time BETWEEN '2010-01-01' AND '2015-01-01')
  AND (customer_id = 4118)
ORDER BY time DESC;
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_orders_time;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_orders_time ON orders(time);
;-- -. . -..- - / . -. - .-. -.--
EXPLAIN ANALYZE SELECT * FROM sells WHERE amount=10;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM sells WHERE id=10;
;-- -. . -..- - / . -. - .-. -.--
EXPLAIN ANALYZE SELECT * FROM sells WHERE id=10;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_sells_good_id ON sells(good_id);
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_sellers_name ON sellers(id, name);
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_sellers_name ON sellers(name);
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_sellers_name;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_sells_order_id ON sells(order_id);
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_sells_order_id;
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX idx_orders_customer_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*) FROM sells;
;-- -. . -..- - / . -. - .-. -.--
SELECT id FROM sells WHERE id=10;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM goods;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM goods LIMIT 15;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM customer_stat(4979, '2010-01-01', '2014-01-01');
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM customer_stat(479, '2010-01-01', '2014-01-01');
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM goods WHERE id=233900;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM orders WHERE id=20001;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM goods WHERE id=6528;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM customer_stat(179, '2001-01-01', '2024-01-01');
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM seller_stat(10, '2010-01-01', '2014-01-01');
;-- -. . -..- - / . -. - .-. -.--
SELECT customers.id, customers.name, ROUND(SUM(total_cost)) AS total_spent
FROM customers
         JOIN orders o on customers.id = o.customer_id
         JOIN sells s on o.id = s.order_id
GROUP BY customers.id, customers.name
ORDER BY total_spent DESC;
;-- -. . -..- - / . -. - .-. -.--
DROP VIEW IF EXISTS customers_top;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW customers_top AS
SELECT customers.id, customers.name, ROUND(SUM(total_cost)) AS total_spent
FROM customers
         JOIN orders o on customers.id = o.customer_id
         JOIN sells s on o.id = s.order_id
GROUP BY customers.id, customers.name
ORDER BY total_spent DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM customers_top WHERE name='Tanya';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM customers WHERE name='Tanya';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM customers_top WHERE id=8001;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM sells WHERE order_id=20001;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM goods WHERE id>406323;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM orders LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, YEAR(time) FROM orders LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, year FROM time FROM orders LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, EXTRACT(year FROM time) FROM orders LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, EXTRACT(year FROM time) AS year FROM orders LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT EXTRACT(year FROM time) AS year, SUM(total_cost)
FROM orders
GROUP BY year
LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT EXTRACT(year FROM time) AS year, SUM(total_cost)
FROM orders
GROUP BY year
ORDER BY year
LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT EXTRACT(year FROM time) AS year, SUM(total_cost)
FROM orders
GROUP BY year
ORDER BY year DESC
LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
SELECT EXTRACT(year FROM time) AS year, SUM(total_cost) as total_
FROM orders
GROUP BY year
ORDER BY year DESC
LIMIT 100;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS sells;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS ingredients
(
    id          SERIAL PRIMARY KEY,
    description VARCHAR(60),
    kkal        INT
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO ingredients(description, kkal) VALUES ('bread', 50), ('salami', 150), ('batter', 100);
;-- -. . -..- - / . -. - .-. -.--
VALUES ('bread', 50), ('salami', 150), ('batter', 100);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS ingredients
(
    id          SERIAL PRIMARY KEY,
    description VARCHAR(60),
    kkal_per_kg        INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    id         SERIAL PRIMARY KEY,
    dish_id    INT,
    product_id INT,
    amount     FLOAT,
    FOREIGN KEY (dish_id)    REFERENCES dishes (id)     ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES ingredients(id) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO dishes(name) VALUES ('sandwich');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO ingredients(description, kkal_per_kg) VALUES ('bread', 50), ('salami', 150), ('batter', 100);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO recept(dish_id, product_id, amount) VALUES (1, 1, 0.05), (1, 2, 0.07), (1, 3, 0.03);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO warehouse(ingredient_id, amount) VALUES (1, 1), (2, 1), (3, 1);
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM dishes;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM recept;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM recept
JOIN ingredients i on i.id = recept.product_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT description, SUM(amount * kkal_per_kg)
FROM recept
         JOIN ingredients i on i.id = recept.product_id
WHERE dish_id = 1
GROUP BY description;
;-- -. . -..- - / . -. - .-. -.--
SELECT SUM(amount * kkal_per_kg)
FROM recept
         JOIN ingredients i on i.id = recept.product_id
WHERE dish_id = 1
GROUP BY dish_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT SUM(amount * kkal_per_kg) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
WHERE dish_id = 1
GROUP BY dish_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS dishes
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(60)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS ingredients
(
    id          SERIAL PRIMARY KEY,
    description VARCHAR(60),
    kkal_per_kg INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS warehouse
(
    id            SERIAL PRIMARY KEY,
    ingredient_id INT,
    amount        FLOAT,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    id         SERIAL PRIMARY KEY,
    dish_id    INT,
    product_id INT,
    amount     FLOAT,
    FOREIGN KEY (dish_id) REFERENCES dishes (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES ingredients (id) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO dishes(name)
VALUES ('sandwich_maslo'), ('sandwich');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO recept(dish_id, product_id, amount)
VALUES (1, 1, 0.05),
       (1, 2, 0.07),
       (1, 3, 0.03),
       (2, 1, 0.05),
       (2, 2, 0.07);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO warehouse(ingredient_id, amount)
VALUES (1, 1),
       (2, 1),
       (3, 1);
;-- -. . -..- - / . -. - .-. -.--
SELECT SUM(amount * kkal_per_kg) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
WHERE dish_id = 2
GROUP BY dish_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
WHERE dish_id = 2
GROUP BY dish_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT dish_id,description, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
-- WHERE dish_id = 2
GROUP BY dish_id,description;
;-- -. . -..- - / . -. - .-. -.--
SELECT dish_id,description, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
GROUP BY dish_id,description;
;-- -. . -..- - / . -. - .-. -.--
SELECT dish_id, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
GROUP BY dish_id,description;
;-- -. . -..- - / . -. - .-. -.--
SELECT dish_id, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
-- WHERE dish_id = 2
GROUP BY dish_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
-- WHERE dish_id = 2
GROUP BY d.id, d.name;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
WHERE r.amount < w.amount;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,description FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,description, r.amount<w.amount FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description) FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description), COUNT(r.amount<w.amount) FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description) = COUNT(r.amount<w.amount) AS available FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,description, r.amount,w.amount FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description), COUNT(r.amount<w.amount) AS available FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description), SUM(r.amount<w.amount) AS available FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description), COUNT(CASE WHEN r.amount<w.amount THEN 1 END) AS available FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description), COUNT( (r.amount<w.amount)::int) AS available FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name,COUNT(description), SUM((r.amount<w.amount)::int) AS available FROM dishes
    JOIN recept r on dishes.id = r.dish_id
    JOIN ingredients i on r.product_id = i.id
    JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT * AS available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT * 
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM dishes
         JOIN recept  on dishes.id = recept.dish_id
         JOIN ingredients on recept.product_id = ingredients.id
         JOIN warehouse on ingredients.id = warehouse.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, COUNT(description) = SUM((r.amount < w.amount)::int) AS available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, description, recept.amount, warehouse.amount
FROM dishes
         JOIN recept on dishes.id = recept.dish_id
         JOIN ingredients on recept.product_id = ingredients.id
         JOIN warehouse on ingredients.id = warehouse.ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, COUNT(description) = SUM((r.amount < w.amount)::int) AS isAvailable
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
DROP VIEW available_dishes;
;-- -. . -..- - / . -. - .-. -.--
CREATE VIEW available_dishes AS
SELECT name, COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT name, COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
-- WHERE dish_id = 2
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
-- WHERE dish_id = 2
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT dishes.id, name, COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY dishes.id, name;
;-- -. . -..- - / . -. - .-. -.--

ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
        JOIN available_dishes ON available_dishes.id = d.id
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal, is_available
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
        JOIN available_dishes ON available_dishes.id = d.id
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal, is_available
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
        JOIN available_dishes ON available_dishes.id = d.id
GROUP BY d.id, d.name, is_available
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal, is_available
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
        JOIN available_dishes ON available_dishes.id = d.id
WHERE is_available
GROUP BY d.id, d.name, is_available
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
        JOIN available_dishes ON available_dishes.id = d.id
WHERE is_available
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT dishes.id, name, COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available, ROUND(SUM(r.amount * kkal_per_kg)) as total_kkal
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY dishes.id, name;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT dishes.id,
       name,
       ROUND(SUM(r.amount * kkal_per_kg))                   as total_kkal,
       COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY dishes.id, name;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT dishes.id,
       name,
       ROUND(SUM(r.amount * kkal_per_kg))                   as total_kkal,
       COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY dishes.id, name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX IF EXISTS idx_recept_dish_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_recept_dish_id ON recept (dish_id);
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX IF EXISTS idx_recept_product_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_recept_product_id ON recept (product_id);
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX IF EXISTS idx_warehouse_ingredient_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_warehouse_ingredient_id ON warehouse (ingredient_id);
;-- -. . -..- - / . -. - .-. -.--
DROP INDEX IF EXISTS idx_dishes_name;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX idx_dishes_name ON dishes (name);
;-- -. . -..- - / . -. - .-. -.--
SELECT dishes.id,
       name,
       ROUND(SUM(r.amount * kkal_per_kg))                   as total_kkal,
       COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.id = r.dish_id
         JOIN ingredients i on r.product_id = i.id
         JOIN warehouse w on i.id = w.ingredient_id
GROUP BY dishes.id, name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT d.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
recept;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS ingredients;;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS dishes;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS recept;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS warehouse;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS ingredients;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS ingredients
(
    description VARCHAR(60) PRIMARY KEY,
    kkal_per_kg INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS warehouse
(
    ingredient_name VARCHAR(60),
    amount        FLOAT,
    FOREIGN KEY (ingredient_name) REFERENCES ingredients (description) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    dish_name    INT,
    product_name INT,
    amount     FLOAT,
    FOREIGN KEY (dish_name) REFERENCES dishes (name) ON DELETE CASCADE,
    FOREIGN KEY (product_name) REFERENCES ingredients (description) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    dish_name    VARCHAR(60),
    product_name VARCHAR(60),
    amount     FLOAT,
    FOREIGN KEY (dish_name) REFERENCES dishes (name) ON DELETE CASCADE,
    FOREIGN KEY (product_name) REFERENCES ingredients (description) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO ingredients(description, kkal_per_kg)
VALUES ('bread', 50),
       ('salami', 150),
       ('batter', 100);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT name,
       ROUND(SUM(r.amount * kkal_per_kg))                   as total_kkal,
       COUNT(description) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.name = r.dish_name
         JOIN ingredients i on r.product_name = i.description
         JOIN warehouse w on i.description = w.ingredient_name
GROUP BY name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO warehouse(ingredient_name, amount)
VALUES ('salami', 1),
       ('bread', 1),
       ('batter', 1);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO dishes(name)
VALUES ('sandwich_maslo'),
       ('sandwich');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO warehouse(ingredient_name, amount, kkal_per_kg)
VALUES ('bread', 1, 50),
       ('salami', 1, 150),
       ('batter', 1, 100);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO recept(dish_name, product_name, amount)
VALUES ('sandwich_maslo', 'bread', 0.05),
       ('sandwich_maslo', 'salami', 0.07),
       ('sandwich_maslo', 'batter', 0.03),
       ('sandwich', 'bread', 0.05),
       ('sandwich', 'salami', 0.07);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT name,
       ROUND(SUM(r.amount * kkal_per_kg))                   as total_kkal,
       COUNT(name) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.name = r.dish_name
         JOIN warehouse w on r.product_name = w.ingredient_name
GROUP BY name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    dish_name    VARCHAR(60),
    product_name VARCHAR(60),
    amount       FLOAT,
    FOREIGN KEY (dish_name) REFERENCES dishes (name) ON DELETE CASCADE,
    FOREIGN KEY (product_name) REFERENCES warehouse (ingredient_name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS warehouse
(
    ingredient_name VARCHAR(60) PRIMARY KEY,
    amount          FLOAT,
    kkal_per_kg     INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    dish_name    VARCHAR(60),
    product_name VARCHAR(60),
    amount       FLOAT,
    FOREIGN KEY (dish_name) REFERENCES dishes (name) ON DELETE CASCADE,
    FOREIGN KEY (product_name) REFERENCES warehouse (ingredient_name) ON DELETE CASCADE,
    PRIMARY KEY (dish_name, product_name)
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO warehouse(ingredient_name, amount, kkal_per_kg)
VALUES ('хлеб', 1, 50),
       ('колбаса', 1, 150),
       ('масло', 1, 100),
       ('грибы', 1, 300),
       ('сливки', 1, 250),
       ('набор овощей для супа', 2, 150);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO recept(dish_name, product_name, amount)
VALUES ('бутер с маслом', 'хлеб', 0.05),
       ('бутер с маслом', 'колбаса', 0.07),
       ('бутер с маслом', 'масло', 0.03),
       ('просто бутер', 'хлеб', 0.05),
       ('просто бутер', 'колбаса', 0.07),
       ('грибной суп', 'грибы', 0.1),
       ('грибной суп', 'сливки', 0.2),
       ('грибной суп', 'набор овощей для супа', 0.15);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT name,
       ROUND(SUM(r.amount * kkal_per_kg))            as total_kkal,
       COUNT(name) = SUM((r.amount < w.amount)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.name = r.dish_name
         JOIN warehouse w on r.product_name = w.ingredient_name
GROUP BY name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
.id, d.name, ROUND(SUM(amount * kkal_per_kg)) as total_kkal
FROM recept
         JOIN ingredients i on i.id = recept.product_id
         JOIN dishes d on recept.dish_id = d.id
GROUP BY d.id, d.name
ORDER BY total_kkal DESC;;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM recept
JOIN warehouse w on recept.product_name = w.ingredient_name;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM recept
JOIN warehouse w on recept.product_name = w.ingredient_name
WHERE w.amount < recept.amount_kg;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS ingredients cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS dishes
(
    name VARCHAR(60) PRIMARY KEY
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS warehouse
(
    ingredient_name VARCHAR(60) PRIMARY KEY,
    amount_kg          FLOAT,
    kkal_per_kg     INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS recept
(
    dish_name    VARCHAR(60),
    product_name VARCHAR(60),
    amount_kg       FLOAT,
    FOREIGN KEY (dish_name) REFERENCES dishes (name) ON DELETE CASCADE,
    FOREIGN KEY (product_name) REFERENCES warehouse (ingredient_name) ON DELETE CASCADE,
    PRIMARY KEY (dish_name, product_name)
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO dishes(name)
VALUES ('бутер с маслом'),
       ('просто бутер'),
       ('грибной суп');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO warehouse(ingredient_name, amount_kg, kkal_per_kg)
VALUES ('хлеб', 1, 50),
       ('колбаса', 1, 150),
       ('масло', 1, 100),
       ('грибы', 1, 300),
       ('сливки', 1, 250),
       ('набор овощей для супа', 2, 150);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO recept(dish_name, product_name, amount_kg)
VALUES ('бутер с маслом', 'хлеб', 0.05),
       ('бутер с маслом', 'колбаса', 0.07),
       ('бутер с маслом', 'масло', 0.03),
       ('просто бутер', 'хлеб', 0.05),
       ('просто бутер', 'колбаса', 0.07),
       ('грибной суп', 'грибы', 0.1),
       ('грибной суп', 'сливки', 0.2),
       ('грибной суп', 'набор овощей для супа', 0.15);
;-- -. . -..- - / . -. - .-. -.--
DROP VIEW IF EXISTS available_dishes;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE VIEW available_dishes AS
SELECT name,
       ROUND(SUM(r.amount_kg * kkal_per_kg))            as total_kkal,
       COUNT(name) = SUM((r.amount_kg < w.amount_kg)::int) AS is_available
FROM dishes
         JOIN recept r on dishes.name = r.dish_name
         JOIN warehouse w on r.product_name = w.ingredient_name
GROUP BY name
ORDER BY total_kkal DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM recept
JOIN warehouse w on recept.product_name = w.ingredient_name
WHERE w.amount < recept.amount;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM recept
JOIN warehouse w on recept.product_name = w.ingredient_name
WHERE w.amount_kg < recept.amount_kg;
;-- -. . -..- - / . -. - .-. -.--
SELECT dish_name
FROM recept
JOIN warehouse w on recept.product_name = w.ingredient_name
WHERE w.amount_kg < recept.amount_kg;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT dish_name
FROM recept
JOIN warehouse w on recept.product_name = w.ingredient_name
WHERE w.amount_kg < recept.amount_kg;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT dish_name
 FROM recept
          JOIN warehouse w on recept.product_name = w.ingredient_name
 WHERE w.amount_kg < recept.amount_kg;
;-- -. . -..- - / . -. - .-. -.--
EXCEPT;
;-- -. . -..- - / . -. - .-. -.--
SELECT name
FROM dishes
EXCEPT
(SELECT DISTINCT dish_name
 FROM recept
          JOIN warehouse w on recept.product_name = w.ingredient_name
 WHERE w.amount_kg < recept.amount_kg);
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS dishes cascade;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS recept cascade;
;-- -. . -..- - / . -. - .-. -.--
DROP TABLE IF EXISTS warehouse cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Участники (Участник TEXT NOT NULL PRIMARY KEY);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Факультеты (Факультет TEXT NOT NULL PRIMARY KEY);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Участник_Факультет (Участник TEXT NOT NULL, Факультет TEXT NOT NULL, FOREIGN KEY (Участник) references Участники (Участник), FOREIGN KEY (Факультет) references Факультеты (Факультет),UNIQUE ('Участник', 'Факультет'));
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Участник_Факультет
(
    Участник  TEXT NOT NULL,
    Факультет TEXT NOT NULL,
    FOREIGN KEY (Участник) references Участники (Участник),
    FOREIGN KEY (Факультет) references Факультеты (Факультет),
    UNIQUE (Участник, Факультет)
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO Участники (Участник)
VALUES ('Щукин'),
       ('Ковалев'),
       ('Ефремова'),
       ('Королева'),
       ('Большаков'),
       ('Титов'),
       ('Черняков'),
       ('Галкина'),
       ('Петрова'),
       ('Климачева'),
       ('Бочкова'),
       ('Долотов'),
       ('Васильев'),
       ('Волков'),
       ('Цыганкова'),
       ('Куприн'),
       ('Иванов'),
       ('Осетрова'),
       ('Кузнецова'),
       ('Вершинин'),
       ('Алексеева'),
       ('Крылов'),
       ('Воронин'),
       ('Иванова'),
       ('Киселев'),
       ('Широкова'),
       ('Ничушкина'),
       ('Петренко'),
       ('Нестеров'),
       ('Попов'),
       ('Морозова'),
       ('Игнашев'),
       ('Холдарова'),
       ('Исаев'),
       ('Гришакова'),
       ('Голубев'),
       ('Антонова'),
       ('Антипов'),
       ('Мишин'),
       ('Комисарова'),
       ('Жданова');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO Факультеты (Факультет)
VALUES ('СМ'),
       ('ФН'),
       ('ИУ'),
       ('СГН'),
       ('МТ'),
       ('ИБМ'),
       ('Э'),
       ('РТ');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO Участник_Факультет (Участник, Факультет)
VALUES ('Щукин', 'ИУ'),
       ('Ковалев', 'СМ'),
       ('Ефремова', 'СГН'),
       ('Королева', 'Э'),
       ('Большаков', 'РТ'),
       ('Титов', 'Э'),
       ('Черняков', 'ИУ'),
       ('Галкина', 'ИБМ'),
       ('Петрова', 'РТ'),
       ('Климачева', 'ФН'),
       ('Бочкова', 'ФН'),
       ('Долотов', 'Э'),
       ('Васильев', 'СГН'),
       ('Волков', 'Э'),
       ('Цыганкова', 'ИБМ'),
       ('Куприн', 'ФН'),
       ('Иванов', 'Э'),
       ('Осетрова', 'СГН'),
       ('Кузнецова', 'РТ'),
       ('Вершинин', 'ИУ'),
       ('Алексеева', 'СГН'),
       ('Крылов', 'ИБМ'),
       ('Воронин', 'РТ'),
       ('Иванова', 'СГН'),
       ('Киселев', 'МТ'),
       ('Широкова', 'ФН'),
       ('Ничушкина', 'ИБМ'),
       ('Петренко', 'СМ'),
       ('Нестеров', 'РТ'),
       ('Попов', 'ИБМ'),
       ('Морозова', 'СМ'),
       ('Игнашев', 'МТ'),
       ('Холдарова', 'ИБМ'),
       ('Исаев', 'МТ'),
       ('Гришакова', 'Э'),
       ('Голубев', 'МТ'),
       ('Антонова', 'ИУ'),
       ('Антипов', 'СМ'),
       ('Мишин', 'ФН'),
       ('Комисарова', 'ИУ'),
       ('Жданова', 'СМ');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Победители_и_призеры
(
    Конкурс      TEXT NOT NULL PRIMARY KEY,
    Первое_место TEXT NOT NULL,
    Второе_место TEXT NOT NULL,
    Третье_место TEXT NOT NULL
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Конкурсы
(
    Конкурс TEXT NOT NULL PRIMARY KEY
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO Конкурсы (Конкурс)
VALUES ('Мисс_МГТУ'),
       ('Мистер_МГТУ'),
       ('Профорг_года'),
       ('Проект_года'),
       ('IT-разработка'),
       ('Самый_умный'),
       ('Физика_2022');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE Баллы
(
    Участник          TEXT NOT NULL,
    Конкурс           TEXT NOT NULL,
    Количество_баллов INT,
    UNIQUE (Конкурс, Количество_баллов),
    FOREIGN KEY (Конкурс) references Конкурсы (Конкурс),
    FOREIGN KEY (Участник) references Участники (Участник),
    CHECK (Количество_баллов < 101 AND Количество_баллов > -1)
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO Баллы (Участник, Конкурс, Количество_баллов)
VALUES ('Щукин', 'Самый_умный', 75),
       ('Ковалев', 'Физика_2022', 34),
       ('Ковалев', 'Мистер_МГТУ', 86),
       ('Ефремова', 'IT-разработка', 59),
       ('Королева', 'IT-разработка', 12),
       ('Большаков', 'Самый_умный', 50),
       ('Титов', 'Физика_2022', 81),
       ('Черняков', 'Физика_2022', 78),
       ('Черняков', 'Самый_умный', 24),
       ('Галкина', 'Самый_умный', 91),
       ('Петрова', 'Мисс_МГТУ', 45),
       ('Климачева', 'Мисс_МГТУ', 81),
       ('Климачева', 'IT-разработка', 47),
       ('Бочкова', 'Проект_года', 73),
       ('Долотов', 'Профорг_года', 65),
       ('Васильев', 'Мистер_МГТУ', 39),
       ('Волков', 'Мистер_МГТУ', 70),
       ('Цыганкова', 'Мисс_МГТУ', 66),
       ('Цыганкова', 'Физика_2022', 77),
       ('Куприн', 'IT-разработка', 94),
       ('Иванов', 'Мистер_МГТУ', 7),
       ('Осетрова', 'Профорг_года', 52),
       ('Кузнецова', 'Мисс_МГТУ', 52),
       ('Вершинин', 'Проект_года', 45),
       ('Алексеева', 'Профорг_года', 88),
       ('Крылов', 'Профорг_года', 13),
       ('Крылов', 'Проект_года', 62),
       ('Воронин', 'Физика_2022', 30),
       ('Иванова', 'Мисс_МГТУ', 18),
       ('Киселев', 'Мистер_МГТУ', 97),
       ('Широкова', 'Проект_года', 84),
       ('Ничушкина', 'Мисс_МГТУ', 95),
       ('Ничушкина', 'Профорг_года', 10),
       ('Петренко', 'IT-разработка', 29),
       ('Нестеров', 'Мистер_МГТУ', 90),
       ('Попов', 'IT-разработка', 50),
       ('Морозова', 'Профорг_года', 61),
       ('Игнашев', 'Проект_года', 14),
       ('Холдарова', 'Мисс_МГТУ', 62),
       ('Исаев', 'Мистер_МГТУ', 28),
       ('Гришакова', 'Самый_умный', 27),
       ('Голубев', 'Самый_умный', 57),
       ('Голубев', 'Проект_года', 69),
       ('Антонова', 'Мисс_МГТУ', 43),
       ('Антипов', 'IT-разработка', 88),
       ('Мишин', 'Проект_года', 30),
       ('Мишин', 'Мистер_МГТУ', 92),
       ('Комисарова', 'Мисс_МГТУ', 75),
       ('Жданова', 'IT-разработка', 64);
;-- -. . -..- - / . -. - .-. -.--
SELECT Баллы.Конкурс, Факультет AS Первое_место
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Баллы.Конкурс, Факультет;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Факультет
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс
HAVING MAX(Факультет);
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Факультет
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, MAX(Количество_баллов)
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL, (SELECT Факультет FROM Участник_Факультет WHERE Количество_баллов=MAX(Количество_баллов)) AS sdf
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
SELECT Факультет, Баллы.Участник, Конкурс, Количество_баллов
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник;
;-- -. . -..- - / . -. - .-. -.--
SELECT Факультет, Баллы.Участник, Конкурс, Количество_баллов
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT Факультет, Баллы.Участник, Конкурс, Количество_баллов
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT Факультет, Конкурс
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT Факультет, Конкурс
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT UNIQUE Факультет, Конкурс
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Количество_баллов
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс, Количество_баллов
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, MAX(Количество_баллов) as MAX_BALL
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс
ORDER BY MAX_BALL DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, MAX(Количество_баллов) as MAX_BALL
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс
ORDER BY MAX_BALL DESC
OFFSET 1;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, MAX(Количество_баллов) as MAX_BALL
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
GROUP BY Конкурс
ORDER BY MAX_BALL DESC
OFFSET 2;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Количество_баллов
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Количество_баллов, Факультет
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Количество_баллов, Факультет
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Количество_баллов DESC, Конкурс;
;-- -. . -..- - / . -. - .-. -.--
SELECT Конкурс, Количество_баллов, Факультет
FROM Участник_Факультет
         JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
ORDER BY Конкурс, Количество_баллов DESC;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT * FROM results;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT *
FROM results;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT Конкурс, MAX(Количество_баллов)
FROM results
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT Конкурс, MAX(Количество_баллов), MAX(Факультет)
FROM results
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT * FROM results JOIN (SELECT MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) ON MAX_BALL=Количество_баллов;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT Факультет FROM results JOIN (SELECT MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS MAX_BALL_QUERY ON MAX_BALL=Количество_баллов;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT * FROM results JOIN (SELECT MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS MAX_BALL_QUERY ON MAX_BALL=Количество_баллов;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT *
FROM results
         JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS MAX_BALL_QUERY
              ON MAX_BALL = Количество_баллов;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT *
FROM results
         JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS MAX_BALL_QUERY
              ON MAX_BALL = Количество_баллов AND results.Конкурс = MAX_BALL_QUERY.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT results.Конкурс, Факультет
FROM results
         JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS MAX_BALL_QUERY
              ON MAX_BALL = Количество_баллов AND results.Конкурс = MAX_BALL_QUERY.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT results.Конкурс, Факультет
FROM results
 JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS TOP_1_QUERY
              ON MAX_BALL = Количество_баллов AND results.Конкурс = TOP_1_QUERY.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT results.Конкурс, Факультет AS ПервоеМесто
FROM results
 JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS TOP_1_QUERY
              ON MAX_BALL = Количество_баллов AND results.Конкурс = TOP_1_QUERY.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
SELECT results.Конкурс, Факультет AS Первое_Место
FROM results
 JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS TOP_1_QUERY
              ON MAX_BALL = Количество_баллов AND results.Конкурс = TOP_1_QUERY.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC)
-- SELECT results.Конкурс, Факультет AS Первое_Место
-- FROM results
--  JOIN (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс) AS TOP_1_QUERY
--               ON MAX_BALL = Количество_баллов AND results.Конкурс = TOP_1_QUERY.Конкурс
SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     max_ball AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс)
SELECT * FROM max_ball;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс)
SELECT * FROM top_1;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT * FROM results)
SELECT * FROM top_2;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT * FROM results)
SELECT * FROM top_1;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT * FROM results JOIN top_1 ON top_1.MAX_BALL=results.Количество_баллов AND top_1.Конкурс=results.Конкурс)
SELECT * FROM top_2;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT * FROM results LEFT JOIN top_1 ON top_1.MAX_BALL=results.Количество_баллов AND top_1.Конкурс=results.Конкурс)
SELECT * FROM top_2;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT * FROM results LEFT JOIN top_1 ON top_1.MAX_BALL=results.Количество_баллов AND top_1.Конкурс=results.Конкурс WHERE MAX_BALL IS NULL)
SELECT * FROM top_2;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов)FROM results LEFT JOIN top_1 ON top_1.MAX_BALL=results.Количество_баллов AND top_1.Конкурс=results.Конкурс WHERE MAX_BALL IS NULL
               group by results.Конкурс)
SELECT * FROM top_2;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов)
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               group by results.Конкурс),
    top_3 AS (SELECT * FROM results)
SELECT *
FROM top_3;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов)
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               group by results.Конкурс),
     top_3 AS (SELECT *
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс)
SELECT *
FROM top_3;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               group by results.Конкурс),
     top_3 AS (SELECT *
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс)
SELECT *
FROM top_3;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               group by results.Конкурс),
     top_3 AS (SELECT *
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL)
SELECT *
FROM top_3;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс)
SELECT *
FROM top_3;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM top_3;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM top_1;
;-- -. . -..- - / . -. - .-. -.--
results
FULL JOIN top1 ON;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE top_1.MAX_BALL IS NOT NULL AND top_2.MAX_BALL IS NOT NULL AND top_2.MAX_BALL IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE top_1.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE top_1.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL
ORDER BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE top_1.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
-- WHERE top_1.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL OR top_2.MAX_BALL IS NOT NULL
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
top_2.MAX_BALL IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE (top_1.MAX_BALL IS NOT NULL) OR (top_2.MAX_BALL IS NOT NULL) OR (top_2.MAX_BALL IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT *
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE (top_1.MAX_BALL IS NOT NULL) OR (top_2.MAX_BALL IS NOT NULL) OR (top_3.MAX_BALL IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс ORDER BY Конкурс)
SELECT results.Конкурс, results.Количество_баллов, results.Факультет, top_1.MAX_BALL, top_2.MAX_BALL, top_3.MAX_BALL
FROM results
FULL JOIN top_1 ON results.Конкурс=top_1.Конкурс AND results.Количество_баллов=top_1.MAX_BALL
FULL JOIN top_2 ON results.Конкурс=top_2.Конкурс AND results.Количество_баллов=top_2.MAX_BALL
FULL JOIN top_3 ON results.Конкурс=top_3.Конкурс AND results.Количество_баллов=top_3.MAX_BALL
WHERE (top_1.MAX_BALL IS NOT NULL) OR (top_2.MAX_BALL IS NOT NULL) OR (top_3.MAX_BALL IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс)
SELECT results.Конкурс,
       results.Количество_баллов,
       results.Факультет,
       top_1.MAX_BALL AS БАЛЛ_1_МЕСТА,
       top_2.MAX_BALL AS БАЛЛ_2_МЕСТА,
       top_3.MAX_BALL AS БАЛЛ_3_МЕСТА
FROM results
         FULL JOIN top_1 ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
         FULL JOIN top_2 ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
         FULL JOIN top_3 ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
WHERE (top_1.MAX_BALL IS NOT NULL)
   OR (top_2.MAX_BALL IS NOT NULL)
   OR (top_3.MAX_BALL IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс)
SELECT results.Конкурс,
       results.Факультет,
       top_1.MAX_BALL AS БАЛЛ_1_МЕСТА,
       top_2.MAX_BALL AS БАЛЛ_2_МЕСТА,
       top_3.MAX_BALL AS БАЛЛ_3_МЕСТА
FROM results
         FULL JOIN top_1 ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
         FULL JOIN top_2 ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
         FULL JOIN top_3 ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
WHERE (top_1.MAX_BALL IS NOT NULL)
   OR (top_2.MAX_BALL IS NOT NULL)
   OR (top_3.MAX_BALL IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс)
SELECT results.Конкурс,
       results.Факультет,
       top_1.MAX_BALL AS TOP_1_BALL,
       top_2.MAX_BALL AS TOP_2_BALL,
       top_3.MAX_BALL AS TOP_3_BALL
FROM results
         FULL JOIN top_1 ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
         FULL JOIN top_2 ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
         FULL JOIN top_3 ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
WHERE (top_1.MAX_BALL IS NOT NULL)
   OR (top_2.MAX_BALL IS NOT NULL)
   OR (top_3.MAX_BALL IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
    all_top AS (
    SELECT results.Конкурс, results.Факультет, top_1.MAX_BALL AS TOP_1_BALL, top_2.MAX_BALL AS TOP_2_BALL, top_3.MAX_BALL AS TOP_3_BALL
    FROM results
    FULL JOIN top_1 ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
    FULL JOIN top_2 ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
    FULL JOIN top_3 ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
    WHERE (top_1.MAX_BALL IS NOT NULL)
    OR (top_2.MAX_BALL IS NOT NULL)
    OR (top_3.MAX_BALL IS NOT NULL)
    ORDER BY results.Конкурс)
SELECT * FROM all_top;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
    all_top AS (
    SELECT results.Конкурс, results.Факультет, top_1.MAX_BALL AS TOP_1_BALL, top_2.MAX_BALL AS TOP_2_BALL, top_3.MAX_BALL AS TOP_3_BALL
    FROM results
    FULL JOIN top_1 ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
    FULL JOIN top_2 ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
    FULL JOIN top_3 ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
    WHERE (top_1.MAX_BALL IS NOT NULL)
    OR (top_2.MAX_BALL IS NOT NULL)
    OR (top_3.MAX_BALL IS NOT NULL)
    ORDER BY results.Конкурс)
SELECT results.Факультет AS TOP_1 FROM results JOIN all_top ON results.Факультет=all_top.Факультет and results.Количество_баллов=all_top.TOP_1_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
    all_top AS (
    SELECT results.Конкурс, results.Факультет, top_1.MAX_BALL AS TOP_1_BALL, top_2.MAX_BALL AS TOP_2_BALL, top_3.MAX_BALL AS TOP_3_BALL
    FROM results
    FULL JOIN top_1 ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
    FULL JOIN top_2 ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
    FULL JOIN top_3 ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
    WHERE (top_1.MAX_BALL IS NOT NULL)
    OR (top_2.MAX_BALL IS NOT NULL)
    OR (top_3.MAX_BALL IS NOT NULL)
    ORDER BY results.Конкурс)
SELECT results.Конкурс,results.Факультет AS TOP_1 FROM results JOIN all_top ON results.Факультет=all_top.Факультет and results.Количество_баллов=all_top.TOP_1_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2
FROM results
         JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2
FROM results
         FULL JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         FULL JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2
FROM results
         LEFT JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         LEFT JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         LEFT JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         LEFT JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         LEFT JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         LEFT JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         LEFT JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         LEFT JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL

ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         RIGHT JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         RIGHT JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         RIGHT JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL

ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         FULL OUTER JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         FULL OUTER JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         FULL OUTER JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL

ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         FULL JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         FULL JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         FULL JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL

ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         FULL JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         FULL JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         FULL JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL
WHERE (TOP_1 IS NOT NULL) OR (TOP_2 IS NOT NULL) OR (TOP_2 IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_top AS (SELECT results.Конкурс,
                        results.Факультет,
                        top_1.MAX_BALL AS TOP_1_BALL,
                        top_2.MAX_BALL AS TOP_2_BALL,
                        top_3.MAX_BALL AS TOP_3_BALL
                 FROM results
                          FULL JOIN top_1
                                    ON results.Конкурс = top_1.Конкурс AND results.Количество_баллов = top_1.MAX_BALL
                          FULL JOIN top_2
                                    ON results.Конкурс = top_2.Конкурс AND results.Количество_баллов = top_2.MAX_BALL
                          FULL JOIN top_3
                                    ON results.Конкурс = top_3.Конкурс AND results.Количество_баллов = top_3.MAX_BALL
                 WHERE (top_1.MAX_BALL IS NOT NULL)
                    OR (top_2.MAX_BALL IS NOT NULL)
                    OR (top_3.MAX_BALL IS NOT NULL)
                 ORDER BY results.Конкурс)
SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
FROM results
         FULL JOIN all_top at1 ON results.Факультет = at1.Факультет and results.Количество_баллов = at1.TOP_1_BALL
         FULL JOIN all_top at2 ON results.Факультет = at2.Факультет and results.Количество_баллов = at2.TOP_2_BALL
         FULL JOIN all_top at3 ON results.Факультет = at3.Факультет and results.Количество_баллов = at3.TOP_2_BALL
WHERE (at1.Факультет IS NOT NULL) OR (at2.Факультет IS NOT NULL) OR (at3.Факультет IS NOT NULL)
ORDER BY results.Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_2_BALL
                     WHERE (at1.Факультет IS NOT NULL)
                        OR (at2.Факультет IS NOT NULL)
                        OR (at3.Факультет IS NOT NULL)
                     ORDER BY results.Конкурс)
SELECT * FROM all_fak_top;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_2_BALL
                     WHERE (at1.Факультет IS NOT NULL)
                        OR (at2.Факультет IS NOT NULL)
                        OR (at3.Факультет IS NOT NULL)
                     ORDER BY results.Конкурс)
SELECT Конкурс, COALESCE(top_1) FROM all_fak_top;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_2_BALL
                     WHERE (at1.Факультет IS NOT NULL)
                        OR (at2.Факультет IS NOT NULL)
                        OR (at3.Факультет IS NOT NULL)
                     ORDER BY results.Конкурс)
SELECT Конкурс, COALESCE(top_1) FROM all_fak_top GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_2_BALL
                     WHERE (at1.Факультет IS NOT NULL)
                        OR (at2.Факультет IS NOT NULL)
                        OR (at3.Факультет IS NOT NULL)
                     ORDER BY results.Конкурс)
SELECT Конкурс, MAX(top_1), MAX(top_2),MAX(top_3) FROM all_fak_top GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_2_BALL
                     WHERE (at1.Факультет IS NOT NULL)
                        OR (at2.Факультет IS NOT NULL)
                        OR (at3.Факультет IS NOT NULL)
                     ORDER BY results.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место,MAX(top_3) AS Третье_Место FROM all_fak_top GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_2_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                        OR (at2.Факультет IS NOT NULL)
                        OR (at3.Факультет IS NOT NULL)) AND results.Конкурс IS NOT NULL 
                     ORDER BY results.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место,MAX(top_3) AS Третье_Место FROM all_fak_top GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND results.Конкурс IS NOT NULL
                     ORDER BY results.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место, MAX(top_3) AS Третье_Место
FROM all_fak_top
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     top_1 AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     top_2 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     top_3 AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN top_1
                                  ON top_1.MAX_BALL = results.Количество_баллов AND top_1.Конкурс = results.Конкурс
                        LEFT JOIN top_2
                                  ON top_2.MAX_BALL = results.Количество_баллов AND top_2.Конкурс = results.Конкурс
               WHERE top_1.MAX_BALL IS NULL
                 AND top_2.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             top_1.MAX_BALL AS TOP_1_BALL,
                             top_2.MAX_BALL AS TOP_2_BALL,
                             top_3.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN top_1
                                         ON results.Конкурс = top_1.Конкурс AND
                                            results.Количество_баллов = top_1.MAX_BALL
                               FULL JOIN top_2
                                         ON results.Конкурс = top_2.Конкурс AND
                                            results.Количество_баллов = top_2.MAX_BALL
                               FULL JOIN top_3
                                         ON results.Конкурс = top_3.Конкурс AND
                                            results.Количество_баллов = top_3.MAX_BALL
                      WHERE (top_1.MAX_BALL IS NOT NULL)
                         OR (top_2.MAX_BALL IS NOT NULL)
                         OR (top_3.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND results.Конкурс IS NOT NULL
                     ORDER BY results.Конкурс)
SELECT * FROM top_1;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = results.Количество_баллов AND БаллыПервыхМест.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = results.Количество_баллов AND БаллыПервыхМест.Конкурс = results.Конкурс
                        LEFT JOIN БаллыВторыхМест
                                  ON БаллыВторыхМест.MAX_BALL = results.Количество_баллов AND БаллыВторыхМест.Конкурс = results.Конкурс
               WHERE БаллыПервыхМест.MAX_BALL IS NULL
                 AND БаллыВторыхМест.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     all_ball_top AS (SELECT results.Конкурс,
                             results.Факультет,
                             БаллыПервыхМест.MAX_BALL AS TOP_1_BALL,
                             БаллыВторыхМест.MAX_BALL AS TOP_2_BALL,
                             БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN БаллыПервыхМест
                                         ON results.Конкурс = БаллыПервыхМест.Конкурс AND
                                            results.Количество_баллов = БаллыПервыхМест.MAX_BALL
                               FULL JOIN БаллыВторыхМест
                                         ON results.Конкурс = БаллыВторыхМест.Конкурс AND
                                            results.Количество_баллов = БаллыВторыхМест.MAX_BALL
                               FULL JOIN БаллыТретьихМест
                                         ON results.Конкурс = БаллыТретьихМест.Конкурс AND
                                            results.Количество_баллов = БаллыТретьихМест.MAX_BALL
                      WHERE (БаллыПервыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN all_ball_top at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN all_ball_top at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN all_ball_top at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND results.Конкурс IS NOT NULL
                     ORDER BY results.Конкурс)
SELECT * FROM all_ball_top;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = results.Количество_баллов AND БаллыПервыхМест.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = results.Количество_баллов AND БаллыПервыхМест.Конкурс = results.Конкурс
                        LEFT JOIN БаллыВторыхМест
                                  ON БаллыВторыхМест.MAX_BALL = results.Количество_баллов AND БаллыВторыхМест.Конкурс = results.Конкурс
               WHERE БаллыПервыхМест.MAX_BALL IS NULL
                 AND БаллыВторыхМест.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT results.Конкурс,
                             results.Факультет,
                             БаллыПервыхМест.MAX_BALL AS TOP_1_BALL,
                             БаллыВторыхМест.MAX_BALL AS TOP_2_BALL,
                             БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN БаллыПервыхМест
                                         ON results.Конкурс = БаллыПервыхМест.Конкурс AND
                                            results.Количество_баллов = БаллыПервыхМест.MAX_BALL
                               FULL JOIN БаллыВторыхМест
                                         ON results.Конкурс = БаллыВторыхМест.Конкурс AND
                                            results.Количество_баллов = БаллыВторыхМест.MAX_BALL
                               FULL JOIN БаллыТретьихМест
                                         ON results.Конкурс = БаллыТретьихМест.Конкурс AND
                                            results.Количество_баллов = БаллыТретьихМест.MAX_BALL
                      WHERE (БаллыПервыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     all_fak_top AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN БаллыВсехМест at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN БаллыВсехМест at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN БаллыВсехМест at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND results.Конкурс IS NOT NULL
                     ORDER BY results.Конкурс)
SELECT * FROM all_fak_top;
;-- -. . -..- - / . -. - .-. -.--
WITH results AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM results GROUP BY Конкурс ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = results.Количество_баллов AND БаллыПервыхМест.Конкурс = results.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT results.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM results
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = results.Количество_баллов AND БаллыПервыхМест.Конкурс = results.Конкурс
                        LEFT JOIN БаллыВторыхМест
                                  ON БаллыВторыхМест.MAX_BALL = results.Количество_баллов AND БаллыВторыхМест.Конкурс = results.Конкурс
               WHERE БаллыПервыхМест.MAX_BALL IS NULL
                 AND БаллыВторыхМест.MAX_BALL IS NULL
               GROUP BY results.Конкурс
               ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT results.Конкурс,
                             results.Факультет,
                             БаллыПервыхМест.MAX_BALL AS TOP_1_BALL,
                             БаллыВторыхМест.MAX_BALL AS TOP_2_BALL,
                             БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                      FROM results
                               FULL JOIN БаллыПервыхМест
                                         ON results.Конкурс = БаллыПервыхМест.Конкурс AND
                                            results.Количество_баллов = БаллыПервыхМест.MAX_BALL
                               FULL JOIN БаллыВторыхМест
                                         ON results.Конкурс = БаллыВторыхМест.Конкурс AND
                                            results.Количество_баллов = БаллыВторыхМест.MAX_BALL
                               FULL JOIN БаллыТретьихМест
                                         ON results.Конкурс = БаллыТретьихМест.Конкурс AND
                                            results.Количество_баллов = БаллыТретьихМест.MAX_BALL
                      WHERE (БаллыПервыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                      ORDER BY results.Конкурс),
     МестаФакультетов AS (SELECT results.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM results
                              FULL JOIN БаллыВсехМест at1 ON results.Факультет = at1.Факультет and
                                                            results.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN БаллыВсехМест at2 ON results.Факультет = at2.Факультет and
                                                            results.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN БаллыВсехМест at3 ON results.Факультет = at3.Факультет and
                                                            results.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND results.Конкурс IS NOT NULL
                     ORDER BY results.Конкурс)
SELECT * FROM results;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM ВсеБаллы GROUP BY Конкурс ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM ВсеБаллы
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY ВсеБаллы.Конкурс
               ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM ВсеБаллы
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                        LEFT JOIN БаллыВторыхМест
                                  ON БаллыВторыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
               WHERE БаллыПервыхМест.MAX_BALL IS NULL
                 AND БаллыВторыхМест.MAX_BALL IS NULL
               GROUP BY ВсеБаллы.Конкурс
               ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                             ВсеБаллы.Факультет,
                             БаллыПервыхМест.MAX_BALL AS TOP_1_BALL,
                             БаллыВторыхМест.MAX_BALL AS TOP_2_BALL,
                             БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                      FROM ВсеБаллы
                               FULL JOIN БаллыПервыхМест
                                         ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                            ВсеБаллы.Количество_баллов = БаллыПервыхМест.MAX_BALL
                               FULL JOIN БаллыВторыхМест
                                         ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                            ВсеБаллы.Количество_баллов = БаллыВторыхМест.MAX_BALL
                               FULL JOIN БаллыТретьихМест
                                         ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                            ВсеБаллы.Количество_баллов = БаллыТретьихМест.MAX_BALL
                      WHERE (БаллыПервыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                      ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM ВсеБаллы
                              FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                            ВсеБаллы.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                            ВсеБаллы.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                            ВсеБаллы.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND ВсеБаллы.Конкурс IS NOT NULL
                     ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс, MAX(БаллыПервыхМест) AS Первое_Место, MAX(БаллыВторыхМест) AS Второе_Место, MAX(БаллыТретьихМест) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                  FROM Участник_Факультет
                           JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                  ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL
                         FROM ВсеБаллы
                         GROUP BY Конкурс
                         ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
                         FROM ВсеБаллы
                                  LEFT JOIN БаллыПервыхМест
                                            ON БаллыПервыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND
                                               БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                         WHERE MAX_BALL IS NULL
                         GROUP BY ВсеБаллы.Конкурс
                         ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
                          FROM ВсеБаллы
                                   LEFT JOIN БаллыПервыхМест
                                             ON БаллыПервыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND
                                                БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                                   LEFT JOIN БаллыВторыхМест
                                             ON БаллыВторыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND
                                                БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
                          WHERE БаллыПервыхМест.MAX_BALL IS NULL
                            AND БаллыВторыхМест.MAX_BALL IS NULL
                          GROUP BY ВсеБаллы.Конкурс
                          ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                              ВсеБаллы.Факультет,
                              БаллыПервыхМест.MAX_BALL  AS TOP_1_BALL,
                              БаллыВторыхМест.MAX_BALL  AS TOP_2_BALL,
                              БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                       FROM ВсеБаллы
                                FULL JOIN БаллыПервыхМест
                                          ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыПервыхМест.MAX_BALL
                                FULL JOIN БаллыВторыхМест
                                          ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыВторыхМест.MAX_BALL
                                FULL JOIN БаллыТретьихМест
                                          ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыТретьихМест.MAX_BALL
                       WHERE (БаллыПервыхМест.MAX_BALL IS NOT NULL)
                          OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                          OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                       ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс,
                                 at1.Факультет AS TOP_1,
                                 at2.Факультет AS TOP_2,
                                 at3.Факультет AS TOP_3
                          FROM ВсеБаллы
                                   FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at1.TOP_1_BALL
                                   FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at2.TOP_2_BALL
                                   FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at3.TOP_3_BALL
                          WHERE ((at1.Факультет IS NOT NULL)
                              OR (at2.Факультет IS NOT NULL)
                              OR (at3.Факультет IS NOT NULL))
                            AND ВсеБаллы.Конкурс IS NOT NULL
                          ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс,
       MAX(БаллыПервыхМест)  AS Первое_Место,
       MAX(БаллыВторыхМест)  AS Второе_Место,
       MAX(БаллыТретьихМест) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                 FROM Участник_Факультет
                          JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                 ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS MAX_BALL FROM ВсеБаллы GROUP BY Конкурс ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM ВсеБаллы
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
               WHERE MAX_BALL IS NULL
               GROUP BY ВсеБаллы.Конкурс
               ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
               FROM ВсеБаллы
                        LEFT JOIN БаллыПервыхМест
                                  ON БаллыПервыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                        LEFT JOIN БаллыВторыхМест
                                  ON БаллыВторыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
               WHERE БаллыПервыхМест.MAX_BALL IS NULL
                 AND БаллыВторыхМест.MAX_BALL IS NULL
               GROUP BY ВсеБаллы.Конкурс
               ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                             ВсеБаллы.Факультет,
                             БаллыПервыхМест.MAX_BALL AS TOP_1_BALL,
                             БаллыВторыхМест.MAX_BALL AS TOP_2_BALL,
                             БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                      FROM ВсеБаллы
                               FULL JOIN БаллыПервыхМест
                                         ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                            ВсеБаллы.Количество_баллов = БаллыПервыхМест.MAX_BALL
                               FULL JOIN БаллыВторыхМест
                                         ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                            ВсеБаллы.Количество_баллов = БаллыВторыхМест.MAX_BALL
                               FULL JOIN БаллыТретьихМест
                                         ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                            ВсеБаллы.Количество_баллов = БаллыТретьихМест.MAX_BALL
                      WHERE (БаллыПервыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                         OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                      ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс, at1.Факультет AS TOP_1, at2.Факультет AS TOP_2, at3.Факультет AS TOP_3
                     FROM ВсеБаллы
                              FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                            ВсеБаллы.Количество_баллов = at1.TOP_1_BALL
                              FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                            ВсеБаллы.Количество_баллов = at2.TOP_2_BALL
                              FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                            ВсеБаллы.Количество_баллов = at3.TOP_3_BALL
                     WHERE ((at1.Факультет IS NOT NULL)
                         OR (at2.Факультет IS NOT NULL)
                         OR (at3.Факультет IS NOT NULL))
                       AND ВсеБаллы.Конкурс IS NOT NULL
                     ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место, MAX(top_3) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                  FROM Участник_Факультет
                           JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                  ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                         GROUP BY Конкурс
                         ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
                         FROM ВсеБаллы
                                  LEFT JOIN БаллыПервыхМест
                                            ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                               БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                         WHERE МаксБалл IS NULL
                         GROUP BY ВсеБаллы.Конкурс
                         ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
                          FROM ВсеБаллы
                                   LEFT JOIN БаллыПервыхМест
                                             ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                                   LEFT JOIN БаллыВторыхМест
                                             ON БаллыВторыхМест.MAX_BALL = ВсеБаллы.Количество_баллов AND
                                                БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
                          WHERE БаллыПервыхМест.МаксБалл IS NULL
                            AND БаллыВторыхМест.MAX_BALL IS NULL
                          GROUP BY ВсеБаллы.Конкурс
                          ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                              ВсеБаллы.Факультет,
                              БаллыПервыхМест.МаксБалл  AS TOP_1_BALL,
                              БаллыВторыхМест.MAX_BALL  AS TOP_2_BALL,
                              БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                       FROM ВсеБаллы
                                FULL JOIN БаллыПервыхМест
                                          ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыПервыхМест.МаксБалл
                                FULL JOIN БаллыВторыхМест
                                          ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыВторыхМест.MAX_BALL
                                FULL JOIN БаллыТретьихМест
                                          ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыТретьихМест.MAX_BALL
                       WHERE (БаллыПервыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыВторыхМест.MAX_BALL IS NOT NULL)
                          OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                       ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс,
                                 at1.Факультет AS TOP_1,
                                 at2.Факультет AS TOP_2,
                                 at3.Факультет AS TOP_3
                          FROM ВсеБаллы
                                   FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at1.TOP_1_BALL
                                   FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at2.TOP_2_BALL
                                   FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at3.TOP_3_BALL
                          WHERE ((at1.Факультет IS NOT NULL)
                              OR (at2.Факультет IS NOT NULL)
                              OR (at3.Факультет IS NOT NULL))
                            AND ВсеБаллы.Конкурс IS NOT NULL
                          ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место, MAX(top_3) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                  FROM Участник_Факультет
                           JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                  ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                         GROUP BY Конкурс
                         ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                                  LEFT JOIN БаллыПервыхМест
                                            ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                               БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                         WHERE МаксБалл IS NULL
                         GROUP BY ВсеБаллы.Конкурс
                         ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS MAX_BALL
                          FROM ВсеБаллы
                                   LEFT JOIN БаллыПервыхМест
                                             ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                                   LEFT JOIN БаллыВторыхМест
                                             ON БаллыВторыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
                          WHERE БаллыПервыхМест.МаксБалл IS NULL
                            AND БаллыВторыхМест.МаксБалл IS NULL
                          GROUP BY ВсеБаллы.Конкурс
                          ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                              ВсеБаллы.Факультет,
                              БаллыПервыхМест.МаксБалл  AS TOP_1_BALL,
                              БаллыВторыхМест.МаксБалл  AS TOP_2_BALL,
                              БаллыТретьихМест.MAX_BALL AS TOP_3_BALL
                       FROM ВсеБаллы
                                FULL JOIN БаллыПервыхМест
                                          ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыПервыхМест.МаксБалл
                                FULL JOIN БаллыВторыхМест
                                          ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыВторыхМест.МаксБалл
                                FULL JOIN БаллыТретьихМест
                                          ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыТретьихМест.MAX_BALL
                       WHERE (БаллыПервыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыВторыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыТретьихМест.MAX_BALL IS NOT NULL)
                       ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс,
                                 at1.Факультет AS TOP_1,
                                 at2.Факультет AS TOP_2,
                                 at3.Факультет AS TOP_3
                          FROM ВсеБаллы
                                   FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at1.TOP_1_BALL
                                   FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at2.TOP_2_BALL
                                   FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at3.TOP_3_BALL
                          WHERE ((at1.Факультет IS NOT NULL)
                              OR (at2.Факультет IS NOT NULL)
                              OR (at3.Факультет IS NOT NULL))
                            AND ВсеБаллы.Конкурс IS NOT NULL
                          ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место, MAX(top_3) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                  FROM Участник_Факультет
                           JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                  ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                         GROUP BY Конкурс
                         ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                                  LEFT JOIN БаллыПервыхМест
                                            ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                               БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                         WHERE МаксБалл IS NULL
                         GROUP BY ВсеБаллы.Конкурс
                         ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS МаксБалл
                          FROM ВсеБаллы
                                   LEFT JOIN БаллыПервыхМест
                                             ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                                   LEFT JOIN БаллыВторыхМест
                                             ON БаллыВторыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
                          WHERE БаллыПервыхМест.МаксБалл IS NULL
                            AND БаллыВторыхМест.МаксБалл IS NULL
                          GROUP BY ВсеБаллы.Конкурс
                          ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                              ВсеБаллы.Факультет,
                              БаллыПервыхМест.МаксБалл  AS TOP_1_BALL,
                              БаллыВторыхМест.МаксБалл  AS TOP_2_BALL,
                              БаллыТретьихМест.МаксБалл AS TOP_3_BALL
                       FROM ВсеБаллы
                                FULL JOIN БаллыПервыхМест
                                          ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыПервыхМест.МаксБалл
                                FULL JOIN БаллыВторыхМест
                                          ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыВторыхМест.МаксБалл
                                FULL JOIN БаллыТретьихМест
                                          ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыТретьихМест.МаксБалл
                       WHERE (БаллыПервыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыВторыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыТретьихМест.МаксБалл IS NOT NULL)
                       ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс,
                                 at1.Факультет AS TOP_1,
                                 at2.Факультет AS TOP_2,
                                 at3.Факультет AS TOP_3
                          FROM ВсеБаллы
                                   FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at1.TOP_1_BALL
                                   FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at2.TOP_2_BALL
                                   FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at3.TOP_3_BALL
                          WHERE ((at1.Факультет IS NOT NULL)
                              OR (at2.Факультет IS NOT NULL)
                              OR (at3.Факультет IS NOT NULL))
                            AND ВсеБаллы.Конкурс IS NOT NULL
                          ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс, MAX(top_1) AS Первое_Место, MAX(top_2) AS Второе_Место, MAX(top_3) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;
;-- -. . -..- - / . -. - .-. -.--
WITH ВсеБаллы AS (SELECT Конкурс, Количество_баллов, Факультет
                  FROM Участник_Факультет
                           JOIN Баллы ON Участник_Факультет.Участник = Баллы.Участник
                  ORDER BY Конкурс, Количество_баллов DESC),
     БаллыПервыхМест AS (SELECT Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                         GROUP BY Конкурс
                         ORDER BY Конкурс),
     БаллыВторыхМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS МаксБалл
                         FROM ВсеБаллы
                                  LEFT JOIN БаллыПервыхМест
                                            ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                               БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                         WHERE МаксБалл IS NULL
                         GROUP BY ВсеБаллы.Конкурс
                         ORDER BY Конкурс),
     БаллыТретьихМест AS (SELECT ВсеБаллы.Конкурс, MAX(Количество_баллов) AS МаксБалл
                          FROM ВсеБаллы
                                   LEFT JOIN БаллыПервыхМест
                                             ON БаллыПервыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыПервыхМест.Конкурс = ВсеБаллы.Конкурс
                                   LEFT JOIN БаллыВторыхМест
                                             ON БаллыВторыхМест.МаксБалл = ВсеБаллы.Количество_баллов AND
                                                БаллыВторыхМест.Конкурс = ВсеБаллы.Конкурс
                          WHERE БаллыПервыхМест.МаксБалл IS NULL
                            AND БаллыВторыхМест.МаксБалл IS NULL
                          GROUP BY ВсеБаллы.Конкурс
                          ORDER BY Конкурс),
     БаллыВсехМест AS (SELECT ВсеБаллы.Конкурс,
                              ВсеБаллы.Факультет,
                              БаллыПервыхМест.МаксБалл  AS БаллПервого,
                              БаллыВторыхМест.МаксБалл  AS БаллВторого,
                              БаллыТретьихМест.МаксБалл AS БаллТретьего
                       FROM ВсеБаллы
                                FULL JOIN БаллыПервыхМест
                                          ON ВсеБаллы.Конкурс = БаллыПервыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыПервыхМест.МаксБалл
                                FULL JOIN БаллыВторыхМест
                                          ON ВсеБаллы.Конкурс = БаллыВторыхМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыВторыхМест.МаксБалл
                                FULL JOIN БаллыТретьихМест
                                          ON ВсеБаллы.Конкурс = БаллыТретьихМест.Конкурс AND
                                             ВсеБаллы.Количество_баллов = БаллыТретьихМест.МаксБалл
                       WHERE (БаллыПервыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыВторыхМест.МаксБалл IS NOT NULL)
                          OR (БаллыТретьихМест.МаксБалл IS NOT NULL)
                       ORDER BY ВсеБаллы.Конкурс),
     МестаФакультетов AS (SELECT ВсеБаллы.Конкурс,
                                 at1.Факультет AS ПервыйФак,
                                 at2.Факультет AS ВторойФак,
                                 at3.Факультет AS ТретийФак
                          FROM ВсеБаллы
                                   FULL JOIN БаллыВсехМест at1 ON ВсеБаллы.Факультет = at1.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at1.БаллПервого
                                   FULL JOIN БаллыВсехМест at2 ON ВсеБаллы.Факультет = at2.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at2.БаллВторого
                                   FULL JOIN БаллыВсехМест at3 ON ВсеБаллы.Факультет = at3.Факультет and
                                                                  ВсеБаллы.Количество_баллов = at3.БаллТретьего
                          WHERE ((at1.Факультет IS NOT NULL)
                              OR (at2.Факультет IS NOT NULL)
                              OR (at3.Факультет IS NOT NULL))
                            AND ВсеБаллы.Конкурс IS NOT NULL
                          ORDER BY ВсеБаллы.Конкурс)
SELECT Конкурс, MAX(ПервыйФак) AS Первое_Место, MAX(ВторойФак) AS Второе_Место, MAX(ТретийФак) AS Третье_Место
FROM МестаФакультетов
GROUP BY Конкурс;