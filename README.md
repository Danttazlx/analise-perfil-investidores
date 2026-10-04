# 📊 Análise do Perfil e Preferências de Investidores

Projeto de **Análise de Dados** desenvolvido utilizando **SQL Server e Power BI**, com o objetivo de analisar o perfil e as preferências de investimento dos participantes de uma pesquisa.

O projeto parte de perguntas de negócio e passa pela **validação e exploração dos dados com SQL**, transformação com **Power Query**, modelagem, criação de medidas com **DAX** e construção de um dashboard para comunicação dos resultados.

---

## 📊 Dashboard

![Dashboard - Análise de Investidores](images/dashboard.png)

---

## 🎯 Objetivo do projeto

O objetivo principal foi responder:

> **Como é o perfil dos participantes da pesquisa e quais são suas principais preferências de investimento?**

A análise buscou responder perguntas como:

- Qual é o perfil dos participantes?
- Como os participantes estão distribuídos por idade e gênero?
- Quais modalidades apresentam melhor posição média no ranking?
- Quais investimentos aparecem mais vezes como primeira preferência?

> **Importante:** a base possui apenas 40 participantes. Portanto, os resultados representam a amostra analisada e não devem ser generalizados para todos os investidores.

---

## 🛠️ Tecnologias utilizadas

- **SQL Server**
- **Power BI**
- **Power Query**
- **DAX**
- **Git/GitHub**

---

## 🔎 Análise com SQL

Antes da construção do dashboard, o SQL foi utilizado para explorar e validar os dados.

Foram realizadas análises como:

- Contagem total de registros;
- Verificação de valores nulos;
- Idade mínima, máxima e média;
- Distribuição dos participantes por idade;
- Distribuição e participação percentual por gênero;
- Transformação das modalidades utilizando `UNPIVOT`;
- Quantidade de primeiras preferências por modalidade;
- Ranking médio das modalidades;
- Análise de objetivo, duração, retorno esperado e frequência de monitoramento;
- Comparação do ranking médio por gênero.

Durante as consultas foram praticados conceitos como:

`GROUP BY` • `CTEs` • `Window Functions` • `UNPIVOT` • `COUNT` • `DISTINCT` • `AVG` • `CAST`

O script completo está disponível em:

`sql/analise_investidores.sql`

---

## 🔄 Tratamento e transformação dos dados

A base original possui a seguinte granularidade:

> **1 linha = 1 participante**

As modalidades de investimento estavam distribuídas em diferentes colunas, cada uma contendo a posição atribuída pelo participante no ranking.

Para facilitar a análise dessas modalidades, foi criada uma nova consulta no **Power Query** utilizando uma referência da tabela original.

Foi aplicado **Unpivot** nas colunas de ranking.

A nova estrutura passou a representar:

> **1 linha = 1 participante + 1 modalidade de investimento**

Isso permitiu analisar as modalidades através das colunas:

```text
id_participante | investimento | ranking
```

---

## 🧩 Modelagem

O modelo utilizado no Power BI possui duas tabelas principais.

### Finance_data

Contém os dados dos participantes.

**Granularidade:**

> 1 linha por participante.

### Finance_Rankings

Criada a partir da transformação das colunas de ranking.

**Granularidade:**

> 1 linha por participante + modalidade de investimento.

As tabelas são relacionadas pelo identificador do participante:

```text
Finance_data
     1
     │
     │ id_participante
     │
     *
Finance_Rankings
```

Portanto, foi utilizado um relacionamento **1 para muitos (1:*)**.

---

## 📐 Medidas DAX

### Total de participantes

```DAX
Total Participantes =
DISTINCTCOUNT(Finance_data[id_participante])
```

A medida utiliza `DISTINCTCOUNT` para contar participantes únicos.

---

### Ranking médio

```DAX
Ranking Médio =
AVERAGE(Finance_Rankings[ranking])
```

Como **1 representa a maior preferência e 7 a menor**, quanto menor o ranking médio, maior a preferência pela modalidade.

---

### Primeira preferência

```DAX
Primeira Preferência =
CALCULATE(
    COUNTROWS(Finance_Rankings),
    Finance_Rankings[ranking] = 1
)
```

Nesse caso, `CALCULATE` modifica o contexto de filtro para considerar somente os registros em que:

```text
ranking = 1
```

Assim é possível identificar quantos participantes colocaram cada modalidade como sua primeira preferência.

---

## 💡 Principais insights

A pesquisa possui **40 participantes**, com idades entre **21 e 35 anos**.

### Perfil

A distribuição por gênero da amostra é:

- **62,5% Male**
- **37,5% Female**

### Preferências de investimento

Considerando o ranking médio:

- **PPF (Public Provident Fund): 2,03**
- **Mutual Funds: 2,55**
- **Equity Market: 3,48**
- **Fixed Deposits: 3,58**
- **Government Bonds: 4,65**
- **Debentures: 5,75**
- **Gold: 5,98**

Como posições menores representam maior preferência, **PPF e Mutual Funds apresentaram as melhores posições médias entre os participantes**.

Por outro lado, **Gold e Debentures apresentaram as piores posições médias**.

A análise das primeiras preferências também reforça a presença do **PPF entre as modalidades mais escolhidas pelos participantes**.

> Os insights descrevem exclusivamente os participantes desta pesquisa e não representam necessariamente o comportamento geral dos investidores.

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
└── images/
    └── dashboard.png
```

---

## 📚 Conceitos praticados

### SQL
- Validação e exploração de dados
- Agregações
- `GROUP BY`
- CTEs
- Window Functions
- `UNPIVOT`
- Análise de rankings

### Power BI
- Power Query
- Transformação de dados
- Unpivot
- Granularidade
- Relacionamentos 1:*
- Modelagem
- Medidas DAX
- Contexto de filtro
- `CALCULATE`
- Visualização de dados
- Construção de dashboard

### Análise
- Definição de perguntas de negócio
- Validação dos dados
- Construção de métricas
- Comparação de categorias
- Interpretação de resultados
- Comunicação de insights
