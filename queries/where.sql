SELECT *
FROM client
WHERE name LIKE '%IV' ;

SELECT *
FROM client
WHERE name LIKE '%III' ;

SELECT *
FROM client
WHERE name LIKE '%Gibson%' ;

SELECT *
FROM product
WHERE price <= 100 ;

SELECT *
FROM product 
WHERE price * 10 < 5000 ;

SELECT *
FROM product
WHERE price BETWEEN 100 AND 120 ;

SELECT *
FROM bill_product 
WHERE discount > 0 ;

SELECT *
FROM bill_product
WHERE date_added < '2024-06-02';


SELECT *
FROM bill_product
WHERE date_added BETWEEN '2024-06-02' AND '2024-09-15 14:50:00';


SELECT *
FROM bill_product
WHERE 
    date_added BETWEEN '2024-06-02' AND '2024-06-30 14:50:00'
    AND
    product_id BETWEEN 1 AND 99;

SELECT * 
FROM client
WHERE client_id = 150 ;