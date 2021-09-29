-- получить, сколько лет назад была образована группа

SELECT id,
       name,
       CASE YEAR
           WHEN date_part('year', now()) THEN 'this year'
           WHEN date_part('year', now()) - 1 THEN 'previous year'
           ELSE date_part('year', now()) - YEAR || ' years ago'
       END AS WHEN
FROM bands;
