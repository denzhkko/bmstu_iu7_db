-- Запретить добавление в таблицу групп в названии которых есть слово hate

CREATE OR REPLACE FUNCTION no_hate_bands() RETURNS TRIGGER AS $$
BEGIN
    IF lower(NEW.NAME) like '%hate%' THEN
        RAISE NOTICE '% in black list. No hate group', new.name;
    ELSE
        insert into bands (
            id,
            name,
            year,
            country,
            about
        ) VALUES (
            new.id,
            new.name,
            new.year,
            new.country,
            new.about
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE VIEW bands_view AS
SELECT *
FROM bands;


CREATE TRIGGER trg_good_band_name INSTEAD OF
INSERT ON bands_view
FOR EACH ROW EXECUTE PROCEDURE no_hate_bands();

-- insert into bands_view (id, name, year, country, about) values ('9249638a-66e1-4a38-a847-84ba632763fe', 'Band hate name', 2021, 'Russia', 'about');
