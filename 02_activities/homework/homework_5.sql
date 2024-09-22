-- Cross Join
/*1. Suppose every vendor in the `vendor_inventory` table had 5 of each of their products to sell to **every** 
customer on record. How much money would each vendor make per product? 
Show this by vendor_name and product name, rather than using the IDs.

HINT: Be sure you select only relevant columns and rows. 
Remember, CROSS JOIN will explode your table rows, so CROSS JOIN should likely be a subquery. 
Think a bit about the row counts: how many distinct vendors, product names are there (x)?
How many customers are there (y). 
Before your final group by you should have the product of those two queries (x*y).  */
-- INSERT

-- step 1: select the products that each vendor provides and their average original prices
DROP TABLE IF EXISTS vi; 

CREATE TEMPORARY TABLE vi AS
	SELECT distinct vendor_id, product_id, avg(original_price) as price
	from vendor_inventory
	GROUP by vendor_id, product_id;

-- step 2: create a new table with the vendor name and the product name from other tables
DROP TABLE IF EXISTS vp; 

CREATE TEMPORARY TABLE vp AS
	SELECT vi.*, vendor.vendor_name, product.product_name
	from vi
	LEFT JOIN vendor on vi.vendor_id = vendor.vendor_id
	LEFT JOIN product on vi.product_id = product.product_id;

-- step 3: cross join the [ unique vendor - product], and [customer_id], and calculate sale per customer for 5 of each product  
DROP TABLE IF EXISTS vpc;

CREATE TEMPORARY TABLE vpc AS
	SELECT vp.*, c.customer_id, price*5 as sale_per_customer_5_pcs
	from vp
	CROSS JOIN (SELECT DISTINCT customer_id from customer) as c;

 -- step 4: group and calculate : how much money would each vendor make per product?

 SELECT vendor_name, product_name, sum(sale_per_customer_5_pcs) as sale_per_product
	from vpc
	GROUP by vendor_name, product_name;

/*1.  Create a new table "product_units". 
This table will contain only products where the `product_qty_type = 'unit'`. 
It should use all of the columns from the product table, as well as a new column for the `CURRENT_TIMESTAMP`.  
Name the timestamp column `snapshot_timestamp`. */

CREATE TABLE product_units AS
	SELECT *, CURRENT_TIMESTAMP AS snapshot_timestamp
	FROM product
	WHERE product_qty_type = 'unit';

/*2. Using `INSERT`, add a new row to the product_units table (with an updated timestamp). 
This can be any product you desire (e.g. add another record for Apple Pie). */

INSERT INTO product_units (product_id, product_name, product_qty_type, snapshot_timestamp)
VALUES (
    (SELECT COALESCE(MAX(product_id), 0) + 1 FROM product_units), 
    'Swiss Cheese', 
    'unit', 
    CURRENT_TIMESTAMP
);


-- DELETE
/* 1. Delete the older record for the whatever product you added. 

HINT: If you don't specify a WHERE clause, you are going to have a bad time.*/

DELETE FROM product_units 
WHERE product_name = 'Swiss Cheese';


-- UPDATE
/* 1.We want to add the current_quantity to the product_units table. 
First, add a new column, current_quantity to the table using the following syntax.

ALTER TABLE product_units
ADD current_quantity INT;

Then, using UPDATE, change the current_quantity equal to the last quantity value from the vendor_inventory details.

HINT: This one is pretty hard. 
First, determine how to get the "last" quantity per product. 
Second, coalesce null values to 0 (if you don't have null values, figure out how to rearrange your query so you do.) 
Third, SET current_quantity = (...your select statement...), remembering that WHERE can only accommodate one column. 
Finally, make sure you have a WHERE statement to update the right row, 
	you'll need to use product_units.product_id to refer to the correct row within the product_units table. 
When you have all of these components, you can run the update statement. */


ALTER TABLE product_units
ADD current_quantity INT;

-- step 1: create a temp table which ranks dates in vendor_inventory partition by product_id
DROP TABLE IF EXISTS inventory_day_ranked; 

CREATE TEMPORARY TABLE inventory_day_ranked AS
	SELECT product_id, quantity, market_date, original_price,
        RANK() OVER (PARTITION BY product_id ORDER BY market_date DESC) AS recent_date_rank
FROM vendor_inventory;


- step 2: create a temp table of which only contains the latest-date inventory of any product_id
DROP TABLE IF EXISTS latest_inventory;

CREATE TEMPORARY TABLE latest_inventory AS
	SELECT  product_id, quantity, market_date
    FROM inventory_day_ranked
    WHERE recent_date_rank = 1;

-- step3: update quantity in product units where there is a product_id match in late_inventory
UPDATE  product_units as pu
SET current_quantity = coalesce(li.quantity,0)
FROM latest_inventory as li
WHERE pu.product_id = li.product_id;

-- step 4: update quantity in product units to 0 where there is no  product_id match in late_inventory
UPDATE product_units AS pu
SET current_quantity = 0
WHERE pu.product_id NOT IN (
    SELECT li.product_id 
    FROM latest_inventory AS li);
	