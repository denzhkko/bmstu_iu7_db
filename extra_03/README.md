```
docker run -d -e POSTGRES_PASSWORD='postgres' --name db_extra_03 -p 5432:5432 postgres

psql -h localhost -p 5432 -U postgres -f scripts/script.sql
```
