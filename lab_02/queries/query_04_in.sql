-- выбрать песни, у которых есть оценка за последние 24 часа

SELECT id,
       name
FROM songs
WHERE id in
    (SELECT id_song
     FROM rel_listeners_rate_songs
     WHERE TIME >= now() - INTERVAL '1 day' );
