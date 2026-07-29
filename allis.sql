CREATE DATABASE IF NOT EXISTS pizzeria;
USE pizzeria;

-- 1. Clientes
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categorìas de Producto
CREATE TABLE category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE -- Podrià ser Pizza, Panzarotti, Bebida, Postre
);

-- 3. Productos (Generales y No Elaborados)
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(70) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- 4. Ingredientes
CREATE TABLE ingredient (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(80) NOT NULL UNIQUE
);

-- 5. Relaciòn Producto - Ingrediente (Receta)
CREATE TABLE product_ingredient (
    product_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    PRIMARY KEY (product_id, ingredient_id),
    CONSTRAINT fk_pi_product FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT fk_pi_ingredient FOREIGN KEY (ingredient_id) REFERENCES ingredient(ingredient_id)
);

-- 6. Adiciones (Extra queso, salsas, etc.)
CREATE TABLE topping (
    topping_id INT AUTO_INCREMENT PRIMARY KEY,
    topping_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- 7. Combos
CREATE TABLE combo (
    combo_id INT AUTO_INCREMENT PRIMARY KEY,
    combo_name VARCHAR(100) NOT NULL,
    description TEXT,
    combo_price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

-- 8. Relación Combo - Producto
CREATE TABLE combo_detail (
    combo_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (combo_id, product_id),
    CONSTRAINT fk_cd_combo FOREIGN KEY (combo_id) REFERENCES combo(combo_id),
    CONSTRAINT fk_cd_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 9. Pedidos
CREATE TABLE order_header (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivery_type ENUM('Dine In', 'Pickup') NOT NULL,
    order_status ENUM('Pending', 'In Preparation', 'Completed', 'Canceled') DEFAULT 'Completed',
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 10. Detalle del Pedido (Ìtems individuales o combos dentro del pedido)
CREATE TABLE order_detail (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NULL, -- Puede ser un producto individual...
    combo_id INT NULL,    -- ...o un combo
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_od_order FOREIGN KEY (order_id) REFERENCES order_header(order_id),
    CONSTRAINT fk_od_product FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT fk_od_combo FOREIGN KEY (combo_id) REFERENCES combo(combo_id)
);

-- 11. Adiciones personalizadas por Ìtem de pedido
CREATE TABLE order_detail_topping (
    order_detail_id INT NOT NULL,
    topping_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_detail_id, topping_id),
    CONSTRAINT fk_odt_detail FOREIGN KEY (order_detail_id) REFERENCES order_detail(order_detail_id),
    CONSTRAINT fk_odt_topping FOREIGN KEY (topping_id) REFERENCES topping(topping_id)
);

-- insertar 
USE pizzeria;

-- 1. Insertar Categorías
INSERT INTO category (category_id, category_name) VALUES
(1, 'Pizza'),
(2, 'Panzarotti'),
(3, 'Bebida'),
(4, 'Postre');

-- 2. Insertar Productos
INSERT INTO product (product_id, category_id, product_name, description, price, is_available) VALUES
(1, 1, 'Pizza Pepperoni', 'Pizza mediana con extra pepperoni y mozzarella', 35000.00, TRUE),
(2, 1, 'Pizza Hawaiana', 'Pizza mediana con piña y jamón', 32000.00, TRUE),
(3, 2, 'Panzarotti Mixto', 'Masa crujiente rellena de queso y pollo', 18000.00, TRUE),
(4, 3, 'Coca-Cola 1.5L', 'Gaseosa refrescante 1.5 litros', 8000.00, TRUE),
(5, 3, 'Jugo Natural Mango', 'Jugo en agua 500ml', 6000.00, TRUE),
(6, 4, 'Tiramisú', 'Postre italiano tradicional', 12000.00, TRUE);

-- 3. Insertar Ingredientes
INSERT INTO ingredient (ingredient_id, ingredient_name) VALUES
(1, 'Queso Mozzarella'),
(2, 'Pepperoni'),
(3, 'Masa Tradicional'),
(4, 'Salsa de Tomate'),
(5, 'Jamón'),
(6, 'Piña'),
(7, 'Pollo Desmechado');

-- 4. Insertar Relación Producto - Ingrediente (Recetas)
INSERT INTO product_ingredient (product_id, ingredient_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), -- Pizza Pepperoni
(2, 1), (2, 3), (2, 4), (2, 5), (2, 6), -- Pizza Hawaiana
(3, 1), (3, 3), (3, 7); -- Panzarotti Mixto

-- 5. Insertar Adiciones (Toppings)
INSERT INTO topping (topping_id, topping_name, price) VALUES
(1, 'Extra Queso', 4000.00),
(2, 'Salsa de Ajo', 2000.00),
(3, 'Tocineta', 5000.00);

-- 6. Insertar Combos
INSERT INTO combo (combo_id, combo_name, description, combo_price, is_available) VALUES
(1, 'Combo Pareja', '1 Pizza Pepperoni + 2 Coca-Cola 1.5L', 45000.00, TRUE),
(2, 'Combo Personal', '1 Panzarotti Mixto + 1 Jugo Natural', 22000.00, TRUE);

-- 7. Insertar Detalle de Combos
INSERT INTO combo_detail (combo_id, product_id, quantity) VALUES
(1, 1, 1), -- 1 Pizza Pepperoni
(1, 4, 2), -- 2 Coca-Cola
(2, 3, 1), -- 1 Panzarotti
(2, 5, 1); -- 1 Jugo

-- 8. Insertar Clientes
INSERT INTO customer (customer_id, full_name, phone_number, email) VALUES
(1, 'Allison Vargas', '3001234567', 'allisonrocio@email.com'),
(2, 'Marìa Josè', '3109876543', 'ajitomajito@email.com'),
(3, 'Pablo Lopez', '3205554433', 'Pabloolopez@email.com');

-- 9. Insertar Encabezados de Pedidos (Orders)
INSERT INTO order_header (order_id, customer_id, order_date, delivery_type, order_status) VALUES
(1, 1, NOW() - INTERVAL 2 DAY, 'Dine In', 'Completed'),
(2, 1, NOW() - INTERVAL 1 DAY, 'Pickup', 'Completed'),
(3, 2, NOW() - INTERVAL 5 DAY, 'Pickup', 'Completed'),
(4, 3, NOW() - INTERVAL 10 DAY, 'Dine In', 'Completed');

-- 10. Insertar Detalle de los Pedidos
INSERT INTO order_detail (order_detail_id, order_id, product_id, combo_id, quantity, unit_price) VALUES
(1, 1, 1, NULL, 2, 35000.00), -- 2 Pizzas Pepperoni
(2, 1, 4, NULL, 1, 8000.00),  -- 1 Coca-Cola
(3, 2, NULL, 1, 1, 45000.00), -- 1 Combo Pareja
(4, 3, 3, NULL, 3, 18000.00), -- 3 Panzarottis
(5, 4, 1, NULL, 1, 35000.00), -- 1 Pizza Pepperoni
(6, 4, 2, NULL, 1, 32000.00); -- 1 Pizza Hawaiana

-- 11. Insertar Adiciones en Pedidos
INSERT INTO order_detail_topping (order_detail_id, topping_id, quantity, unit_price) VALUES
(1, 1, 2, 4000.00), -- Extra queso en las pizzas pepperoni del pedido 1
(4, 2, 3, 2000.00); -- Salsa de ajo en los panzarottis del pedido 3






-- Consultas 

-- 1. Productos màs vendidos
SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM order_detail od
JOIN product p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC;

-- 2. Total de ingresos generados por cada combo

SELECT c.combo_name, SUM(od.quantity * od.unit_price) AS total_revenue
FROM order_detail od
JOIN combo c ON od.combo_id = c.combo_id
GROUP BY c.combo_id, c.combo_name;


-- 3. Pedidos realizados para recoger vs. comer en la pizzería
SELECT delivery_type, COUNT(*) AS total_orders
FROM order_header
GROUP BY delivery_type;


--  4. Adiciones más solicitadas en pedidos personalizados
SELECT t.topping_name, SUM(odt.quantity) AS total_requested
FROM order_detail_topping odt
JOIN topping t ON odt.topping_id = t.topping_id
GROUP BY t.topping_id, t.topping_name
ORDER BY total_requested DESC;

-- 5. Cantidad total de productos vendidos por categoría
SELECT c.category_name, SUM(od.quantity) AS total_products_sold
FROM order_detail od
JOIN product p ON od.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

--  6. Promedio de pizzas pedidas por cliente
SELECT AVG(pizzas_per_customer) AS average_pizzas
FROM (
    SELECT oh.customer_id, SUM(od.quantity) AS pizzas_per_customer
    FROM order_header oh
    JOIN order_detail od ON oh.order_id = od.order_id
    JOIN product p ON od.product_id = p.product_id
    JOIN category c ON p.category_id = c.category_id
    WHERE c.category_name = 'Pizza'
    GROUP BY oh.customer_id
) AS subquery;

-- 7. Total de ventas por día de la semana
SELECT DAYNAME(order_date) AS day_of_week, SUM(od.quantity * od.unit_price) AS total_sales
FROM order_header oh
JOIN order_detail od ON oh.order_id = od.order_id
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY DAYOFWEEK(order_date);

-- 8. Cantidad de panzarottis vendidos con extra queso
SELECT SUM(od.quantity) AS total_panzarottis_extra_cheese
FROM order_detail od
JOIN product p ON od.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
JOIN order_detail_topping odt ON od.order_detail_id = odt.order_detail_id
JOIN topping t ON odt.topping_id = t.topping_id
WHERE c.category_name = 'Panzarotti' AND t.topping_name = 'Extra Queso';

-- 9. Pedidos que incluyen bebidas como parte de un combo
SELECT DISTINCT od.order_id, c.combo_name
FROM order_detail od
JOIN combo_detail cd ON od.combo_id = cd.combo_id
JOIN product p ON cd.product_id = p.product_id
JOIN category cat ON p.category_id = cat.category_id
WHERE cat.category_name = 'Bebida';


-- 10. Clientes que han realizado más de 5 pedidos en el último mes
SELECT c.full_name, COUNT(oh.order_id) AS total_orders
FROM customer c
JOIN order_header oh ON c.customer_id = oh.customer_id
WHERE oh.order_date >= NOW() - INTERVAL 1 MONTH
GROUP BY c.customer_id, c.full_name
HAVING total_orders > 5;

-- 11. Ingresos totales generados por productos no elaborados (bebidas, postres, etc.)
SELECT SUM(od.quantity * od.unit_price) AS non_prepared_revenue
FROM order_detail od
JOIN product p ON od.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
WHERE c.category_name IN ('Bebida', 'Postre');

-- 12. Promedio de adiciones por pedido
SELECT AVG(total_toppings) AS average_toppings_per_order
FROM (
    SELECT oh.order_id, COALESCE(SUM(odt.quantity), 0) AS total_toppings
    FROM order_header oh
    LEFT JOIN order_detail od ON oh.order_id = od.order_id
    LEFT JOIN order_detail_topping odt ON od.order_detail_id = odt.order_detail_id
    GROUP BY oh.order_id
) AS subquery;

-- 13. Total de combos vendidos en el último mes

SELECT SUM(od.quantity) AS combos_sold
FROM order_detail od
JOIN order_header oh ON od.order_id = oh.order_id
WHERE od.combo_id IS NOT NULL 
AND oh.order_date >= NOW() - INTERVAL 1 MONTH;
  
-- 14. Clientes con pedidos tanto para recoger como para consumir en el lugar
SELECT c.full_name
FROM customer c
JOIN order_header oh ON c.customer_id = oh.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(DISTINCT oh.delivery_type) = 2;

-- 15. Total de productos personalizados con adiciones
SELECT COUNT(DISTINCT order_detail_id) AS customized_products_count
FROM order_detail_topping;

-- 16. Pedidos con más de 3 productos diferentes
SELECT order_id, COUNT(DISTINCT product_id) AS different_products_count
FROM order_detail
WHERE product_id IS NOT NULL
GROUP BY order_id
HAVING different_products_count > 3;

-- 17. Promedio de ingresos generados por día
SELECT AVG(daily_revenue) AS average_daily_revenue
FROM (
    SELECT DATE(oh.order_date) AS order_day, SUM(od.quantity * od.unit_price) AS daily_revenue
    FROM order_header oh
    JOIN order_detail od ON oh.order_id = od.order_id
    GROUP BY DATE(oh.order_date)
) AS subquery;


-- 18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
SELECT c.full_name
FROM customer c
JOIN order_header oh ON c.customer_id = oh.customer_id
JOIN order_detail od ON oh.order_id = od.order_id
JOIN product p ON od.product_id = p.product_id
JOIN category cat ON p.category_id = cat.category_id
LEFT JOIN order_detail_topping odt ON od.order_detail_id = odt.order_detail_id
WHERE cat.category_name = 'Pizza'
GROUP BY c.customer_id, c.full_name
HAVING (COUNT(DISTINCT CASE WHEN odt.topping_id IS NOT NULL THEN oh.order_id END) / COUNT(DISTINCT oh.order_id)) > 0.5;

-- 19. Porcentaje de ventas provenientes de productos no elaborados
SELECT 
    (SUM(CASE WHEN cat.category_name IN ('Bebida', 'Postre') THEN od.quantity * od.unit_price ELSE 0 END) / 
     SUM(od.quantity * od.unit_price)) * 100 AS non_prepared_sales_percentage
FROM order_detail od
JOIN product p ON od.product_id = p.product_id
JOIN category cat ON p.category_id = cat.category_id;

-- 20. Día de la semana con mayor número de pedidos para recoger

SELECT DAYNAME(order_date) AS day_of_week, COUNT(*) AS pickup_orders_count
FROM order_header
WHERE delivery_type = 'Pickup'
GROUP BY DAYNAME(order_date)
ORDER BY pickup_orders_count DESC
LIMIT 1;




