SELECT t1.id,
       t1.var1,
       t2.var2,
       greatest(t1.valid_from_dttm, t2.valid_from_dttm),
       least(t1.valid_to_dttm, t2.valid_to_dttm)
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id
AND t1.valid_from_dttm <= t2.valid_to_dttm
AND t2.valid_from_dttm <= t1.valid_to_dttm;
