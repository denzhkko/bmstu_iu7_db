-- Вывести сообщении при добавлении комментария, если комментарий первый для песни

CREATE OR REPLACE FUNCTION print_if_first_comment() RETURNS TRIGGER AS $$
DECLARE
    cmt_cnt INTEGER;
BEGIN
    SELECT count(*) as cmt_cnt
    INTO cmt_cnt
    FROM rel_listeners_comment_songs
    WHERE id_song = new.id_song;

    IF cmt_cnt = 1 THEN
        RAISE NOTICE 'Comment % is a first comment to song %', new.id, new.id_song;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;


CREATE TRIGGER trg_print_if_first_comment AFTER
INSERT ON rel_listeners_comment_songs
FOR ROW EXECUTE PROCEDURE print_if_first_comment();

