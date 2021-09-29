-- получить названия песен и их среднюю оценку

SELECT id,
       name,

  (SELECT avg(rating)
   FROM rel_listeners_rate_songs
   WHERE id_song=songs.id) AS rate
FROM songs;
