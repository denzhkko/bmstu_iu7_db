-- получить количество песен по жанрам

SELECT genre,
       count(*) AS song_cnt
FROM songs
GROUP BY genre;
