# Análise de Dados com SQL - Dados de Turismo no Brasil entre 2020 e 2024

<p align="center">
  <img src="https://i0.wp.com/jornaldecolombo.com.br/wp-content/uploads/2024/05/VIAGEM.webp?resize=874%2C470&ssl=1" width="150">
</p>

Concluí a leitura do livro ["SQL - Guia Prático: um Guia para o uso de SQL"](https://www.amazon.com.br/SQL-Guia-Pr%C3%A1tico-Para-uso/dp/8575228315/ref=sr_1_2?crid=74GXG9QC59N8&dib=eyJ2IjoiMSJ9.0UjMDX8c08aJbOhWWqWyD2pR4cxA1JscGp0pYU1D-cTXqVnRLEdn9Dc4g_zI2nktd6OUxoUDhniEKxsG2lt8YrmZ2bc6LyYjCvgsdj8dz-9XSJW9PmO_wc2W7axRsDyMrrTyJtrSNJdlxbwWz9wolUoSCcEDnCJcwldRSnHIXjT7VPnstoTBoEEgpy2OpLoeY_a6YMde9OvM8gIFDnJVkXq9Ws-uBCChjDm0fBaUJQ83dQ2E6fjMweIvqF9L5qBUkP1gKYzO_kFBY8X40YrINBCkqlxuECnta-pbFjT2jeNtDjP3g3XO7sDFw9xI3yv1IYj6cyN65n4GZ7rkjpCvlmk-w30m0CdB6T0s9lG7IPaGr6FWn0aoSV_6wxy8HR_AgeDZWtOghO73HeKFEk1Qyly2GcewDlwNyQI2WAf6N1HRXMjs3byP-YLTkm2aznVG.Z0dYXog0z5PifcRxruTWBHCdryqKuiCFByYOJ3l6pMc&dib_tag=se&keywords=sql+na+pr%C3%A1tica&qid=1738342999&sprefix=sql+na+pra%2Caps%2C218&sr=8-2&ufe=app_do%3Aamzn1.fos.6d798eae-cadf-45de-946a-f477d47705b9) e para testar uma função que achei interessante, baixei os [dados do turismo brasileiro](https://dados.gov.br/dados/conjuntos-dados/estimativas-de-chegadas-de-turistas-internacionais-ao-brasil) referentes aos anos de 2020 a 2024.

A função que menciono é a função de janela. Ela se parece com a função de agregação, mas tem uma diferença. A saída da função de janela retorna um valor para cada linha de dados. Já a função de agregação retorna um só valor.

Um exemplo de função de janela é `ROW_NUMBER() OVER (PARTITION BY coluna_1 ORDER BY coluna_2)`. Essa função ajuda a numerar as linhas em um grupo. O grupo é definido pela coluna_1 e a numeração é feita de acordo com a ordem da coluna_2. Isso quer dizer que: `ROW_NUMBER` é a função que queremos usar. No projeto, usamos `DENSE_RANK()`. É importante indicar a função que estamos aplicando. `OVER` é a palavra que mostra que está sendo usada uma função especial chamada de janela. `PARTITION BY coluna_1` separa os dados em grupos menores. É possível dividir usando mais colunas. Essa separação é opcional. Se não for usada, a tabela inteira será considerada. E `ORDER BY coluna_2` mostra como cada parte deve ser organizada antes de usar a função.

Neste projeto, usei o MySQL. Comecei criando a base de dados e depois criei a tabela. A entrada dos dados foi feita a paritr do _import wizard_ do MySQL.

```
-- Criação da base de dados
CREATE DATABASE chegadas_brasil;
USE chegadas_brasil;


-- Criação da tabela chegadas_br
CREATE TABLE chegadas_br (
continente VARCHAR(55) NOT NULL,
id_continete BIGINT NOT NULL,
pais VARCHAR(55) NOT NULL,
id_pais BIGINT NOT NULL,
uf VARCHAR(55) NOT NULL,
id_uf BIGINT NOT NULL,
via VARCHAR(55) NOT NULL,
id_via BIGINT NOT NULL,
ano BIGINT NOT NULL,
mes VARCHAR(30) NOT NULL,
id_mes BIGINT NOT NULL,
chegadas BIGINT NOT NULL
);
```

Observei que alguns nomes de meses estavam com inicial minúscula, para padronizar deixei todos os nomes com iniciais maiúsculas.
```
-- Colocando os meses com a primeira letra maiúscula
UPDATE chegadas_br
SET mes = CONCAT(UCASE(LEFT(mes, 1)), LCASE(SUBSTRING(mes, 2)));
```

Quando eu vi os dados pela primeira vez, a primeira coisa que pensei foi fazer algumas perguntas. Essas perguntas ajudariam a organizar melhor a análise.  Essa primeira maneira de agir ajudou a decidir o que fazer a seguir. Assim, ficou mais claro quais consultas e funções eu iria utilizar.

Primeiro, número total de chegadas por ano e média de chegadas em cada ano.
```
-- Total de chegadas por ano
SELECT ano, SUM(chegadas) AS total_de_chegadas
FROM chegadas_br
GROUP BY ano;

-- Média de chegadas de cada ano
SELECT ano, ROUND(AVG(chegadas),2) AS média_de_chegadas
FROM chegadas_br
GROUP BY ano;
```

A primeira consulta retornou: 

| Ano  | Total de Chegadas |
|------|------------------:|
| 2020 |        2.146.435 |
| 2021 |          745.871 |
| 2022 |        3.630.031 |
| 2023 |        5.908.341 |
| 2024 |        6.657.377 |

Aqui se observa que, em 2021, houve menos viagens em comparação com os outros anos, por causa das regras e limitações por conta da pandemia de COVID-19.

A segunda consulta retorna: 

| Ano  | Média de Chegadas |
|------|------------------:|
| 2020 |            44.73 |
| 2021 |            13.37 |
| 2022 |            66.38 |
| 2023 |           169.96 |
| 2024 |           174.15 |








































