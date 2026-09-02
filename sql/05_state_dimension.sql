-- ============================================================
-- State Dimension
-- ============================================================
-- A distinct list of Brazilian states was created to provide
-- a common state dimension for geographic analysis in Power BI.
--
-- The table is used as a disconnected dimension to compare
-- customer and seller distributions by state without filtering
-- through either the customer or seller table.

create view dim_state as
select distinct geolocation_state as state from olist_geolocation_dataset ogd 
where geolocation_state is not null ;
