-- получить среднюю оценку песни с идентификатором 1

SELECT avg(rating)
FROM rel_listeners_rate_songs
WHERE id_song = 1;
