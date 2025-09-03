CREATE TABLE test(
    test_id SERIAL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL,
    qty INT ,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE test
ADD COLUMN price FLOAT ;

ALTER TABLE test
DROP COLUMN price ;

-- modify position of a column inside the table in MySQL
ALTER TABLE test
ADD COLUMN price FLOAT FIRST ;

ALTER TABLE test
ADD COLUMN price FLOAT AFTER qty ;

-- In PostgreSQL we don't have those commands, therefore we must create the table again but with the order we like:
DROP TABLE test ;

CREATE TABLE test(
    price FLOAT ,
    test_id SERIAL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL ,
    qty INT ,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- now putting price after qty:
DROP TABLE test ;

CREATE TABLE test(
    test_id SERIAL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL ,
    qty INT ,
    price FLOAT ,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--change data type and adding a constraint in MySQL
ALTER TABLE test
ALTER COLUMN price DECIMAL(10, 3) NOT NULL ;

--change data type and adding a constraint in PostgreSQL

ALTER TABLE test
ALTER COLUMN price TYPE NUMERIC(10, 3),
ALTER COLUMN price SET NOT NULL;

-- modifying the name of a column in MySQL and PostgreSQL
ALTER TABLE test
RENAME COLUMN price TO prices ;

-- modify the name of a table in MySQL and PostgreSQL
ALTER TABLE test
RENAME TO tests ;

-- modify the specific attribute of a column in a table
ALTER TABLE tests
ALTER COLUMN prices SET DEFAULT 10000 ;


-- altering product table to add price column 
ALTER TABLE product 
ADD COLUMN price FLOAT ;

-- setting price to a random value for every product
-- MySQL
UPDATE product
SET price = RAND() * 100 ;

-- PostgreSQL
UPDATE product
SET price = ROUND((RANDOM() * 100)::numeric , 2);
-- limiting to 2 decimals after the colon