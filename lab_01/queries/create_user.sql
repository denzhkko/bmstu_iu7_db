CREATE DATABASE musicdb;

CREATE USER deniska WITH ENCRYPTED PASSWORD 'deniska';

GRANT ALL PRIVILEGES ON DATABASE musicdb TO deniska;
GRANT pg_read_server_files TO deniska;
