-- JOIN helps us to make a relation with other table(s) by using keys as pivot attributes
SELECT 
    investment.investment, 
    product.product_id,
    product.name,
    product.stock
FROM investment
    LEFT JOIN product ON
    product.product_id = investment.product_id
WHERE 
    investment.investment >= 100000
ORDER BY investment.investment DESC
LIMIT 10 ;

-- adding some operations
SELECT 
    i.investment, 
    p.product_id,
    p.name,
    p.stock,
    ROUND(i.investment / p.price) AS inv_calculated,
    CASE 
        WHEN (i.investment / p.price) = p.stock THEN 'perfect'
        ELSE  'error'
    END AS calculus_error
FROM investment AS i
    LEFT JOIN product AS p ON
    p.product_id = i.product_id
WHERE 
    i.investment >= 100000
ORDER BY i.investment DESC
LIMIT 10 ;

