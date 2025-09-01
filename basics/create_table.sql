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


-- more accurate implementation of 'client' table
CREATE TABLE client(
    client_id SERIAL PRIMARY KEY, -- unsigned integer that autoincrements
    name VARCHAR(50),
    email VARCHAR(20) NOT NULL UNIQUE, -- the email is unique inside the DB
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
ADD CONSTRAINT unique_email UNIQUE (email) ,-- email will be limited to 100 characters, not null and will be unique
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
