

/*
=========================================================
 PROJETO: Análise do Perfil e Comportamento de Investidores
 BANCO: SQL Server

 OBJETIVO:
 Explorar o perfil dos participantes e analisar suas
 preferências e comportamentos de investimento.

 OBSERVAÇÃO:
 A base contém 40 participantes. Os resultados representam
 apenas os participantes da pesquisa e não devem ser
 generalizados para todos os investidores.
=========================================================
*/


-- Quantidade total de registros
SELECT
    COUNT(*) AS total_registros
FROM dbo.Finance_data;


-- Verificação de valores nulos
-- COUNT(*) - COUNT(coluna) retorna a quantidade de NULLs

SELECT
    COUNT(*) AS total_registros,

    COUNT(*) - COUNT(gender) AS null_gender,
    COUNT(*) - COUNT(age) AS null_age,
    COUNT(*) - COUNT(Investment_Avenues) AS null_investment_avenues,

    COUNT(*) - COUNT(Mutual_Funds) AS null_mutual_funds,
    COUNT(*) - COUNT(Equity_Market) AS null_equity_market,
    COUNT(*) - COUNT(Debentures) AS null_debentures,
    COUNT(*) - COUNT(Government_Bonds) AS null_government_bonds,
    COUNT(*) - COUNT(Fixed_Deposits) AS null_fixed_deposits,
    COUNT(*) - COUNT(PPF) AS null_ppf,
    COUNT(*) - COUNT(Gold) AS null_gold,

    COUNT(*) - COUNT(Stock_Marktet) AS null_stock_market,
    COUNT(*) - COUNT(Factor) AS null_factor,
    COUNT(*) - COUNT(Objective) AS null_objective,
    COUNT(*) - COUNT(Purpose) AS null_purpose,
    COUNT(*) - COUNT(Duration) AS null_duration,
    COUNT(*) - COUNT(Invest_Monitor) AS null_invest_monitor,
    COUNT(*) - COUNT(Expect) AS null_expect,
    COUNT(*) - COUNT(Avenue) AS null_avenue,
    COUNT(*) - COUNT(What_are_your_savings_objectives) AS null_savings_objectives,

    COUNT(*) - COUNT(Reason_Equity) AS null_reason_equity,
    COUNT(*) - COUNT(Reason_Mutual) AS null_reason_mutual,
    COUNT(*) - COUNT(Reason_Bonds) AS null_reason_bonds,
    COUNT(*) - COUNT(Reason_FD) AS null_reason_fd,
    COUNT(*) - COUNT(Source) AS null_source

FROM dbo.Finance_data;


-- Estatísticas da idade dos participantes

SELECT
    MAX(age) AS maior_idade,
    MIN(age) AS menor_idade,
    AVG(age) AS idade_media,
    COUNT(DISTINCT age) AS idades_distintas
FROM dbo.Finance_data;


-- Distribuição dos participantes por idade

SELECT
    age,
    COUNT(*) AS quantidade
FROM dbo.Finance_data
GROUP BY age
ORDER BY quantidade DESC;



-- Quantidade de participantes por gênero
-- e participação percentual no total da pesquisa

WITH divisao_por_genero AS (
    SELECT
        gender,
        COUNT(*) AS quantidade
    FROM dbo.Finance_data
    GROUP BY gender
)

SELECT
    gender,
    quantidade,
    ROUND(
        quantidade * 100.0 / SUM(quantidade) OVER (),
        2
    ) AS percentual
FROM divisao_por_genero
ORDER BY quantidade DESC;



-- As modalidades de investimento estão originalmente
-- distribuídas em diferentes colunas.
--
-- O UNPIVOT transforma essas colunas em linhas,
-- criando as colunas investimento e ranking.

SELECT
    gender,
    age,
    investimento,
    ranking
FROM dbo.Finance_data

UNPIVOT (
    ranking
    FOR investimento IN (
        Mutual_Funds,
        Equity_Market,
        Debentures,
        Government_Bonds,
        Fixed_Deposits,
        PPF,
        Gold
    )
) AS u;


-- Quantidade de participantes que colocaram
-- cada modalidade em primeiro lugar

WITH unpivote AS (
    SELECT
        gender,
        age,
        investimento,
        ranking
    FROM dbo.Finance_data

    UNPIVOT (
        ranking
        FOR investimento IN (
            Mutual_Funds,
            Equity_Market,
            Debentures,
            Government_Bonds,
            Fixed_Deposits,
            PPF,
            Gold
        )
    ) AS u
)

SELECT
    investimento,
    COUNT(*) AS qtd_primeira_preferencia
FROM unpivote
WHERE ranking = 1
GROUP BY investimento
ORDER BY qtd_primeira_preferencia DESC;



-- Ranking médio de cada modalidade
-- Quanto menor o ranking médio, maior a preferência.

WITH unpivote AS (
    SELECT
        gender,
        age,
        investimento,
        ranking
    FROM dbo.Finance_data

    UNPIVOT (
        ranking
        FOR investimento IN (
            Mutual_Funds,
            Equity_Market,
            Debentures,
            Government_Bonds,
            Fixed_Deposits,
            PPF,
            Gold
        )
    ) AS u
)

SELECT
    investimento,
    ROUND(
        AVG(CAST(ranking AS DECIMAL(10,2))),
        2
    ) AS ranking_medio
FROM unpivote
GROUP BY investimento
ORDER BY ranking_medio ASC;



-- Objetivos de investimento

SELECT
    Objective,
    COUNT(*) AS quantidade
FROM dbo.Finance_data
GROUP BY Objective
ORDER BY quantidade DESC;


-- Duração de investimento preferida

SELECT
    Duration,
    COUNT(*) AS quantidade
FROM dbo.Finance_data
GROUP BY Duration
ORDER BY quantidade DESC;


-- Retorno esperado

SELECT
    Expect,
    COUNT(*) AS quantidade
FROM dbo.Finance_data
GROUP BY Expect
ORDER BY quantidade DESC;


-- Frequência de monitoramento dos investimentos

SELECT
    Invest_Monitor,
    COUNT(*) AS quantidade
FROM dbo.Finance_data
GROUP BY Invest_Monitor
ORDER BY quantidade DESC;


-- Ranking médio das modalidades por gênero

WITH unpivote AS (
    SELECT
        gender,
        age,
        investimento,
        ranking
    FROM dbo.Finance_data

    UNPIVOT (
        ranking
        FOR investimento IN (
            Mutual_Funds,
            Equity_Market,
            Debentures,
            Government_Bonds,
            Fixed_Deposits,
            PPF,
            Gold
        )
    ) AS u
)

SELECT
    gender,
    investimento,
    ROUND(
        AVG(CAST(ranking AS DECIMAL(10,2))),
        2
    ) AS ranking_medio
FROM unpivote
GROUP BY
    gender,
    investimento
ORDER BY
    gender,
    ranking_medio ASC;