CREATE EXTENSION IF NOT EXISTS plpython3u;

-- 1
-- Определяемая пользователем скалярная функция CLR
-- Возвращает возраст по году рождения
CREATE OR REPLACE FUNCTION get_age(start_year INTEGER)
RETURNS INTEGER
AS $$
  import datetime

  return datetime.datetime.now().year - start_year
$$ LANGUAGE PLPYTHON3U;

SELECT name, get_age(year) AS age FROM bands;

-- 2
-- Пользовательская агрегатная функция CLR
-- Возвращает среднюю оценку песен по жанру
CREATE OR REPLACE FUNCTION get_avg_rating(a_genre TEXT)
RETURNS DECIMAL
AS $$
  query = """SELECT rating
              FROM (SELECT id FROM songs WHERE genre = '{:s}') sg
              JOIN rel_listeners_rate_songs sr
              ON sg.id = sr.id_song"""
  query = query.format(a_genre);
  res = plpy.execute(query)

  rating_cnt  = len(res)
  rating_sum = 0
  for rating in res:
    rating_sum += rating["rating"]
  return rating_sum / rating_cnt
$$ LANGUAGE PLPYTHON3U;

SELECT get_avg_rating('Metal');

-- 3
-- Определяемая пользователем табличная функция CLR
-- Возвращает группы исполняет песни в заданном жанре
CREATE OR REPLACE FUNCTION get_bands_sings(a_genre TEXT)
RETURNS TABLE (id UUID, name TEXT)
AS $$
  query = """SELECT DISTINCT sg.id, sg.name
              FROM (SELECT id, name FROM songs WHERE genre = '{:s}') sg
              JOIN rel_listeners_rate_songs sr
              ON sg.id = sr.id_song"""
  query = query.format(a_genre);
  res = plpy.execute(query)

  for row in res:
    yield(row['id'], row['name'])
$$ LANGUAGE PLPYTHON3U;

SELECT * FROM get_bands_sings('Metal');


-- 4
-- Хранимая процедура CLR
-- Обновляет оценку пользователя
CREATE OR REPLACE PROCEDURE update_user_rating(a_id UUID, a_new_rate INTEGER)
AS $$
  plan = plpy.prepare(
      "UPDATE rel_listeners_rate_songs SET rating = $2 WHERE id = $1;",
      ["UUID", "INTEGER"])
  plpy.execute(plan, [a_id, a_new_rate])
$$ LANGUAGE PLPYTHON3U;


-- 5
-- Триггер CLR
-- Выводит сообщение, если первый комментарий к песне
CREATE OR REPLACE FUNCTION print_if_first_comment_py() RETURNS TRIGGER AS $$
AS $$
    query = '''SELECT count(*) as cmt_cnt
        INTO cmt_cnt
        FROM rel_listeners_comment_songs
        WHERE id_song = {:s};'''.format(TD["new"]["id_song"])

    cnt = plpy.execute(query)[0]['cmt_cnt'])

    if 1 == cnt:
      plpy.notice("Comment {:s} is a first comment to song {:s}".format(
          TD["new"]["id"], TD["new"]["id_song"]))
$$ LANGUAGE PLPYTHON3U;


CREATE TRIGGER trg_print_if_first_comment_py AFTER
INSERT ON rel_listeners_comment_songs
FOR ROW EXECUTE PROCEDURE print_if_first_comment_py();


-- 6
-- Определяемый пользователем тип данных CLR
CREATE TYPE name_year AS (
  name TEXT,
  year INTEGER
);

CREATE OR REPLACE FUNCTION set_name_year(a_name TEXT, a_year INTEGER)
RETURNS SETOF name_year
AS $$
    return ([a_name, a_year],)
$$ LANGUAGE PLPYTHON3U;

SELECT * FROM set_name_year('Denis', 2001);
