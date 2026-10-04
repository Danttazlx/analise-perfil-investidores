# 📊 Análise do Perfil de Investidores

Projeto de Análise de Dados desenvolvido com **SQL Server e Power BI**, com o objetivo de analisar o perfil e as preferências de investimento dos participantes de uma pesquisa.

O projeto foi desenvolvido partindo de perguntas de negócio, passando pela exploração e validação dos dados em SQL, transformação e modelagem no Power BI e, por fim, construção de métricas e visualizações para geração de insights.

---

## 🎯 Objetivo

A análise busca responder principalmente:

- Qual é o perfil dos participantes da pesquisa?
- Quais modalidades de investimento apresentam maior preferência?
- Quais investimentos aparecem com maior frequência como primeira preferência?
- Como as modalidades se comparam considerando o ranking médio?
- Quais comportamentos e expectativas aparecem entre os participantes?

> **Observação:** a base possui 40 participantes. Portanto, os resultados representam apenas a amostra analisada e não devem ser generalizados para todos os investidores.

---

## 🛠️ Tecnologias utilizadas

- **SQL Server**
- **Power BI**
- **Power Query**
- **DAX**
- **Git/GitHub**

---

## 🔎 Análise com SQL

O SQL foi utilizado para exploração, validação e análise dos dados antes da construção do dashboard.

Entre as análises realizadas:

- Contagem total de registros;
- Verificação de valores nulos;
- Análise de idade mínima, máxima e média;
- Distribuição dos participantes por idade;
- Distribuição e participação percentual por gênero;
- Transformação dos rankings utilizando `UNPIVOT`;
- Quantidade de primeiras preferências por modalidade;
- Ranking médio das modalidades de investimento;
- Análise de objetivos, duração, retorno esperado e frequência de monitoramento;
- Comparação do ranking médio por gênero.

Durante as consultas foram utilizados conceitos como:

`GROUP BY` • `CTE` • `Window Functions` • `UNPIVOT` • `COUNT` • `DISTINCT` • `AVG` • `CAST`

O script utilizado está disponível em:

`sql/analise_investidores.sql`

---

## 🔄 Tratamento e transformação

No **Power Query**, os dados foram preparados para utilização no modelo.

A base original possui granularidade de:

> **1 linha = 1 participante**

Como as modalidades de investimento estavam distribuídas em diferentes colunas, foi criada uma consulta de referência para análise dos rankings.

Após o **Unpivot**, a nova estrutura passou a representar:

> **1 linha = 1 participante + 1 modalidade de investimento**

Dessa forma, os rankings puderam ser analisados de maneira mais adequada no Power BI.

---

## 🧩 Modelagem

O modelo utiliza duas tabelas principais:

### Finance_data

Contém as informações originais dos participantes.

**Granularidade:** 1 linha por participante.

### Finance_Rankings

Tabela criada a partir da transformação dos rankings.

**Granularidade:** 1 linha por participante e modalidade de investimento.

As tabelas são relacionadas através do identificador do participante em uma relação:

**Finance_data (1) → (*) Finance_Rankings**

---

## 📐 DAX

Foram criadas medidas para permitir análises dinâmicas no dashboard.

### Total de participantes

```DAX
Total Participantes =
DISTINCTCOUNT(Finance_data[id_participante])
```

### Ranking médio

```DAX
Ranking Médio =
AVERAGE(Finance_Rankings[ranking])
```

### Primeira preferência

```DAX
Primeira Preferência =
CALCULATE(
    COUNTROWS(Finance_Rankings),
    Finance_Rankings[ranking] = 1
)
```

A medida de primeira preferência utiliza `CALCULATE` para modificar o contexto de filtro e considerar somente registros em que o investimento recebeu **ranking 1**.

---

## 📊 Dashboard

O dashboard foi desenvolvido para apresentar de forma simples o perfil dos participantes e suas preferências de investimento.

Foram analisados:

- Total de participantes;
- Idade média;
- Distribuição por gênero;
- Distribuição por idade;
- Ranking médio das modalidades;
- Quantidade de primeiras preferências.

### Dashboard

![Dashboard](images/dashboard.png)

---

## 💡 Principais insights

A pesquisa possui **40 participantes**, com idades entre **21 e 35 anos**.

A distribuição por gênero da amostra é composta por:

- **62,5% Male**
- **37,5% Female**

Na análise das modalidades de investimento, **PPF (Public Provident Fund)** apresentou a melhor posição média no ranking de preferência, com aproximadamente **2,03**, seguido por **Mutual Funds**, com aproximadamente **2,55**.

Por outro lado, **Gold** e **Debentures** apresentaram as posições médias mais baixas na preferência dos participantes, com rankings médios de aproximadamente **5,98** e **5,75**, respectivamente.

A análise da primeira preferência também reforçou a presença do **PPF** entre as modalidades mais escolhidas pelos participantes.

> Como a pesquisa possui apenas 40 participantes, esses resultados descrevem exclusivamente a amostra analisada.

---

## 📁 Estrutura do projeto

```text
analise-perfil-investidores/
│
├── README.md
│
├── sql/
│   └── analise_investidores.sql
│
├── powerbi/
│   └── analise_investidores.pbix
│
├── images/
│   └── dashboard.png
│
└── data/
    └── Finance_data.csv
```

---

## 📚 Conceitos praticados

Este projeto foi utilizado para consolidar conhecimentos em:

- Exploração e validação de dados com SQL;
- CTEs e Window Functions;
- Transformação de dados com `UNPIVOT`;
- Power Query;
- Granularidade dos dados;
- Modelagem e relacionamentos;
- Medidas DAX;
- Contexto de filtro;
- `CALCULATE`;
- Construção de KPIs;
- Visualização de dados;
- Interpretação e comunicação de insights.

---

## 👨‍💻 Autor

**Daniel Dantas**

Projeto desenvolvido como parte do meu portfólio de **Análise de Dados e Business Intelligence**.
