# Análise de Dados com SQL - Dados de Turismo no Brasil entre 2020 e 2024

<p align="center">
  <img src="https://i0.wp.com/jornaldecolombo.com.br/wp-content/uploads/2024/05/VIAGEM.webp?resize=874%2C470&ssl=1" width="800">
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

Primeiro, número total de chegadas por ano.
```
-- Total de chegadas por ano
SELECT ano, SUM(chegadas) AS total_de_chegadas
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

A segunda consulta foi sobre os continentes. Qual o total de chegadas por continente e ano.
```
-- Total de chegadas de cada continente em cada ano
 SELECT ano, continente, SUM(chegadas) AS total_de_chegadas
 FROM chegadas_br
 GROUP BY ano, continente
 ORDER BY ano, total_de_chegadas DESC;
```

| Ano  | Continente                        | Total de Chegadas |
|------|-----------------------------------|------------------:|
| 2020 | América do Sul                   |         1383550 |
| 2020 | Europa                            |          430166 |
| 2020 | América do Norte                  |          217123 |
| 2020 | Ásia                              |           70081 |
| 2020 | Oceania                           |           21547 |
| 2020 | África                            |           14334 |
| 2020 | América Central e Caribe          |            9625 |
| 2020 | Continente não especificado       |               9 |
| 2021 | América do Sul                   |          334760 |
| 2021 | Europa                            |          222205 |
| 2021 | América do Norte                  |          152990 |
| 2021 | Ásia                              |           16499 |
| 2021 | África                            |            9217 |
| 2021 | América Central e Caribe          |            8072 |
| 2021 | Oceania                           |            2118 |
| 2021 | Continente não especificado       |              10 |
| 2022 | América do Sul                   |         1990361 |
| 2022 | Europa                            |          901691 |
| 2022 | América do Norte                  |          547430 |
| 2022 | Ásia                              |           89923 |
| 2022 | América Central e Caribe          |           35172 |
| 2022 | África                            |           33760 |
| 2022 | Oceania                           |           31651 |
| 2022 | Continente não especificado       |              43 |
| 2023 | América do Sul                   |         3492244 |
| 2023 | Europa                            |         1234351 |
| 2023 | América do Norte                  |          837393 |
| 2023 | Ásia                              |          183056 |
| 2023 | América Central e Caribe          |           57747 |
| 2023 | Oceania                           |           56875 |
| 2023 | África                            |           46603 |
| 2023 | Continente não especificado       |              72 |
| 2024 | América do Sul                   |         3902919 |
| 2024 | Europa                            |         1431550 |
| 2024 | América do Norte                  |          887108 |
| 2024 | Ásia                              |          252728 |
| 2024 | América Central e Caribe          |           67271 |
| 2024 | Oceania                           |           60841 |
| 2024 | África                            |           54904 |
| 2024 | Continente não especificado       |              56 |

Como já observado em 2020 e 2021, as chegadas foram baixas por causa das restrições. No entanto, a partir de 2022, houve um aumento grande, principalmente da América do Sul, da América do Norte e da Europa. A América do Sul é a região que mais traz turistas para o Brasil. 

A terceira consulta é em relação ao meio de viagem. Qual o total de chegadas por via em cada ano. 
```
 -- Total de chegadas por via em cada ano
  SELECT ano, via, SUM(chegadas) AS total_de_chegadas
 FROM chegadas_br
 GROUP BY ano, via
 ORDER BY ano, total_de_chegadas DESC;
```

| Ano  | Via        | Total de Chegadas |
|------|-----------|------------------:|
| 2020 | Aérea     |         1185620 |
| 2020 | Terrestre |          837270 |
| 2020 | Marítima  |           66973 |
| 2020 | Fluvial   |           56572 |
| 2021 | Aérea     |          585387 |
| 2021 | Terrestre |          158853 |
| 2021 | Fluvial   |            1136 |
| 2021 | Marítima  |             495 |
| 2022 | Aérea     |         2467112 |
| 2022 | Terrestre |         1081900 |
| 2022 | Fluvial   |           46320 |
| 2022 | Marítima  |           34699 |
| 2023 | Aéreo     |         3794260 |
| 2023 | Terrestre |         1923243 |
| 2023 | Marítimo  |          124360 |
| 2023 | Fluvial   |           66478 |
| 2024 | Aéreo     |         4509022 |
| 2024 | Terrestre |         1913891 |
| 2024 | Marítimo  |          140584 |
| 2024 | Fluvial   |           93880 |


O transporte de avião é o mais usado. O transporte por terra é o segundo tipo de transporte. Em uma escala menor, os meios de transporte marítimo e fluvial.

Aqui é onde começo a usar a funçã de janela como uma subconsulta. Para criar um ranque e extrair informação sobre os meses que houveram maiores visitas, os países que mais visitam e os estados que receberam mais visitantes. 

Primeiro, os três meses de cada ano que houveram mais visitas

```
 SELECT ano, mes, total_de_chegadas
 FROM (
	SELECT ano, mes, SUM(chegadas) AS total_de_chegadas,
    DENSE_RANK() OVER (PARTITION BY ano ORDER BY SUM(chegadas) DESC) AS ranque_de_chegadas
    FROM chegadas_br
    GROUP BY ano, mes) AS ranques_chegadas
