## Зависимости

- docker
- docker-compose
- psql

Python modules:

- faker
- faker\_music

## Запуск

```sh
python3 gen_table_data.py

docker-compose up -d

psql -h localhost -p 5432 -U postgres -W -f queries/create_user.sql
psql -h localhost -p 5432 -U deniska -d musicdb -W \
        -f queries/create_tables.sql
psql -h localhost -p 5432 -U deniska -d musicdb -W \
        -f queries/fill_out_tables.sql
```

### Дополнительное задание

Добавить к таблице listener поля (мигрировать базу данных):

* язык
* страна

```sh
python3 gen_migr_1_2.py

psql -h localhost -p 5432 -U deniska -d musicdb -W -f queries/migr_1_2.sql
```
