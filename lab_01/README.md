## Запуск

Запуск docker контейнера

```sh
docker run --name mypostgres -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres
```

Создание пользователя, базы данных и передача прав на бд пользователю

```sh
psql -h localhost -p 5432 -U postgres -W -f create_user.sql
```

Создание таблиц

```sh
psql -h localhost -p 5432 -U deniska -d musicdb -W -f create_tables.sql
```
