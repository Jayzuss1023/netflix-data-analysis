-- Check for any changes or updates made on a table
-- keep a history of movie tags from src_tags
-- The unique key is user_id, movie_id, and tag. dbt watches tag_timestamp 
-- closes the old row and inserts a new one.
-- The file packages.yml includes dbt_utils, shared macro library from dbt Labs which offers the snapshot
{% snapshot snap_tags %}
{{
    config(
        target_schema='snapshots',
        unique_key=['user_id', 'movie_id', 'tag'],
        strategy='timestamp',
        updated_at='tag_timestamp',
        invalidate_hard_deletes=True
    )
}}

SELECT
{{ dbt_utils.generate_surrogate_key(['user_id','movie_id','tag']) }} AS row_key,
    user_id,
    movie_id,
    tag,
    CAST(tag_timestamp AS TIMESTAMP_NTZ) AS tag_timestamp
FROM {{ ref('src_tags') }}
LIMIT 100

{% endsnapshot %}

-- A surrogate key is here because one tag row is identified by three columns together,
--  and a snapshot needs a stable identity so it can tell “same tag, new timestamp” from “different tag.”
-- dbt_utils.generate_surrogate_key hashes those three columns into one row_key.