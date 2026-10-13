-- a fact table of how relevant each genome tag is to each movie.
-- This fact model does not touch the raw table.
WITH src_scores AS (
    SELECT * FROM {{ ref('src_genome_score') }}
)

SELECT
    movie_id,
    tag_id,
    -- relevance rounded to four decimal places
    ROUND(relevance, 4) AS relevance_score
FROM src_scores
-- drops tags that have no relevance for that movie
WHERE relevance > 0