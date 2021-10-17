-- Возвращает количество песен у группы по id

CREATE OR REPLACE FUNCTION get_song_count(id_ uuid)
RETURNS INTEGER
AS $$
BEGIN
    RETURN (SELECT count(*) AS song_cnt
            FROM rel_bands_sing_songs
            WHERE id_band = id_);
END
$$ LANGUAGE PLPGSQL;

