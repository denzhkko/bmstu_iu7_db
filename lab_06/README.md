# ЛР6 "Технология доступа к данным РБД"

Сервер. Асинхронный, на boost, с асинхонным ![postgres](https://github.com/yandex/ozo)

Работают только 2 запроса:

- `/song_cnt`
- `/table`

## Зависимости

- boost
- libpq
- postgresql-server

P.S. Так же необходимо развернуть бд как в прошлых лр

### On ubuntu

```bash
sudo apt install build-essential cmake
sudo apt install libboost-all-dev libpq-dev postgresql-server-dev-all
```

## Build

```bash
# dont forget to install submodules
git submodule update --init --recursive

cmake -B build
# maybe on ubuntu: cmake -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql/ -B build
cmake --build build
```

## Run

```run
./build/server 0.0.0.0 8080 .
```
