CREATE TABLE client (
    name VARCHAR(50),
    email VARCHAR(20),
    phone_number VARCHAR(15)
) ; -- this table is of no real use. Lacks important attributes

CREATE TABLE product (
    name VARCHAR(20),
    sku VARCHAR(15),
    slug VARCHAR(20),
    description TEXT,
    price FLOAT
) ;
/*
ways to alter the table 'product'

ALTER TABLE product ADD CHECK (name <> '');
ALTER TABLE product ADD CONSTRAINT some_name UNIQUE (product_no);
ALTER TABLE product ADD FOREIGN KEY (product_group_id) REFERENCES product_groups;

removing constraint:
To remove a constraint you need to know its name. If you gave it a name then that's easy. Otherwise the system assigned a generated name, which you need to find out. The psql command \d tablename can be helpful here; other interfaces might also provide a way to inspect table details. Then the command is:

ALTER TABLE products 
DROP CONSTRAINT some_name;

This works the same for all constraint types except not-null constraints. To drop a not null constraint use

ALTER TABLE products 
ALTER COLUMN product_no DROP NOT NULL;

*/


-- more accurate implementation of 'client' table
CREATE TABLE client(
    client_id SERIAL PRIMARY KEY, -- unsigned integer that autoincrements
    name VARCHAR(50),
    email VARCHAR(20) UNIQUE, -- the email is unique inside the DB
    phone_number VARCHAR(15) NOT NULL, -- phone number is mandatory
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP -- a TRIGGER must be created for this update
); 

-- if we want to alter the table in such a way that accomodates to the new data sceme:
ALTER TABLE client
ALTER COLUMN name TYPE VARCHAR(100),
ALTER COLUMN name SET NOT NULL -- name will be limited to 100 characters and will not be null
ALTER COLUMN email TYPE VARCHAR(100),
ALTER COLUMN email SET NOT NULL ,
ADD CONSTRAINT unique_email UNIQUE (email) ,-- email will be limited to 100 characters, not null and will be unique → the constraint is called 'unique_email'
-- DROP CONSTRAINT unique_email ← To drop a UNIQUE constraint. 
-- The DROP CONSTRAINT command is used to delete a UNIQUE, PRIMARY KEY, FOREIGN KEY, or CHECK constraint.
ALTER COLUMN phone_number DROP NOT NULL; -- erasing 'not null' constraint of phone_number field



-- TRIGGER creation as a function
CREATE OR REPLACE FUNCTION update_modified_at()
RETURNS TRIGGER 
AS $$
BEGIN
    NEW.modified_at = NOW() ;
    RETURN NEW;
END ;
$$ LANGUAGE plpgsql ;

-- asigning of TRIGGER to table
CREATE TRIGGER client_modified_at_trigger
BEFORE UPDATE ON client
FOR EACH ROW
EXECUTE FUNCTION update_modified_at() ;


/*-----------------------------------------------------------------------------------------------------------*/

-- accurate representation of 'product' table
CREATE TABLE IF NOT EXISTS product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(200) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP -- a TRIGGER must be created (or assigned) for this update
);

-- as the trigger of modified_at already exists, we can reuse it for 'product' table
CREATE TRIGGER product_modified_at_trigger
BEFORE UPDATE ON product
FOR EACH ROW
EXECUTE FUNCTION update_modified_at() ;

/*-----------------------------------------------------------------------------------------------------------*/

-- first we need to create the ENUM data type
CREATE TYPE status_enum AS ENUM ('open', 'partial', 'paid', 'closed') ;

-- accurate representation of 'bill' table
CREATE TABLE IF NOT EXISTS bill (
    bill_id SERIAL PRIMARY KEY,
    client_id INT , 
    total FLOAT ,
    status status_enum DEFAULT 'open',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- a TRIGGER must be assigned for this update     
    CONSTRAINT fk_client_id FOREIGN KEY (client_id) 
    REFERENCES client(client_id) -- inline reference to parent table
        ON UPDATE CASCADE
        ON DELETE CASCADE -- added to keep referential integrity among client - bill tables
    /*
        thanks to this, when a register changes its id (rare) on client table, the register(s) that reference it in bill table
        will be updated too.
        Also when the registers in client table referenced in bill table are deleted, the referencing registers in bill table will
        be deleted
        ↓
        ↓
        this is changed onward altering the table and dropping the constraint
    */
);

CREATE TRIGGER bill_modified_at_trigger
BEFORE UPDATE ON bill
FOR EACH ROW
EXECUTE FUNCTION update_modified_at() ;

/*-----------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS bill_product(
    bill_product_id SERIAL PRIMARY KEY , -- in postgreSQL SERIAL makes it like unsigned by default, starts from 1 instead of 0
    product_id INT NOT NULL ,
    bill_id INT NOT NULL ,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_product_id FOREIGN KEY (product_id)
    REFERENCES product(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_bill_id FOREIGN KEY (bill_id)
    REFERENCES bill(bill_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    /*
        This "hard" relation then becomes "soft" by dropping this constraints
    */
);


/*-----------------------------------------------------------------------------------------------------------*/


ALTER TABLE bill
DROP CONSTRAINT fk_client_id ;
-- now 'bill' table won't have a reference to 'client' table, and therefore the relation becomes "soft"

ALTER TABLE bill_product
DROP CONSTRAINT fk_product_id,
DROP CONSTRAINT fk_bill_id ;
-- same here for product_id and bill_id → we can have bill_product records of products and bills that do not exist

/*-----------------------------------------------------------------------------------------------------------*/
-- we need to add the 'sku' column to product table and also modify name and slug

ALTER TABLE product 
ADD COLUMN sku VARCHAR(20) NOT NULL UNIQUE ;

ALTER TABLE product 
ALTER COLUMN name TYPE VARCHAR(50),
ALTER COLUMN name SET NOT NULL, 
ALTER COLUMN slug TYPE VARCHAR(50),
ALTER COLUMN slug SET NOT NULL UNIQUE ;
