------------------------------------------------------------------------------
-- РК 03
-- ИУ7-53Б
-- Недолужко Денис
-- Вариант 4

DROP DATABASE IF EXISTS rk_03;
CREATE DATABASE rk_03;
\c rk_03;

CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    birth DATE NOT NULL,
    dep TEXT NOT NULL
);

CREATE TABLE arrival (
    id SERIAL PRIMARY KEY,
    id_emp INT NOT NULL,
    date DATE NOT NULL,
    weekday TEXT NOT NULL,
    time TIME NOT NULL,
    type INT NOT NULL,
    FOREIGN KEY (id_emp) REFERENCES employee(id) ON DELETE CASCADE
);

INSERT INTO employee (id, name, birth, dep) VALUES
(1, 'Иванов Иван Иванович', '1990-09-25', 'ИТ'),
(2, 'Петров Петр Петрович', '1987-11-12', 'Бухгалтерия'),
(3, 'Недолужко Денис Вадимович', '2001-02-19', 'Пекарь'),
(4, 'Дегтярев Александр Игоревич', '2001-07-19', 'Программист');

INSERT INTO arrival (id_emp, date, weekday, time, type) VALUES
(1, '2018-12-14', 'Суббота', '9:00', 1),
(1, '2018-12-14', 'Суббота', '9:20', 2),
(1, '2018-12-14', 'Суббота', '9:25', 1),
(2, '2018-12-14', 'Суббота', '9:05', 1),
(3, '2020-12-18', 'Суббота', '10:25', 1),
(3, '2020-12-18', 'Суббота', '19:15', 2);

CREATE OR REPLACE FUNCTION get_truants(today DATE)
RETURNS TABLE (name TEXT, dep TEXT) AS
$$
BEGIN
    RETURN QUERY
        SELECT e.name, e.dep
        FROM employee e
        WHERE id NOT IN (
            SELECT DISTINCT e.id
            FROM employee e
            JOIN arrival a ON a.id_emp = e.id
            WHERE a.date = today AND a.type = 1);
END;
$$
LANGUAGE PLPGSQL;
SELECT * FROM get_truants('2020-12-18');

-- 1. Найти сотрудников, опоздавших сегодня меньше чем на 5 минут
SELECT e.id, e.name FROM employee e JOIN arrival a ON a.id_emp = e.id
WHERE a.date = '2018-12-14' AND a.type = 1 AND DATE_PART('minute', a.time::TIME - '9:00'::TIME) < 5;

-- 2. Найти сотрудников, которые выходили больше чем на 10 минут
SELECT id_emp, out_time, in_time FROM (
    SELECT id_emp, out_time, min(in_time) AS in_time FROM (
        SELECT a1.id_emp AS id_emp, a1.time AS out_time, a2.time AS in_time
        FROM arrival AS a1
        JOIN arrival a2 ON a2.time > a1.time AND a2.date = a1.date
        WHERE a1.type = 2 AND a2.type = 1) AS foo
    GROUP BY id_emp, out_time) AS bar
WHERE DATE_PART('minute', in_time::TIME - out_time::TIME) > 10;

-- 3. Найти сотрудников бухгалтерии, приходящих на работу раньше 8:00
SELECT e.id, e.name FROM employee e JOIN arrival a ON a.id_emp = e.id
WHERE e.dep = 'Бухгалтерия' AND a.type = 1 AND a.time < '8:00'::TIME;
