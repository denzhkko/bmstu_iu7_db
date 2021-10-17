-- Вернуть группы с максимальным количеством песен

CREATE OR REPLACE FUNCTION get_max_song_count_bands()
RETURNS TABLE (id UUID, name TEXT)
AS $$
BEGIN
    RETURN QUERY
        WITH band_song_cnt (id, song_cnt) AS (
            SELECT id_band, count(*) AS song_count
            FROM rel_bands_sing_songs
            GROUP BY id_band
        ),
        max_song_cnt (value) AS (
            SELECT max(a.song_cnt)
            FROM band_song_cnt a
        )
        SELECT band_song_cnt.id, bands.name
        FROM band_song_cnt
        JOIN bands ON band_song_cnt.id = bands.id
        WHERE song_cnt = (SELECT * FROM max_song_cnt);
END
$$ LANGUAGE PLPGSQL;

