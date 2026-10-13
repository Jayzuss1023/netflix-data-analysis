-- UNCOMMENT - TEST IF ALL RELEVANT SCORES ARE GREATER THAN 0

-- SELECT
--     movie_id,
--     tag_id,
--     relevance_score
-- FROM {{ ref('fct_genome_scores') }}
-- WHERE relevance_score <= 0

-- Passing in this reusable test from netflix/macros/no_nulls_in_columns.sql
-- Works by passing in the model
{{ no_nulls_in_columns(ref('fct_genome_scores'))}}