-- this is a logical erasing
ALTER TABLE client
ADD COLUMN active BOOLEAN NOT NULL DEFAULT TRUE ;

UPDATE client
SET active = FALSE
WHERE client_id = 1111 ; -- now this register doesn't "exist" in the DB

-- this is hard / physical erasing
-- we want to delete the following records:
SELECT *
FROM client
WHERE name LIKE 'Mr.%DVM' ;

DELETE FROM client
WHERE name LIKE 'Mr.%DVM' ; -- this records where deleted from the table 'client' 


