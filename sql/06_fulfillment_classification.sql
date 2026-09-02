-- ============================================================
-- Order Fulfillment Classification
-- ============================================================
-- This view classifies each order according to whether it was
-- fulfilled by sellers located in the same state as the customer
-- or in a different state.
--
-- Because an order may contain items from multiple sellers,
-- BOOL_OR() is used at the order level. If at least one seller
-- is located in a different state from the customer, the order
-- is classified as "Cross State".
--
-- Orders with missing customer or seller state information are
-- classified as "Unknown"; otherwise, they are classified as
-- "Same State".
--
-- The resulting view was imported into Power BI and used to
-- analyze the relationship between fulfillment geography and
-- delivery performance.

CREATE OR REPLACE VIEW order_fulfillment_by_order AS
SELECT
    oi.order_id,
    CASE
        WHEN BOOL_OR(
            c.customer_state IS NOT NULL
            AND s.seller_state IS NOT NULL
            AND c.customer_state <> s.seller_state
        )
            THEN 'Cross State'
        WHEN BOOL_OR(
            c.customer_state IS NULL
            OR s.seller_state IS NULL
        )
            THEN 'Unknown'
        ELSE 'Same State'
    END AS order_fulfillment_type
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
LEFT JOIN olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
GROUP BY oi.order_id;



-- ============================================================
-- Validation
-- ============================================================
-- Verify that orders missing from the fulfillment view are
-- explained by orders that do not have corresponding order items.



-- Orders without order items
SELECT COUNT(*) AS orders_without_items
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- Orders not represented in the fulfillment view
SELECT COUNT(*) AS orders_without_fulfillment
FROM olist_orders_dataset o
LEFT JOIN order_fulfillment_by_order f
    ON o.order_id = f.order_id
WHERE f.order_id IS NULL;
