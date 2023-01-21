CREATE TABLE series (
    -- TODO This auto increments even when failing to insert a row...ordering can't have gaps
     series_order int NOT NULL AUTO_INCREMENT PRIMARY KEY
    , series_name VARCHAR(255) NOT NULL
    , series_title TEXT NOT NULL
    , series_created_on DATE NOT NULL
    , person_id BINARY(16) NOT NULL
    
    , CONSTRAINT series_people_person_id_fkey FOREIGN KEY (person_id)
        REFERENCES people (person_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    , UNIQUE (series_name)
);
