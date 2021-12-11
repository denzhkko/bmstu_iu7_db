-- Защита ЛР 4-5
-- загрузить альбом с песнями из json через процедуру на python

-- json для загрузки в файле def_songs.json

CREATE OR REPLACE PROCEDURE add_album(a_albumname TEXT
                                      , a_albumyear INTEGER
                                      , a_filepath TEXT)
AS $$
import json
import uuid

with open(a_filepath, 'r') as f:
    fdata = f.read()
js = json.loads(fdata)

songguids = []

for item in js:
    guid = str(uuid.uuid4())
    name = item['name']
    genre = item['genre']

    query = f"INSERT INTO songs (id, name, genre) VALUES ('{guid}', '{name}', '{genre}')"
    plpy.execute(query)

    songguids.append(guid)


albumguid = str(uuid.uuid4())
query = f"INSERT INTO albums (id, name, year) VALUES ('{albumguid}', '{a_albumname}', '{a_filepath}')"
plpy.execute(query)

for songguid in songguids:
    guid = str(uuid.uuid4())
    query = f"INSERT INTO rel_albums_contain_songs (id, id_album, id_song) VALUES ('{guid}', '{albumguid}', '{songguid}')"
    plpy.execute(query)
$$ LANGUAGE PLPYTHON3U;
