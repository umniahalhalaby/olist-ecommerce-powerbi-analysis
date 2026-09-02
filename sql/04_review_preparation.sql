-- ============================================================
-- Review Preparation
-- ============================================================

-- Some orders contain multiple review submissions.
-- To provide one review score per order for the Power BI model,
-- the most recent review is retained.
-- review_answer_timestamp is used as a tiebreaker when
-- review_creation_date is the same.

create or replace view dim_order_reviews as
select distinct on (order_id)
review_id,
order_id,
review_score
from olist_order_reviews_dataset
order by order_id,review_creation_date desc, review_answer_timestamp desc;
