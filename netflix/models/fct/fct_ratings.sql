-- A fact table is build, one row per user rating of a movie
-- The table is loaded incrementally to allow for new ratings to be added.

{{
    config(
        materialized = 'incremental',
        on_schema_change='fail'
    )
}}

WITH src_ratings AS (
    SELECT * FROM {{ ref('src_ratings') }}
)

SELECT 
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM src_ratings
WHERE rating IS NOT NULL


-- {{ this }} is the existing fct_ratings table. Filter only keeps ratings newer than the latest timestamp stored.
-- New rows are inserted, and existing rows are left as they are
{% if is_incremental() %}
    AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}
