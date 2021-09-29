-- получиться среднее количество от количетсва групп в странах
WITH cbc (country, band_cnt) AS
  (SELECT country,
          count(*)
   FROM bands
   GROUP BY country)
SELECT AVG (band_cnt) AS avg_country_band_cnt
FROM cbc;
