-- 1

-- Создание базы данных и таблиц

CREATE DATABASE rk2;

-- \c rk2

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    snf_mentor TEXT NOT NULL,
    max_hours INTEGER NOT NULL
);

CREATE TABLE parents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    snf TEXT NOT NULL,
    age INTEGER NOT NULL,
    type TEXT NOT NULL
);

CREATE TABLE children (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    snf TEXT NOT NULL,
    birth DATE NOT NULL,
    gender TEXT NOT NULL,
    address TEXT NOT NULL,
    faculty TEXT NOT NULL,
    id_group UUID NOT NULL
);

CREATE TABLE rel_parents_children (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_parent UUID NOT NULL,
    id_child UUID NOT NULL,
    FOREIGN KEY (id_parent) REFERENCES parents(id) ON DELETE CASCADE,
    FOREIGN KEY (id_child) REFERENCES children(id) ON DELETE CASCADE
);

-- Заполнение тестовыми значениями

INSERT INTO groups VALUES ('26c620ce-0930-420d-af6e-c608de1073a8', 'iu7-50b', 'ABC' 15);
INSERT INTO groups VALUES ('e326fbb3-6259-43f9-bd06-3a454a4eac1a', 'iu7-51b', 'ABC' 15);
INSERT INTO groups VALUES ('dec583fd-b697-4fe9-94bd-0bb84594bce3', 'iu7-52b', 'ABC' 15);
INSERT INTO groups VALUES ('23971dad-7649-49e4-b7a0-1f959680d5c1', 'iu7-53b', 'ABC' 15);
INSERT INTO groups VALUES ('947f1333-3326-4485-97e3-9354ef4be236', 'iu7-54b', 'ABC' 13);
INSERT INTO groups VALUES ('924e2899-a46d-49a7-a81b-b3a66befb3fa', 'iu7-55b', 'ABC' 12);
INSERT INTO groups VALUES ('87682a33-3107-41ee-919d-519aea19ab02', 'iu7-56b', 'ABC' 16);
INSERT INTO groups VALUES ('eda48979-a227-471e-8b05-4816157abdd3', 'iu7-57b', 'ABC' 15);
INSERT INTO groups VALUES ('99fd7d1c-d89c-4062-81a9-a66be39bac69', 'iu7-58b', 'ABC' 15);
INSERT INTO groups VALUES ('4787131a-fe0c-4f0b-b6cf-27d5562750c6', 'iu7-58b', 'ABC' 1);
INSERT INTO groups VALUES ('49fb841e-2088-452e-8504-03d5b30fb7bb', 'iu7-58b', 'ABC' 15);

INSERT INTO children VALUES ('42ceea07-625c-470d-ba41-19e83632d833', 'SJK', '2001-06-01', 'male', 'Moscow', 'iu7', '26c620ce-0930-420d-af6e-c608de1073a8');
INSERT INTO children VALUES ('228f232e-40eb-4327-ba0d-a68b5bab0232', 'SJK', '2001-06-01', 'male', 'Moscow', 'iu7', '26c620ce-0930-420d-af6e-c608de1073a8');
INSERT INTO children VALUES ('228f232e-40eb-4327-ba0d-a68b5bab0232', 'SJK', '2001-06-01', 'male', 'Moscow', 'iu7', '26c620ce-0930-420d-af6e-c608de1073a8');
INSERT INTO children VALUES ('ed52d4e3-73c3-48b2-9830-3bf3cd4da5b2', 'SJK', '2001-06-01', 'male', 'Moscow', 'iu7', '26c620ce-0930-420d-af6e-c608de1073a8');

INSERT INTO parents VALUES ('0eaa2ba9-853b-4798-b848-4963462ac357', 'AJD', '15', 'father');

INSERT INTO rel_parents_children VALUES ('3af74579-d0a6-43eb-a77a-816857f5bafa', '0eaa2ba9-853b-4798-b848-4963462ac357', '42ceea07-625c-470d-ba41-19e83632d833');

-- 2

-- Инструкция SELECT, использующая поисковое выражение CASE
-- Вывести информацию о родителях с указанием на совершеннолетие

SELECT
  id
  , snf
  , age
  , CASE
    WHEN age < 18 THEN 'minor'
    ELSE 'adult'
  END mess
FROM parents;

-- Инструкция UPDATE со скалярным подзапросом в предложении SET
-- Установить максимальное количество часов в группе где значение равно нулю как среднее значения групп где оно не равно нулю

UPDATE groups SET max_hours = (SELECT AVG(max_hours) FROM groups WHERE max_hours <> 0) where max_hours = 0;

-- Инструкцию SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING
-- Вывести группы количество детей в которых больше 3

SELECT groups.id, groups.name, COUNT(*) child_cnt FROM groups
JOIN children ON children.id_group = groups.id
GROUP BY groups.id
HAVING COUNT(*) > 3;

-- 3

-- Создать хранимую процедуру без параметров, которая осуществляет поиск
-- ключевого слова 'EXEC' в тексте хранимых процедур в текущей базе
-- данных. Хранимая процедура выводит инструкцию 'EXEC', которая
-- выполняет хранимую процедуру или скалярную пользовательскую
-- функцию. Созданную хранимую процедуру протестировать.

CREATE EXTENSION IF NOT EXISTS plpython3u;


CREATE OR REPLACE PROCEDURE find_exec()
AS $$
  query = """SELECT prosrc
  FROM pg_proc
  """

  res = plpy.execute(query)

  for row in res:
    procsrc = row["prosrc"]
    if 'exec' in procsrc.lower():
      plpy.notice("exec in: " + procsrc)
    else:
      plpy.notice("no exec in: " + procsrc)
$$ LANGUAGE PLPYTHON3U;

call find_exec();

-- Примечание: при тестировании нашел EXEC в теле моей процедуры
