-- удалить группы, у которых когда либо был контракт с люйблом

DELETE
FROM bands
WHERE EXISTS
    (SELECT *
     FROM rel_bands_cooperate_labels
     WHERE rel_bands_cooperate_labels.id_band = bands.id );
