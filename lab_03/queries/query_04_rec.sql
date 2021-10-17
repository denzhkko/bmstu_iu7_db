-- Вывести комметарии с глубиной сложенности

CREATE OR REPLACE FUNCTION get_cmt_tree()
RETURNS TABLE ( id uuid, id_parent uuid, level integer, txt TEXT)
AS $$
BEGIN
    RETURN QUERY
        WITH RECURSIVE cmt_rec (id, id_parent, level, txt) AS
            (SELECT rlcs.id,
                    rlcs.parent,
                    0 AS level,
                    rlcs.txt
             FROM rel_listeners_comment_songs rlcs
             WHERE parent IS NULL
              
             UNION ALL
            
             SELECT rlcs.id,
                    rlcs.parent,
                    cr.level + 1,
                    rlcs.txt
             FROM rel_listeners_comment_songs AS rlcs
                 JOIN cmt_rec AS cr ON cr.id = rlcs.parent)
        SELECT *
        FROM cmt_rec;
END;
$$ LANGUAGE PLPGSQL;

