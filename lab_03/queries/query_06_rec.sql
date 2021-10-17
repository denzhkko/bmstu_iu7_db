-- Вывести путь до корневого комментария

CREATE OR REPLACE PROCEDURE find_root_comment(comm_id_ uuid)
AS $$
DECLARE
    id_parent_ UUID;
BEGIN
    SELECT rlcs.parent
    FROM rel_listeners_comment_songs rlcs
    WHERE rlcs.id = comm_id_ INTO id_parent_;

    IF id_parent_ is NULL THEN
        RAISE NOTICE '%s: is     a root comment. Congratulation!', comm_id_;
    ELSE
        RAISE NOTICE '%s: is not a root commnet. Keep going!', comm_id_;
        CALL find_root_comment(id_parent_);
    END IF;
END;
$$ LANGUAGE PLPGSQL;

