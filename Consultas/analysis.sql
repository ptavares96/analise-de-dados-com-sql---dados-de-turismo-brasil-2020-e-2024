-- Total de chegadas por ano
SELECT ano, SUM(chegadas) AS total_de_chegadas
FROM chegadas_br
GROUP BY ano;

-- Média de chegadas de cada ano
SELECT ano, ROUND(AVG(chegadas),2) AS média_de_chegadas
FROM chegadas_br
GROUP BY ano;

-- Total de chegadas de cada continente em cada ano
 SELECT ano, continente, SUM(chegadas) AS total_de_chegadas
 FROM chegadas_br
 GROUP BY ano, continente
 ORDER BY ano, total_de_chegadas DESC;
 
 -- Total de chegadas por via em cada ano
  SELECT ano, via, SUM(chegadas) AS total_de_chegadas
 FROM chegadas_br
 GROUP BY ano, via
 ORDER BY ano, total_de_chegadas DESC;
 
 -- Os três meses de cada ano que houveram mais visitas
 SELECT ano, mes, total_de_chegadas
 FROM (
	SELECT ano, mes, SUM(chegadas) AS total_de_chegadas,
    DENSE_RANK() OVER (PARTITION BY ano ORDER BY SUM(chegadas) DESC) AS ranque_de_chegadas
    FROM chegadas_br
    GROUP BY ano, mes) AS ranques_chegadas
WHERE ranque_de_chegadas IN (1,2,3)
ORDER BY ano, total_de_chegadas DESC;

-- Os cinco países que mais receberam visitantes no Brasil nos anos de 2020 à 2024
 SELECT ano, pais, total_de_chegadas
 FROM (
	SELECT ano, pais, SUM(chegadas) AS total_de_chegadas,
    DENSE_RANK() OVER (PARTITION BY ano ORDER BY SUM(chegadas) DESC) AS ranque_de_chegadas
    FROM chegadas_br
    GROUP BY ano, pais) AS ranques_chegadas
WHERE ranque_de_chegadas IN (1,2,3,4,5)
ORDER BY ano, total_de_chegadas DESC;

-- Os cinco estados que mais receberam visitantes no Brasil nos anos de 2020 à 2024
 SELECT ano, uf, total_de_chegadas
 FROM (
	SELECT ano, uf, SUM(chegadas) AS total_de_chegadas,
    DENSE_RANK() OVER (PARTITION BY ano ORDER BY SUM(chegadas) DESC) AS ranque_de_chegadas
    FROM chegadas_br
    GROUP BY ano, uf) AS ranques_chegadas
WHERE ranque_de_chegadas IN (1,2,3,4,5)
ORDER BY ano, total_de_chegadas DESC;