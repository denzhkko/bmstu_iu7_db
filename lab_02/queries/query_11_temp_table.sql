-- занести во времененную таблицу, сколько десятилетий назад
-- была образована группа

SELECT id,
       name,
       CASE
           WHEN date_part('year', now()) - YEAR < 10 THEN 'this decade'
           WHEN date_part('year', now()) - YEAR < 20 THEN 'previous decade'
           ELSE ((date_part('year', now()) - YEAR) / 10)::integer || ' decades ago'
       END AS WHEN INTO TEMP tmp_band_when
FROM bands;
