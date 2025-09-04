-- total number of products
SELECT COUNT(*)
FROM product ;

-- total number of stock
SELECT SUM(stock)
FROM product ;

-- average product price
SELECT AVG(price)
FROM product ;

-- total investment
SELECT SUM(price * stock) AS total
FROM product ;

-- Using if statement (only works in MySQL)
SELECT
    name,
    email,
    IF(email LIKE '%gmail.com', 1, 0) AS gmail,
    IF(email LIKE '%hotmail.com', 1, 0) AS hotmail
FROM client
ORDER BY RANDOM()
LIMIT 30 ;

-- in PostgreSQL
SELECT
    name,
    email,
    CASE WHEN email LIKE '%gmail.com' THEN 1 ELSE 0 END AS gmail,
    CASE WHEN email LIKE '%hotmail.com' THEN 1 ELSE 0 END AS hotmail
FROM client
ORDER BY RANDOM()
LIMIT 30;

-- now putting the email provider in the column as it is
SELECT
    name,
    email,
    CASE 
        WHEN email LIKE '%gmail.com' THEN 'gmail'
        WHEN email LIKE '%hotmail.com' THEN 'hotmail'
        WHEN email LIKE '%yahoo.com' THEN 'yahoo'
        ELSE 'otro proveedor'
    END AS proveedor
FROM client
ORDER BY RANDOM()
LIMIT 30;

-- grouping based on the email provider and counting how many of them are
SELECT
    CASE 
        WHEN email LIKE '%gmail.com' THEN 'gmail'
        WHEN email LIKE '%hotmail.com' THEN 'hotmail'
        WHEN email LIKE '%yahoo.com' THEN 'yahoo'
        WHEN email LIKE '%kozey.com' THEN 'kozey'
        ELSE 'otro proveedor'
    END AS proveedor,
    COUNT(*) AS total_clientes
FROM client
GROUP BY proveedor
ORDER BY total_clientes ASC;
/*
   proveedor    | total_clientes 
----------------+----------------
 kozey          |             62
 hotmail        |          15811
 gmail          |          15887
 yahoo          |          16080
 otro proveedor |          49987
*/

-- using HAVING clause to filter the groups by the criterion they're formed
SELECT
    CASE 
        WHEN email LIKE '%gmail.com' THEN 'gmail'
        WHEN email LIKE '%hotmail.com' THEN 'hotmail'
        WHEN email LIKE '%yahoo.com' THEN 'yahoo'
        WHEN email LIKE '%kozey.com' THEN 'kozey'
        ELSE 'otro proveedor'
    END AS proveedor,
    COUNT(*) AS total_clientes
FROM client
WHERE 
    name LIKE 'A%'
GROUP BY proveedor
HAVING COUNT(*) < 200 
-- HAVING must be used after aggregation functions are made, but the column where it's used does not exists yet 
ORDER BY total_clientes ASC;

