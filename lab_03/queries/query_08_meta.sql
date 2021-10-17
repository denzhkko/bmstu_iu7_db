-- Вывести метаданные

CREATE OR REPLACE PROCEDURE get_db_metadata(dbname VARCHAR) AS $$
DECLARE
    dbid INT;
    dbconnlimit INT;
BEGIN
    SELECT pg.oid, pg.datconnlimit FROM pg_database pg WHERE pg.datname = dbname
    INTO dbid, dbconnlimit;
    RAISE NOTICE 'DB: %, ID: %, CONNECTION LIMIT: %', dbname, dbid, dbconnlimit;
END;
$$ LANGUAGE PLPGSQL;

