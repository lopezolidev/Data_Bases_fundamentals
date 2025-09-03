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

-- inserting a product
INSERT INTO product(name, slug) VALUES('cuaderno', 'slug-cuaderno') ;


-- inserting a bill_product, with the id of the product ('cuaderno')
INSERT INTO bill_product(product_id, bill_id, quantity) VALUES(1, 3, 3) ;


/*----------------------------------------------------------------------------------------------------------------------------*/

-- simple insert
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul');

-- multiple inserts
INSERT INTO product(name, slug, description)
VALUES
	('cuaderno verde', 'cuaderno-verde', 'cuaderno para dibujar'),
	('cuaderno negro', 'cuaderno-negro', 'cuaderno para vender');

-- insert ignoring duplicate values
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON CONFLICT (slug) DO NOTHING; 
-- if there's a conflic with existing table, related to the specific columns in '()' instructs PostgreSQL what should do

-- insert with duplicate value but updating description (on MySQL)
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON DUPLICATE KEY UPDATE description = 'Ejecutado en el ON DUPLICATE' ;

-- in PostgreSQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON CONFLICT (slug) DO UPDATE SET description = 'Ejecutado en el ON CONFLICT';
-- ON CONFLICT (conflicting_columns) DO <ACTION> SET attribute = 'value' ;

-- insert with duplicate value, updating description with a value from the table
-- MySQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON DUPLICATE KEY UPDATE description = values(slug) ; 
-- puts the value of the slug in the description of the register we are inserting (updating in this case)

-- PostgreSQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON CONFLICT (slug) DO UPDATE SET description = EXCLUDED.slug;
-- does the same but using keyword EXCLUDED

-- insert with duplicate value, updating decription with a concatenation of characters
-- MySQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON DUPLICATE KEY UPDATE description = CONCAT('product: ', values(slug)) ; 

-- PostgreSQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON CONFLICT (slug) DO UPDATE SET description = CONCAT('product: ', EXCLUDED.slug);

--insert with duplicate value, updating decription with a mathematical operation
-- MySQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON DUPLICATE KEY UPDATE description = 70 * 8 * 19 ; 

-- PostgreSQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON CONFLICT (slug) DO UPDATE SET description = 70 * 8 * 19;

-- Want to make use of CONCAT function?
SELECT CONCAT('hello ', '0', ' good bye!! ', 'nothing');
/*            
          concat           
 ----------------------------
  hello 0 good bye!! nothing
 (1 fila)
*/

--insert with duplicate value, updating decription with the value of a current column, e.g 'price'
-- MySQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON DUPLICATE KEY UPDATE description = price ; 

-- PostgreSQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azul')
ON CONFLICT (slug) DO UPDATE SET description = product.price;
-- the price will be in the description of the register that has conflict due to the duplicate slug 'cuaderno-azul'
-- will be the price that already exists in the table


-- if we change the slug (therefore we are not affecting the specific value we refered in the past), then the 'fail-safe' approach of the ON CONFLICT is never triggered
-- MySQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azzzzul')
ON DUPLICATE KEY UPDATE description = price ; 

-- PostgreSQL
INSERT INTO product(name, slug)
VALUES('cuaderno azul', 'cuaderno-azzzzzul')
ON CONFLICT (slug) DO UPDATE SET description = product.price;
