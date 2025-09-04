-- first let's create a table called 'investments'
CREATE TABLE IF NOT EXISTS investment(
    investment_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    investment INT NOT NULL DEFAULT 0
);

-- then the insertion into such table must be made
INSERT INTO investment(product_id, investment)
SELECT product_id, stock * price
FROM product ;

-- now we'll query the data just inserted in such table
SELECT *
FROM investment
ORDER BY investment DESC
LIMIT 10;
