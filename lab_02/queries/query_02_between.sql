-- выбрать пользователей, рожденных с 1980 по 1990 года

SELECT id,
       name
FROM listeners
WHERE birth BETWEEN '1980-01-01' AND '1990-01-01';
