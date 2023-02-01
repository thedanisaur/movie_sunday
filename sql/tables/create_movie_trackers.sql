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

    , CONSTRAINT movie_tracker_tracker_count_gtz CHECK (`tracker_count` > 0)
);

DROP TRIGGER IF EXISTS bi_movie_trackers;
CREATE TRIGGER bi_movie_trackers BEFORE INSERT ON movie_trackers FOR EACH ROW
BEGIN
    SET NEW.movie_tracker_id = UUID_TO_BIN(UUID());
    SET NEW.movie_tracker_created_on = CURDATE();
END;

DROP TRIGGER IF EXISTS bu_movie_trackers;
CREATE TRIGGER bu_movie_trackers BEFORE UPDATE ON movie_trackers FOR EACH ROW
    SET NEW.movie_tracker_updated_on = CURDATE();

DROP TRIGGER IF EXISTS au_trackers;
CREATE TRIGGER au_trackers AFTER UPDATE ON movie_trackers FOR EACH ROW
    UPDATE trackers SET tracker_updated_on = CURDATE() WHERE tracker_id = NEW.tracker_id;