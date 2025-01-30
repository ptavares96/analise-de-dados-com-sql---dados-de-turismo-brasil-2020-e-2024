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

-- Colocando os meses com a primeira letra maiúscula
UPDATE chegadas_br
SET mes = CONCAT(UCASE(LEFT(mes, 1)), LCASE(SUBSTRING(mes, 2)));
