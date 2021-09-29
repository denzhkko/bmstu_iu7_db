-- получить название песен, которые состоят в альбомах 2021 года

SELECT id,
       name
FROM songs
WHERE id in
    (SELECT id_song
     FROM rel_albums_contain_songs
     WHERE id_album in
         (SELECT id
          FROM albums
          WHERE YEAR = 2021));
