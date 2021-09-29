CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE labels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    founder TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TABLE bands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TABLE songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    genre TEXT NOT NULL,
    language TEXT,
    about TEXT
);

CREATE TABLE albums (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    year INTEGER NOT NULL,
    about TEXT
);

CREATE TABLE listeners (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    gender TEXT,
    birth DATE,
    email TEXT NOT NULL,
    pwd_hash TEXT NOT NULL
);


CREATE TABLE rel_bands_cooperate_labels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_band UUID NOT NULL,
    id_label UUID NOT NULL,
    c_start DATE NOT NULL,
    c_end DATE NOT NULL,
    FOREIGN KEY (id_band) REFERENCES bands(id) ON DELETE CASCADE,
    FOREIGN KEY (id_label) REFERENCES labels(id) ON DELETE CASCADE
);

CREATE TABLE rel_bands_sing_songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_band UUID NOT NULL,
    id_song UUID NOT NULL,
    FOREIGN KEY (id_band) REFERENCES bands(id) ON DELETE CASCADE,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE TABLE rel_albums_contain_songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_album UUID NOT NULL,
    id_song UUID NOT NULL,
    FOREIGN KEY (id_album) REFERENCES albums(id) ON DELETE CASCADE,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE
);

CREATE TABLE rel_listeners_rate_songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rating INTEGER NOT NULL,
    time TIMESTAMP NOT NULL,
    id_song UUID NOT NULL,
    id_listener UUID NOT NULL,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE,
    FOREIGN KEY (id_listener) REFERENCES listeners(id) ON DELETE CASCADE
);


CREATE TABLE rel_listeners_comment_songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    txt TEXT NOT NULL,
    parent UUID,
    time TIMESTAMP NOT NULL DEFAULT now(),
    id_song UUID NOT NULL,
    id_listener UUID NOT NULL,
    FOREIGN KEY (id_song) REFERENCES songs(id) ON DELETE CASCADE,
    FOREIGN KEY (id_listener) REFERENCES listeners(id) ON DELETE CASCADE
);
