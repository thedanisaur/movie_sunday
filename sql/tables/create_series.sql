CREATE TABLE series (
     series_order int NOT NULL AUTO_INCREMENT PRIMARY KEY
    , series_name VARCHAR(255)
    , series_title TEXT NOT NULL
    , person_id BINARY(16) NOT NULL
    
    , CONSTRAINT people_person_id_series_fkey FOREIGN KEY (person_id)
        REFERENCES people (person_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    , UNIQUE (series_name)
);
