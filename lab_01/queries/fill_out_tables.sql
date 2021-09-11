COPY labels FROM '/var/lib/postgresql/mydata/labels.csv' DELIMITER ',' CSV;
COPY bands FROM '/var/lib/postgresql/mydata/bands.csv' DELIMITER ',' CSV;
COPY songs FROM '/var/lib/postgresql/mydata/songs.csv' DELIMITER ',' CSV;
COPY albums FROM '/var/lib/postgresql/mydata/albums.csv' DELIMITER ',' CSV;
COPY listeners FROM '/var/lib/postgresql/mydata/listeners.csv'
DELIMITER ',' CSV;

COPY rel_bands_cooperate_labels
FROM '/var/lib/postgresql/mydata/rel_bands_cooperate_labels.csv'
DELIMITER ',' CSV;

COPY rel_bands_sing_songs
FROM '/var/lib/postgresql/mydata/rel_bands_sing_songs.csv'
DELIMITER ',' CSV;

COPY rel_albums_contain_songs
FROM '/var/lib/postgresql/mydata/rel_albums_contain_songs.csv'
DELIMITER ',' CSV;

COPY rel_listeners_rate_songs
FROM '/var/lib/postgresql/mydata/rel_listeners_rate_songs.csv'
DELIMITER ',' CSV;
