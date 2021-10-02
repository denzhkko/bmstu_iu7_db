SELECT id,
       name
FROM labels
WHERE id IN
    (SELECT id_label
     FROM rel_bands_cooperate_labels
     WHERE id_band IN
         (SELECT id_band
          FROM rel_bands_sing_songs
          WHERE id_song IN
              (SELECT id
               FROM songs
               WHERE genre = 'Metal'
                 AND id IN
                   (SELECT id_song
                    FROM rel_listeners_rate_songs
                    WHERE rating BETWEEN 1 AND 5))));

