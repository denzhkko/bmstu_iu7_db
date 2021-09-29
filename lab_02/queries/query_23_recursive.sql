-- вывести комметарии с глубиной сложенности
WITH RECURSIVE cmts_rec (id, id_parent, LEVEL, txt) AS
  (SELECT id,
          parent,
          0 AS LEVEL,
          txt
   FROM rel_listeners_comment_songs
   WHERE parent IS NULL
   UNION ALL SELECT e.id,
                    e.parent,
                    s.level + 1,
                    e.txt
   FROM rel_listeners_comment_songs AS e
   INNER JOIN cmts_rec AS s ON s.id = e.parent)
SELECT *
FROM cmts_rec;
