-- выбрать группы, год основания которых больше года основания всех групп из

SELECT id,
       name
FROM bands
WHERE YEAR >= ALL
    (SELECT YEAR
     FROM bands
     WHERE country = 'Russian Federation');
