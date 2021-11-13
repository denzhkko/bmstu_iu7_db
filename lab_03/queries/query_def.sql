-- Вывести количество песен по жанру

CREATE OR REPLACE PROCEDURE count_song_by_genre(genre_ TEXT)
AS $$
DECLARE
    songs_cnt_ INTEGER;
BEGIN
    SELECT count(*)
    FROM songs
    WHERE lower(genre) = lower(genre_)
    GROUP BY genre
    INTO songs_cnt_;

    RAISE NOTICE 'Genge: %; Songs count: %', genre_, songs_cnt_;
END;
$$ LANGUAGE PLPGSQL;

