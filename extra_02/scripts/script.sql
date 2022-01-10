DROP DATABASE IF EXISTS extra_02;
CREATE DATABASE extra_02;

\c extra_02


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE empl_visits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  department TEXT NOT NULL,
  fio TEXT NOT NULL,
  date DATE NOT NULL,
  status TEXT NOT NULL
);


INSERT INTO empl_visits (department, fio, date, status) VALUES
('ИТ', 'Иванов Иван Иванович', '2020-01-15', 'Больничный'),
('ИТ', 'Иванов Иван Иванович', '2020-01-16', 'На работе'),
('ИТ', 'Иванов Иван Иванович', '2020-01-17', 'На работе'),
('ИТ', 'Иванов Иван Иванович', '2020-01-18', 'На работе'),
('ИТ', 'Иванов Иван Иванович', '2020-01-19', 'Оплачиваемый отпуск'),
('ИТ', 'Иванов Иван Иванович', '2020-01-20', 'Оплачиваемый отпуск');

INSERT INTO empl_visits (department, fio, date, status) VALUES
('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-15', 'Оплачиваемый отпуск'),
('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-16', 'На работе'),
('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-17', 'На работе'),
('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-18', 'На работе'),
('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-19', 'Оплачиваемый отпуск'),
('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-20', 'Оплачиваемый отпуск');


WITH empl_visitsr_n AS (
  SELECT department
         , fio
         , date AS date
         , status
         , row_number() OVER (
         PARTITION BY department, fio, status ORDER BY date) AS n
  FROM empl_visits
)
SELECT department, fio, min(date) date_from, max(date) date_to, status
FROM empl_visitsr_n
GROUP BY department, fio, status, date - make_interval(0, 0, 0, n::INT)
ORDER BY department DESC, fio, date_from;
