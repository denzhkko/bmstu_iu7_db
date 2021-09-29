-- выбрать группы, созданные не позже 2011 года

SELECT id,
       name
FROM bands
WHERE YEAR <= 2011;
