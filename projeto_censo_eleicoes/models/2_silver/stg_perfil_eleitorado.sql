{{ config(materialized = 'view') }}

-- =====================================================
-- SILVER LAYER
-- Modelo: stg_perfil_eleitorado
-- Descrição: Padronização e limpeza do perfil do eleitorado
-- =====================================================


-- =====================================================
-- BRONZE SOURCE
-- =====================================================
with bronze as (

    select *
    from {{ ref('perfil_eleitorado') }}

),

-- =====================================================
-- COLUMN STANDARDIZATION
-- =====================================================
renamed as (

    select
        cast(ano as int64)          as ano,
        sigla_uf,
        id_municipio,
        id_municipio_tse,
        zona,
        secao,
        genero,
        estado_civil,
        grupo_idade,
        instrucao,
        cast(eleitores as int64)    as eleitores

    from bronze

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

    from renamed

)

-- =====================================================
-- FINAL DATASET
-- =====================================================
select *
from transformed