WHERE ranque_de_chegadas IN (1,2,3)
ORDER BY ano, total_de_chegadas DESC;
```

| Ano  | Mês       | Total de Chegadas |
|------|----------|------------------:|
| 2020 | Janeiro  |         873295 |
| 2020 | Fevereiro|         812726 |
| 2020 | Março    |         290234 |
| 2021 | Dezembro |         174834 |
| 2021 | Novembro |         107123 |
| 2021 | Outubro  |          93824 |
| 2022 | Dezembro |         529038 |
| 2022 | Novembro |         352458 |
| 2022 | Janeiro  |         326670 |
| 2023 | Janeiro  |         971275 |
| 2023 | Fevereiro|         755842 |
| 2023 | Dezembro |         621171 |
| 2024 | Janeiro  |         956737 |
| 2024 | Fevereiro|         833306 |
| 2024 | Março    |         740483 |

Os dados mostram que janeiro e fevereiro sempre têm o maior número de visitas. Isso indica que há um aumento no turismo no começo do ano. Dezembro também mostra números altos, mostrando que mais pessoas estão viajando no fim do ano.

Os cinco países com mais turistas que visitaram o Brasil nos anos de 2020 à 2024.

```
 SELECT ano, pais, total_de_chegadas
 FROM (
	SELECT ano, pais, SUM(chegadas) AS total_de_chegadas,
    DENSE_RANK() OVER (PARTITION BY ano ORDER BY SUM(chegadas) DESC) AS ranque_de_chegadas
    FROM chegadas_br
    GROUP BY ano, pais) AS ranques_chegadas
WHERE ranque_de_chegadas IN (1,2,3,4,5)
ORDER BY ano, total_de_chegadas DESC;
```

| Ano  | País               | Total de Chegadas |
|------|--------------------|------------------:|
| 2020 | Argentina          |         887805 |
| 2020 | Estados Unidos     |         172105 |
| 2020 | Chile              |         131174 |
| 2020 | Paraguai           |         122981 |
| 2020 | Uruguai            |         113714 |
| 2021 | Estados Unidos     |         132182 |
| 2021 | Paraguai           |         132126 |
| 2021 | Argentina          |          67280 |
| 2021 | Chile              |          46673 |
| 2021 | Portugal           |          38704 |
| 2022 | Argentina          |        1032762 |
| 2022 | Estados Unidos     |         441007 |
| 2022 | Paraguai           |         308234 |
| 2022 | Chile              |         202470 |
| 2022 | Uruguai            |         180064 |
| 2023 | Argentina          |        1882240 |
| 2023 | Estados Unidos     |         668478 |
| 2023 | Chile              |         458576 |
| 2023 | Paraguai           |         424460 |
| 2023 | Uruguai            |         334703 |
| 2024 | Argentina          |        1953548 |
| 2024 | Estados Unidos     |         696512 |
| 2024 | Chile              |         651776 |
| 2024 | Paraguai           |         446556 |
| 2024 | Uruguai            |         386856 |

Os dados indicam que a Argentina é, por muito, o país que mais envia turistas para o Brasil. O número de visitantes está aumentando de forma constante de 2020 a 2024. Os Estados Unidos e o Chile são lugares importantes de onde vêm muitos turistas. Esse número de turistas está aumentando, principalmente em 2023 e 2024. O aumento de turistas que vêm de países como Paraguai e Uruguai mostra uma tendência forte na região. Isso pode ser por causa da proximidade entre os lugares.

Os cinco estados que mais receberam visitantes no Brasil nos anos de 2020 à 2024

```
 SELECT ano, uf, total_de_chegadas
 FROM (
	SELECT ano, uf, SUM(chegadas) AS total_de_chegadas,
    DENSE_RANK() OVER (PARTITION BY ano ORDER BY SUM(chegadas) DESC) AS ranque_de_chegadas
    FROM chegadas_br
    GROUP BY ano, uf) AS ranques_chegadas
WHERE ranque_de_chegadas IN (1,2,3,4,5)
ORDER BY ano, total_de_chegadas DESC;
```

| Ano  | Estado               | Total de Chegadas |
|------|----------------------|------------------:|
| 2020 | São Paulo            |         634006 |
| 2020 | Rio Grande do Sul    |         499153 |
| 2020 | Rio de Janeiro       |         377336 |
| 2020 | Paraná               |         296765 |
| 2020 | Santa Catarina       |         142008 |
| 2021 | São Paulo            |         422954 |
| 2021 | Paraná               |         128721 |
| 2021 | Rio de Janeiro       |         101487 |
| 2021 | Ceará                |          17045 |
| 2021 | Mato Grosso do Sul   |          15923 |
| 2022 | São Paulo            |        1505129 |
| 2022 | Rio de Janeiro       |         652962 |
| 2022 | Paraná               |         522832 |
| 2022 | Rio Grande do Sul    |         474474 |
| 2022 | Santa Catarina       |         140533 |
| 2023 | São Paulo            |        2107179 |
| 2023 | Rio de Janeiro       |        1192814 |
| 2023 | Rio Grande do Sul    |        1000909 |
| 2023 | Paraná               |         791536 |
| 2023 | Santa Catarina       |         288429 |
| 2024 | São Paulo            |        2207015 |
| 2024 | Rio de Janeiro       |        1513235 |
| 2024 | Paraná               |         894536 |
| 2024 | Rio Grande do Sul    |         879412 |
| 2024 | Santa Catarina       |         495233 |

São Paulo é o estado que mais recebe turistas. Entre 2020 e 2024, o número de visitantes cresceu bastante. Isso acontece por sua importância econômica. Há mais eventos acontecendo na cidade. Também existem mais voos que chegam do exterior e partem para outras partes do Brasil. O Rio de Janeiro também tem números altos, especialmente em 2023 e 2024. Outros estados, como Paraná, Rio Grande do Sul e Santa Catarina, estão recebendo mais visitantes. O Paraná é o que se destaca, pois tem uma boa quantidade de turistas durante esses anos. Ceará também aparece, pois há voos internacionais vindo de Lisboa, Miami, Orlando, Buenos Aires, Paris e Santiago, no Chile. Sendo um malha área importante para turistar que visitam a região Nordeste.










































