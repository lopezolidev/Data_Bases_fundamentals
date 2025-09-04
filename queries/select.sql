SELECT product_id, name, price, stock, ROUND((price * stock)::numeric, 0) AS total
FROM product
WHERE 
    price <= 200 
    AND
    stock BETWEEN 50 AND 150 
ORDER BY stock DESC;
-- a somewhat complex SELECT statement

SELECT product_id, name, price, stock, ROUND((price * stock)::numeric, 0) AS total
FROM product
ORDER BY total DESC
LIMIT 10 
OFFSET 1;
