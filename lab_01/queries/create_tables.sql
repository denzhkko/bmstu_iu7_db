CREATE TABLE labels (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    founder TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TABLE bands (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TABLE songs (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    genre TEXT NOT NULL,
    language TEXT,
    about TEXT
);

CREATE TABLE albums (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    year INTEGER NOT NULL,
    about TEXT
);

CREATE TABLE listeners (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    gender TEXT,
    birth DATE,
    email TEXT NOT NULL,
    pwd_hash TEXT NOT NULL
);


CREATE TABLE rel_bands_cooperate_labels (
    id INTEGER PRIMARY KEY,
    id_band INTEGER NOT NULL,
    id_label INTEGER NOT NULL,
    c_start DATE NOT NULL,
    c_end DATE NOT NULL,
    FOREIGN KEY (id_band) REFERENCES bands(id) ON DELETE CASCADE,
    FOREIGN KEY (id_label) REFERENCES labels(id) ON DELETE CASCADE
);

CREATE TABLE rel_bands_sing_songs (
    id INTEGER PRIMARY KEY,
    id_band INTEGER NOT NULL,
    id_song INTEGER NOT NULL,
    FOREIGN KEY (id_band) REFERENCES bands(id) ON DELETE CASCADE,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE TABLE rel_albums_contain_songs (
    id INTEGER PRIMARY KEY,
    id_album INTEGER NOT NULL,
    id_song INTEGER NOT NULL,
    FOREIGN KEY (id_album) REFERENCES albums(id) ON DELETE CASCADE,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE TABLE rel_listeners_rate_songs (
    id INTEGER PRIMARY KEY,
    rating INTEGER NOT NULL,
    time TIMESTAMP NOT NULL,
    id_song INTEGER NOT NULL,
    id_listener INTEGER NOT NULL,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE,
    FOREIGN KEY (id_listener) REFERENCES listeners(id) ON DELETE CASCADE
);
