-- получить количество песен по жанрам, которых больше 20

SELECT genre,
       count(*) AS song_cnt
FROM songs
GROUP BY genre
HAVING count(*) > 20;
