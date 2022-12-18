CREATE TABLE series (
      series_name VARCHAR(255) PRIMARY KEY
    , series_title TEXT NOT NULL
    , person_name VARCHAR(32) NOT NULL
    
    , CONSTRAINT people_person_name_series_fkey FOREIGN KEY (person_name)
        REFERENCES people (person_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
