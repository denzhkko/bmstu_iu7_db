ALTER TABLE listeners ADD language TEXT;
ALTER TABLE listeners ADD country TEXT;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TEMP TABLE tmp_listeners_lc (
    id UUID PRIMARY KEY,
    language TEXT NOT NULL,
    country TEXT NOT NULL
);

COPY tmp_listeners_lc
FROM '/var/lib/postgresql/mydata/tmp_listeners_lc.csv'
DELIMITER ',' CSV;

UPDATE listeners
SET language = tmp_listeners_lc.language,
    country = tmp_listeners_lc.country
FROM tmp_listeners_lc
WHERE listeners.id = tmp_listeners_lc.id;

DROP TABLE tmp_listeners_lc;
