-- установить оценкам пользователя с первым именем в отсортированном списке
-- значение его наивысшей оценки

UPDATE rel_listeners_rate_songs
SET rating =
  (SELECT avg(rating)
   FROM rel_listeners_rate_songs
   WHERE id_listener =
       (SELECT id
        FROM listeners
        ORDER BY name
        LIMIT 1))
WHERE id_listener =
    (SELECT id
     FROM listeners
     ORDER BY name
     LIMIT 1);
