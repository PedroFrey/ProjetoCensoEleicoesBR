select *
from {{ source('tse','perfil_eleitorado_secao') }}
TABLESAMPLE SYSTEM (1 PERCENT)