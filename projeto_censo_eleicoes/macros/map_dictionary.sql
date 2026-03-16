{# 1. Macro apenas para os campos do SELECT #}
{% macro get_mapped_columns(column_mapping) %}
    {%- for id_col, dict_name in column_mapping.items() -%}
        , {{ id_col }}_dict.valor as {{ dict_name }}
    {%- endfor %}
{% endmacro %}

{# 2. Macro apenas para os JOINS #}
{% macro get_mapped_joins(table_id, column_mapping, dict_model=ref('raw_dicionario'), base_alias='base') %}
    {% for id_col, dict_name in column_mapping.items() %}
        left join {{ dict_model }} as {{ id_col }}_dict
            on cast({{ base_alias }}.{{ id_col }} as string) = cast({{ id_col }}_dict.chave as string)
            and {{ id_col }}_dict.nome_coluna = '{{ dict_name }}'
            and {{ id_col }}_dict.id_tabela = '{{ table_id }}'
    {% endfor %}
{% endmacro %}