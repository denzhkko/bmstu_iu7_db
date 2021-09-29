-- добавить в таблицу групп новую группу с той же страной, что и у КДИМБ

INSERT INTO bands (name, YEAR, country)
SELECT 'Краснознамённая дивизия имени моей бабушки',
       2008,
       country
FROM bands
WHERE name = 'Комсомольск';
