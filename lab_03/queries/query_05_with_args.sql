-- Обновить описание группы

CREATE OR REPLACE PROCEDURE update_band_about(id_ uuid, new_about_ TEXT)
AS $$
BEGIN
    UPDATE bands SET about=new_about_ WHERE id = id_;
END
$$ LANGUAGE PLPGSQL;

