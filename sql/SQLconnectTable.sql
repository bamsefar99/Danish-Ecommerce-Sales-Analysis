
ALTER TABLE orders_dk CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_danish_ci;
ALTER TABLE customers_dk CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_danish_ci;
ALTER TABLE products_dk CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_danish_ci;




UPDATE customers_dk
SET Adresse = CONVERT(CAST(Adresse AS BINARY) USING latin1);
SELECT * FROM customers_dk;
UPDATE orders_dk
SET product_category = CONVERT(CAST(product_category AS BINARY) USING latin1);

CREATE VIEW VM_RestecustomersData AS
SELECT
    TRIM(c.customerName) AS customerName,
    CONCAT(
        UPPER(LEFT(TRIM(c.Adresse),1)),
        LOWER(SUBSTRING(TRIM(c.Adresse),2))
    ) AS Adresse
FROM customers_dk c
WHERE c.customer_id IS NOT NULL;

SELECT
    TRIM(c.customerName) AS customerName,
    CONCAT(
        UPPER(LEFT(TRIM(c.Adresse),1)),
        LOWER(SUBSTRING(TRIM(c.Adresse),2))
    ) AS Adresse
FROM customers_dk c
WHERE c.customer_id IS NOT NULL;






SELECT 
    p.product_category,
    SUM(o.TotalPrice) AS total_revenue
FROM orders_dk o
JOIN products_dk p ON o.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;



SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    ROUND(SUM(TotalPrice), 2) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders_dk
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY month;


SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(TotalPrice) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders_dk
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY month;


SELECT 
    c.Adresse,
    AVG(DATEDIFF(o.shipping_date, o.order_date)) AS avg_delivery_days
FROM orders_dk o
JOIN customers_dk c ON o.customer_id = c.customer_id
WHERE o.shipping_date IS NOT NULL
GROUP BY c.Adresse
ORDER BY avg_delivery_days;


SELECT 
    ROUND(DATEDIFF(o.shipping_date, o.order_date) * 2) / 2 AS levering_dage,
    COUNT(*) AS antal_ordrer
FROM orders_dk o
WHERE o.shipping_date IS NOT NULL
GROUP BY levering_dage
ORDER BY levering_dage;


SELECT
    c.Adresse,
    ROUND(DATEDIFF(o.shipping_date, o.order_date) * 2) / 2 AS levering_dage,
    COUNT(*) AS antal_ordrer
FROM orders_dk o
JOIN customers_dk c ON o.customer_id = c.customer_id
WHERE o.shipping_date IS NOT NULL
GROUP BY c.Adresse, levering_dage
ORDER BY c.Adresse, levering_dage;
SELECT 
    p.product_name,
    SUM(o.TotalPrice) AS total_revenue
FROM orders_dk o
JOIN products_dk p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;



SELECT 
    c.customer_id,
    c.customerName,
    SUM(o.TotalPrice) AS lifetime_value,
    COUNT(o.order_id) AS total_orders
FROM customers_dk c
LEFT JOIN orders_dk o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customerName
ORDER BY lifetime_value DESC;


SELECT 
    p.product_category,
    AVG(p.unit_price) AS avg_unit_price,
    MIN(p.unit_price) AS min_unit_price,
    MAX(p.unit_price) AS max_unit_price
FROM products_dk p
GROUP BY p.product_category
ORDER BY avg_unit_price DESC;

