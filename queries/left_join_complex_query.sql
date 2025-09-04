-- we want to know how many products each client bought and the total sum of each purchase considering discount 
SELECT
    b.bill_id,
    b.status,
    c.name,
    COUNT(bp.product_id) AS number_of_products,
    ROUND(SUM(bp.quantity * p.price * (1 - bp.discount/100))::NUMERIC, 2) AS total_value,
    CONCAT('El cliente ', c.name, ' tiene una cuenta ', b.status, ' con ', COUNT(bp.product_id), ' productos y suma $', ROUND(SUM(bp.quantity * p.price * (1 - bp.discount/100))::NUMERIC, 2)) AS res
FROM 
    bill AS b 
    LEFT JOIN client AS c
        ON b.client_id = c.client_id 
    LEFT JOIN bill_product AS bp
        ON bp.bill_id = b.bill_id
    LEFT JOIN product AS p   
        ON p.product_id = bp.product_id
GROUP BY 
    b.bill_id, c.name;


-- teacher's gift
SELECT
    c.quality_lecture,
    p.name,
    CONCAT('Estas ', COUNT(*), ' clases fueron muy buenas') AS calificacion
FROM
    course AS c
LEFT JOIN professor AS p
    ON c.professor_id = p.professor_id
WHERE
    p.nickname LIKE '%Beco%'
GROUP BY
    c.quality_lecture, p.name
ORDER BY
    c.quality_lecture DESC;