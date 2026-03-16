{{ config(materialized = 'table') }}

with source_data as (
    select 
        id_tabela,nome_coluna,chave,valor,
        -- Adiciona metadados sem alterar o dado original
        current_timestamp() as _ingested_at,
        '{{ invocation_id }}' as _dbt_run_id
    from {{ source('tse', 'dicionario') }}
)

select * from source_data
