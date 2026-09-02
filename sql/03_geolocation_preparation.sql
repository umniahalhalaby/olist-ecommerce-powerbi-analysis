-- ============================================================
-- Geolocation Preparation
-- ============================================================
-- The raw geolocation dataset contains multiple records for
-- the same ZIP code prefix, so the ZIP prefix could not be used
-- directly as a unique lookup key.
--
-- A geolocation view was created with one row per ZIP code prefix.
-- Latitude and longitude are represented by their average values,
-- while the most frequently occurring city and state are retained.
--
-- The resulting view was imported into Power BI and used in
-- Power Query to enrich the customer table with
-- geographic information.

CREATE OR REPLACE VIEW dim_geolocation AS
SELECT
    geolocation_zip_code_prefix AS zip_code_prefix,
    AVG(geolocation_lat) AS lat,
    AVG(geolocation_lng) AS lng,
    MODE() WITHIN GROUP (ORDER BY geolocation_city) AS city,
    MODE() WITHIN GROUP (ORDER BY geolocation_state) AS state
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix;
