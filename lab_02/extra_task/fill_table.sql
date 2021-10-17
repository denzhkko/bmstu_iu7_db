DROP TABLE IF EXISTS table1;
DROP TABLE IF EXISTS table2;

CREATE TABLE table1 (
  id INT,
  var1 VARCHAR,
  valid_from_dttm DATE,
  valid_to_dttm DATE
);

CREATE TABLE table2 (
  id INT,
  var2 VARCHAR,
  valid_from_dttm DATE,
  valid_to_dttm DATE
);

INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm)
VALUES
  (1, 'A', '2018-09-01', '2018-09-15'), 
  (1, 'B', '2018-09-16', '5999-12-31');

INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm)
VALUES 
  (1, 'A', '2018-09-01', '2018-09-18'),
  (1, 'B', '2018-09-19', '5999-12-31');
