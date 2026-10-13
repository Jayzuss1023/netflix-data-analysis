-- This file  sits one layer above src_movies.sql. Downstream models should use ref('dim_movies'), not the raw table.
-- Shape an entity for analysis
--  Parse, standardize, and combine fields

-- dbt builds src_movies first and reads the model. 
WITH src_movies AS (
    SELECT * FROM {{ ref('src_movies') }}
)

SELECT
    movie_id,
    --  strips leading and trailing spaces, then title-cases the result (first letter of each word uppercase)
    INITCAP(TRIM(title)) AS movie_title,
    -- "Action|Adventure|Sci-Fi" becomes ['Action', 'Adventure', 'Sci-Fi']
    SPLIT(genres, '|') AS genre_array,
    genres
FROM src_movies