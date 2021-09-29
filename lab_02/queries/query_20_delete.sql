-- удалить группы без описания

DELETE
FROM bands
WHERE about IS NULL;
