{{ config(materialized = 'table') }}

-- =====================================================
-- BRONZE SOURCE
-- =====================================================
with bronze as (

    select *
    from {{ ref('raw_detalhes_votacao_secao') }}

),

-- =====================================================
-- COLUMN STANDARDIZATION names and Types and columns selection
-- =====================================================
renamed as (

    select
        cast(ano as int64)              as ano,
        sigla_uf,
        cast(id_municipio as int64)     as id_municipio,
        cast(id_municipio_tse as int64) as id_municipio_tse,
        zona,
        secao,
        cast(genero as int64)           as id_genero,
        cast(estado_civil as int64)     as id_estado_civil,
        cast(grupo_idade as int64)      as id_grupo_idade,
        cast(instrucao as int64)        as id_instrucao,
        cast(eleitores as int64)        as eleitores

    from bronze

),

-- =====================================================
-- COLUMN MAPPING via Macro
-- =====================================================
mapeamento as (
    select
        renamed.*
        {{ get_mapped_columns(column_mapping={
            'id_genero': 'genero',
            'id_estado_civil': 'estado_civil',
            'id_grupo_idade': 'grupo_idade',
            'id_instrucao': 'instrucao'
        }) }}
    from renamed
    {{ get_mapped_joins(
        table_id='perfil_eleitorado_secao',
        column_mapping={
            'id_genero': 'genero',
            'id_estado_civil': 'estado_civil',
            'id_grupo_idade': 'grupo_idade',
            'id_instrucao': 'instrucao'
        },
        base_alias='renamed'
    ) }}
),

-- =====================================================
-- TRANSFORMATIONS
-- Agrupamento de faixa etária + criação de chave
-- =====================================================
transformed as (

    select
        *,

        -- Agrupamento de faixa etária
        case
            when grupo_idade in ('16 anos','17 anos','18 anos','19 anos')
                then '16 a 19 anos'

            when grupo_idade in ('20 anos','21 a 24 anos','25 a 29 anos')
                then '20 a 29 anos'

            when grupo_idade in ('30 a 34 anos','35 a 39 anos')
                then '30 a 39 anos'

            when grupo_idade in ('40 a 44 anos','45 a 49 anos')
                then '40 a 49 anos'

            when grupo_idade in ('50 a 54 anos','55 a 59 anos')
                then '50 a 59 anos'

            else '60+ anos'
        end as gp_faixa_etaria,

        -- Chave única de localização
        concat(
            'Z', cast(zona as string),
            'S', cast(secao as string)
        ) as loc_key

    from mapeamento

)

-- =====================================================
-- FINAL DATASET
-- =====================================================
select *
from transformed