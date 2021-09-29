-- выбрать песни, в названии которых есть слово world

SELECT id,
       name
FROM songs
WHERE lower(name) LIKE '%world%';
