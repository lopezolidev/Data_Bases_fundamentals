INSERT INTO bill(client_id, total) VALUES(10, 15.00) ; 
-- this will result in a logical error, due to the non-existence of a client of id = 10, it's because a referencing concern
/*
ERROR:  insert or update on table "bill" violates foreign key constraint "fk_client_id"
DETALLE:  Key (client_id)=(10) is not present in table "client".
*/

-- first we must insert into table 'client'
INSERT INTO client(client_id, name, email) VALUES(10, 'javier', 'javier6239@gmail.com') ;

-- now after doing the other insert ` INSERT INTO bill(client_id, total) VALUES(10, 15.00) ; `  we have
/* select * from bill ;
  bill_id | client_id | total | status |         created_at         |        modified_at         
 ---------+-----------+-------+--------+----------------------------+----------------------------
        2 |        10 |    15 | open   | 2025-09-01 22:34:23.030746 | 2025-09-01 22:34:23.030746
*/


-- what if we want to update the id of such client? 
UPDATE client 
SET client_id = 11 
WHERE client_id = 10 ;
/*
ERROR:  update or delete on table "client" violates foreign key constraint "fk_client_id" on table "bill"
DETALLE:  Key (client_id)=(10) is still referenced from table "bill".

this foreign key is referenced in 'bill' table, where client_id of first register is with value 10, and cannot be changed to 11, because that would mean the client whose id is 11 now, stopped existing in the DB
*/