CREATE TABLE label (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    founder TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TABLE band (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TABLE med_band_label (
    id INTEGER PRIMARY KEY,
    id_band INTEGER NOT NULL,
    id_label INTEGER NOT NULL,
    c_start DATE NOT NULL,
    c_end DATE NOT NULL,
    FOREIGN KEY (id_band) REFERENCES band(id) ON DELETE CASCADE,
    FOREIGN KEY (id_label) REFERENCES label(id) ON DELETE CASCADE
);

CREATE TABLE song (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    genre TEXT NOT NULL,
    language TEXT,
    about TEXT
);

CREATE TABLE med_band_song (
    id INTEGER PRIMARY KEY,
    id_band INTEGER NOT NULL,
    id_song INTEGER NOT NULL,
    FOREIGN KEY (id_band) REFERENCES band(id) ON DELETE CASCADE,
    FOREIGN KEY (id_song) REFERENCES song(id) ON DELETE CASCADE
);

CREATE TABLE album (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    year INTEGER NOT NULL,
    about TEXT
);

CREATE TABLE med_album_song (
    id INTEGER PRIMARY KEY,
    id_album INTEGER NOT NULL,
    id_song INTEGER NOT NULL,
    FOREIGN KEY (id_album) REFERENCES album(id) ON DELETE CASCADE,
    FOREIGN KEY (id_song) REFERENCES song(id) ON DELETE CASCADE
);

CREATE TABLE songrating (
    id INTEGER PRIMARY KEY,
    rating INTEGER NOT NULL,
    time TIME NOT NULL,
    id_song INTEGER NOT NULL
);

CREATE TABLE listener (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    gender TEXT,
    birth DATE,
    email TEXT NOT NULL,
    pwd_hash TEXT NOT NULL
);

CREATE TABLE med_listener_songrating (
    id INTEGER PRIMARY KEY,
    id_listener INTEGER NOT NULL,
    id_songrating INTEGER NOT NULL,
    FOREIGN KEY (id_listener) REFERENCES listener(id) ON DELETE CASCADE,
    FOREIGN KEY (id_songrating) REFERENCES songrating(id) ON DELETE CASCADE
);
