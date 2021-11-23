-- 1
-- Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
-- данные в JSON.

\t -- tuple only
\a -- aligned off

\o /home/deniska/dev/bmstu_iu7_db/lab_05/json/labels.json
SELECT row_to_json(l) FROM labels l;

\o /home/deniska/dev/bmstu_iu7_db/lab_05/json/albums.json
SELECT row_to_json(a) FROM albums a;

\o

-- 2
-- Выполнить загрузку и сохранение файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

CREATE TABLE labels_from_json (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    founder TEXT NOT NULL,
    year INTEGER NOT NULL,
    country TEXT NOT NULL,
    about TEXT
);

CREATE TEMP TABLE temp_json (
      data jsonb
);

COPY temp_json (data) FROM '/var/lib/postgresql/mydata/labels.json';

INSERT INTO labels_from_json(id, name, founder, year, country, about)
SELECT (data->>'id')::UUID
       , data->>'name'
       , data->>'founder'
       , (data->>'year')::INTEGER
       , data->>'country'
       , data->>'about'
FROM temp_json;


-- 3
-- Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
-- добавить атрибут с типом XML или JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT
-- или UPDATE.

CREATE TABLE books (
      data jsonb
);

INSERT INTO books (data) VALUES 
('{"author": "Scott Meyers", "title": "Effective Modern C++", "reseller": [{"name": "Chitai Gorod", "price": 10}, {"name": "Labirint", "price": 12}]}'), 
('{"author": "Yegor Bugayenko", "title": "Elegant Objects", "reseller": [{"name": "Chitai Gorod", "price": 15}, {"name": "Labirint", "price": 17}]}');


-- 4.1
-- Извлечь XML/JSON фрагмент из XML/JSON документа

SELECT data->>'reseller' author FROM books;

-- 4.2
-- Извлечь значения конкретных узлов или атрибутов XML/JSON документа

SELECT data->>'author' author FROM books;

-- 4.3
-- Выполнить проверку существования узла или атрибута

CREATE FUNCTION if_key_exists(json_to_check jsonb, key text)
RETURNS BOOLEAN 
AS $$
BEGIN
  RETURN (json_to_check->key) IS NOT NULL;
END;
$$ LANGUAGE PLPGSQL;

SELECT if_key_exists('{"author": "Yegor Bugayenko", "title": "Elegant Objects", "reseller": [{"name": "Chitai Gorod", "price": 15}, {"name": "Labirint", "price": 17}]}', 'author');
SELECT if_key_exists('{"author": "Yegor Bugayenko", "title": "Elegant Objects", "reseller": [{"name": "Chitai Gorod", "price": 15}, {"name": "Labirint", "price": 17}]}', 'noauthor');

-- 4.4
-- Изменить XML/JSON документ

UPDATE books SET data = data || '{"title": "Elegant Objects 2"}'::jsonb WHERE data->'author' = "Yegor Bugayenko";


-- 4.5
-- Разделить XML/JSON документ на несколько строк по узлам

SELECT * FROM jsonb_array_elements('[
  {"author": "Scott Meyers", "title": "Effective Modern C++", "reseller": [{"name": "Chitai Gorod", "price": 10}, {"name": "Labirint", "price": 12}]},
  {"author": "Yegor Bugayenko", "title": "Elegant Objects", "reseller": [{"name": "Chitai Gorod", "price": 15}, {"name": "Labirint", "price": 17}]}
]');
