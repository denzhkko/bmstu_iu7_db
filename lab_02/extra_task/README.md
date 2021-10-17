```sh
psql -h localhost -p 5432 -U postgres -W -f create_database.sql

psql -h localhost -p 5432 -U deniska -d lab_02_extra -W \
        -f fill_table.sql

psql -h localhost -p 5432 -U deniska -d lab_02_extra -W \
        -f query.sql
```
