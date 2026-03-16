{{ config(materialized = 'table') }}

with source_data as (
    select 
        *,
        -- Adiciona metadados sem alterar o dado original
        current_timestamp() as _ingested_at,
        '{{ invocation_id }}' as _dbt_run_id
    from {{ source('tse', 'perfil_eleitorado_secao') }}
)

select * from source_data
{% if target.name == 'dev' %}
  where sigla_uf = 'PE' and ano =  2022 -- Amostragem apenas para desenvolvimento
{% endif %}