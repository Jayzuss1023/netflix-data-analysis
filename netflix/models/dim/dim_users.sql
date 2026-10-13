--  user dimension gets created: one row per person who has rated a movie or applied a tag.
-- Each CTE keeps only distinct user_id values. The final query unions those two sets, so a user who both rated and tagged appears once.

WITH ratings AS (
    SELECT DISTINCT user_id FROM {{ ref('src_ratings') }}
),

tags AS (
    SELECT DISTINCT user_id FROM {{ ref('src_tags') }}
)

SELECT DISTINCT user_id
FROM (
    SELECT * FROM ratings
    UNION
    SELECT * FROM tags
)