CREATE TABLE trackers (
      tracker_id BINARY(16) PRIMARY KEY
    , tracker_text VARCHAR(255) NOT NULL
    , tracker_created_on DATE NOT NULL
    , tracker_updated_on DATE
    , person_id BINARY(16) NOT NULL
    
    , CONSTRAINT trackers_people_person_id_fkey FOREIGN KEY (person_id)
        REFERENCES people (person_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);