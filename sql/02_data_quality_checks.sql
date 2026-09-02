
-- ============================================================
-- Data Quality Checks
-- ============================================================
-- This file contains selected data quality and validation checks
-- performed before building the Power BI data model.
--
-- These checks were used to identify missing values, inconsistent
-- category mappings, duplicate review submissions, and geographic
-- data issues that influenced subsequent cleaning and modeling
-- decisions.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Product Category Completeness
-- ------------------------------------------------------------
-- Check whether missing product categories are represented as
-- empty strings or NULL values.

-- Count empty category names
SELECT COUNT(*) AS empty_category_names
FROM olist_products_dataset
WHERE product_category_name = '';


-- Count NULL category names
SELECT COUNT(*) AS null_category_names
FROM olist_products_dataset
WHERE product_category_name IS NULL;


-- Standardize missing category values by converting empty strings
-- to NULL. This ensures that missing categories are represented
-- consistently throughout subsequent transformations.
UPDATE olist_products_dataset
SET product_category_name = NULL
WHERE product_category_name = '';



-- ------------------------------------------------------------
-- 2. Product Category Translation Coverage
-- ------------------------------------------------------------
-- Identify product categories that do not have a corresponding
-- entry in the Portuguese-to-English category translation table.
--
-- This check helped identify unmatched categories before the
-- translation table was merged with the products table in
-- Power Query.

SELECT DISTINCT
    p.product_category_name
FROM olist_products_dataset AS p
LEFT JOIN product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;



-- ------------------------------------------------------------
-- 3. Duplicate Review Submissions
-- ------------------------------------------------------------
-- Count orders associated with more than one review submission.
-- These duplicates were investigated before using review scores
-- in the Power BI analysis.

SELECT COUNT(*) AS orders_with_multiple_reviews
FROM (
    SELECT
        order_id
    FROM olist_order_reviews_dataset
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicate_review_orders;



-- ------------------------------------------------------------
-- 4. Review Score Consistency Across Duplicate Submissions
-- ------------------------------------------------------------
-- Determine whether the review score remained the same or changed
-- when an order had multiple review submissions.
--
-- This analysis supported the decision to retain the most recent
-- review for each order in the analytical model.

SELECT
    CASE
        WHEN distinct_score_count = 1
            THEN 'Same score across duplicates'
        ELSE 'Different score across duplicates'
    END AS pattern,
    COUNT(*) AS num_orders
FROM (
    SELECT
        order_id,
        COUNT(DISTINCT review_score) AS distinct_score_count
    FROM olist_order_reviews_dataset
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicate_reviews
GROUP BY
    CASE
        WHEN distinct_score_count = 1
            THEN 'Same score across duplicates'
        ELSE 'Different score across duplicates'
    END;



-- ------------------------------------------------------------
-- 5. Geolocation ZIP Code Uniqueness
-- ------------------------------------------------------------
-- Check whether geolocation ZIP code prefixes are unique.
--
-- Multiple records were found for some ZIP code prefixes, meaning
-- the raw geolocation table could not be used directly as a
-- one-row-per-ZIP lookup table.
--
-- This finding led to the creation of a separate geolocation view
-- with one aggregated record per ZIP code prefix.

SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS record_count
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) > 1
ORDER BY record_count DESC;



-- ------------------------------------------------------------
-- 6. Customer ZIP Code Coverage
-- ------------------------------------------------------------
-- Identify customer ZIP code prefixes that do not have a matching
-- record in the geolocation dataset.
--
-- This check was used to assess geographic coverage before
-- enriching customer records with latitude and longitude data.

SELECT DISTINCT
    c.customer_zip_code_prefix
FROM olist_customers_dataset AS c
LEFT JOIN olist_geolocation_dataset AS g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.geolocation_zip_code_prefix IS NULL
ORDER BY c.customer_zip_code_prefix;



