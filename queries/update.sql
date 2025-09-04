UPDATE client
SET phone_number = '+529999999999'
WHERE client_id = 150 ;

-- previous phone number +528299300368
/*
-[ RECORD 1 ]+--------------------------
client_id    | 150
name         | Leola Brekke
email        | minerva.yundt@mills.com
phone_number | +529999999999
created_at   | 2025-09-03 17:37:09.11467
modified_at  | 2025-09-03 22:34:51.56268

*/

UPDATE client
SET phone_number = NULL
WHERE client_id IN (
    SELECT client_id
    FROM client
    WHERE name LIKE 'Laura%' OR name LIKE 'Claire%'
    LIMIT 10
); -- in postgreSQL we need to use a subquery, because UPDATE or DELETE doesn't support LIMIT clause

UPDATE product
SET stock = ROUND(100 * RANDOM()) ;

UPDATE product
SET stock = stock - 3 
WHERE product_id = 1119 ;

-- previous: 18 , now ↓
/*
-[ RECORD 2 ]---------------------------------------------------------------------------------------------------------------------------------------
product_id  | 1119
name        | Durable Wooden Pants
sku         | 1722290513013
slug        | durable-wooden-pants
description | Quidem sed nihil optio est est dolorum. Saepe rerum ad qui.
price       | 4703.43
created_at  | 2025-09-03 17:41:19.962871
stock       | 15
modified_at | 2025-09-03 22:59:57.61303
*/