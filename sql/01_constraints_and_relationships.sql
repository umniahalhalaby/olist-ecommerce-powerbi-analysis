-- ============================================================
-- Constraints and Relationships
-- ============================================================
-- After importing the source datasets into PostgreSQL, primary
-- and foreign key constraints were added where the data structure
-- supported valid relational integrity.
--
-- Key columns were validated before assigning primary keys.
-- Foreign keys were then defined to establish relationships
-- between the imported tables.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Orders
-- ------------------------------------------------------------
-- Verify that order_id is unique before defining it as the
-- primary key of the orders table.

SELECT
    order_id,
    COUNT(*) AS record_count
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Define order_id as the primary key
ALTER TABLE olist_orders_dataset
ADD PRIMARY KEY (order_id);



-- ------------------------------------------------------------
-- 2. Order Items → Orders
-- ------------------------------------------------------------
-- Establish the relationship between order items and orders.
-- Each order item must reference an existing order.

ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset (order_id);



-- ------------------------------------------------------------
-- 3. Sellers
-- ------------------------------------------------------------
-- Define seller_id as the primary key of the sellers table.

ALTER TABLE olist_sellers_dataset
ADD PRIMARY KEY (seller_id);


-- Establish the relationship between order items and sellers.
-- Each seller referenced in an order item must exist in the
-- sellers table.

ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_order_items_seller
FOREIGN KEY (seller_id)
REFERENCES olist_sellers_dataset (seller_id);



-- ------------------------------------------------------------
-- 4. Customers
-- ------------------------------------------------------------
-- Define customer_id as the primary key of the customers table.

ALTER TABLE olist_customers_dataset
ADD PRIMARY KEY (customer_id);


-- Establish the relationship between orders and customers.
-- Each order must reference an existing customer.

ALTER TABLE olist_orders_dataset
ADD CONSTRAINT fk_order_customer
FOREIGN KEY (customer_id)
REFERENCES olist_customers_dataset (customer_id);




-- ------------------------------------------------------------
-- 5. Products
-- ------------------------------------------------------------
-- Define product_id as the primary key of the products table.

ALTER TABLE olist_products_dataset
ADD PRIMARY KEY (product_id);


-- Establish the relationship between order items and products.
-- Each product referenced in an order item must exist in the
-- products table.

ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES olist_products_dataset (product_id);



-- ------------------------------------------------------------
-- 6. Reviews → Orders
-- ------------------------------------------------------------
-- Establish the relationship between review records and orders.
-- An order may have more than one review submission in the raw
-- dataset; this issue is investigated separately in the data
-- quality checks and handled during review preparation.

ALTER TABLE olist_order_reviews_dataset
ADD CONSTRAINT fk_order_reviews_order
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset (order_id);
