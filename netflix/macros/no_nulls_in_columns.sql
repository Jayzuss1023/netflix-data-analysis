-- a reusable dbt test. It fails if any row in a model has a null in any column.
-- adapter.get_columns_in_relation(model) looks up every column on the model in the warehouse, so the test does not hardcode column names.

{% macro no_nulls_in_columns(model) %}
    SELECT * FROM {{ model }} WHERE
    {% for col in adapter.get_columns_in_relation(model) %}
        {{ col.column }} IS NULL OR
    {% endfor %}
    FALSE
{% endmacro %}

-- The loop turns those columns into col_a IS NULL OR col_b IS NULL OR .... A row matches if any column is null.
-- Compiled against a two-column model, it looks like this:
-- SELECT * FROM my_model WHERE
--     movie_id IS NULL OR
--     movie_title IS NULL OR
--     FALSE