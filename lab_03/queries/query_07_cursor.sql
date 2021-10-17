-- Вывести группы поющие песни в заданном жанре

CREATE OR REPLACE PROCEDURE list_bands_by_genre(genre_ TEXT)
AS $$
DECLARE
    reclist RECORD;
    listcur CURSOR FOR
        SELECT id, name
        FROM bands
        WHERE id in (
            SELECT DISTINCT id_band
            FROM rel_bands_sing_songs
            WHERE id_song in (
                SELECT id
                FROM songs
                WHERE lower(genre) = lower(genre_)
            )
        );
BEGIN
    OPEN listcur;
    LOOP
        FETCH listcur INTO reclist;
        RAISE NOTICE '% (%) sing songs by genre %', reclist.name, reclist.id, genre_;
        EXIT WHEN NOT FOUND;
    END LOOP;
    CLOSE listcur;
END;
$$ LANGUAGE PLPGSQL;

