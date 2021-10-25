CREATE TABLE series (
      series_name TEXT PRIMARY KEY
    , series_title TEXT NOT NULL
    , person_name TEXT NOT NULL
    
    , CONSTRAINT persons_person_name_fkey FOREIGN KEY (person_name)
        REFERENCES persons (person_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
