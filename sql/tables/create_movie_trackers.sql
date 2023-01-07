CREATE TABLE movie_trackers (
      movie_tracker_id BINARY(16) PRIMARY KEY
    , movie_name VARCHAR(255) NOT NULL
    , tracker_id BINARY(16) NOT NULL
    , tracker_count INT NOT NULL
    , movie_tracker_created_by BINARY(16) NOT NULL
    , movie_tracker_created_on DATE NOT NULL
    , movie_tracker_updated_on DATE

    , UNIQUE (tracker_id, movie_name, movie_tracker_created_by)
    
    , CONSTRAINT movie_trackers_movie_name_fkey FOREIGN KEY (movie_name)
        REFERENCES movies (movie_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    
    , CONSTRAINT movie_trackers_tracker_id_fkey FOREIGN KEY (tracker_id)
        REFERENCES trackers (tracker_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    
    , CONSTRAINT movie_tracker_person_id_fkey FOREIGN KEY (movie_tracker_created_by)
        REFERENCES people (person_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);