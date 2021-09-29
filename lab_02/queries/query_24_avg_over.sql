-- вывести названия песен, жанр и среднюю оценку по жанру

SELECT songs.id,
       songs.name,
       songs.genre,
       avg(rel_listeners_rate_songs.rating) OVER (PARTITION BY songs.genre)
FROM songs
INNER JOIN rel_listeners_rate_songs ON songs.id = rel_listeners_rate_songs.id_song;
