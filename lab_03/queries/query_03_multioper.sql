-- Вернуть группы с максимальным количеством песен

CREATE OR REPLACE FUNCTION get_max_song_cnt_bands_02()
RETURNS TABLE (id uuid, name TEXT)
AS $$
DECLARE
    max_song_cnt INTEGER;
BEGIN
    CREATE TEMP TABLE tmp_band_song_cnt (
        id UUID,
        song_cnt INTEGER);

    INSERT INTO tmp_band_song_cnt (id, song_cnt)
    SELECT id_band, count(*) AS song_count
    FROM Rel_bands_sing_songs
    GROUP BY ud_band;

    SELECT max(a.song_cnt) INTO max_song_cnt
    FROM tmp_band_song_cnt a;

    RETURN QUERY
        SELECT tmp_band_song_cnt.id, bands.name
        FROM tmp_band_song_cnt
        JOIN bands ON tmp_band_song_cnt.id = bands.id
        WHERE song_cnt = max_song_cnt;
END;
$$ LANGUAGE PLPGSQL;

