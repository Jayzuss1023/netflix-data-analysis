-- genome tags and their relevance scores attached to each movie.
-- An ephemeral model is not stored in the warehouse. There is no table and no view.

{{
    config(
        materialized = 'ephemeral'
    )
}}

WITH movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),
tags AS (
    SELECT * FROM {{ ref("dim_genome_tags") }}
),
scores AS (
    SELECT * FROM {{ ref('fct_genome_scores') }}
)

SELECT
    m.movie_id,
    m.movie_title,
    m.generes,
    t.tag_name,
    s.relevance_score
FROM movies materialized
LEFT JOIN scores s on m.movie_id = s.movie_id
LEFT JOIN tags ON t.tag_id = s.tag_id