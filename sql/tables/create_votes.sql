CREATE TABLE votes (
      vote_id INTEGER PRIMARY KEY AUTO_INCREMENT
    , vote_value TEXT CHECK (vote_value = 'GOOD' OR vote_value = 'BAD')
    , vote_created_on DATE NOT NULL
    , movie_name VARCHAR(255) NOT NULL
    , person_id BINARY(16) NOT NULL

    , UNIQUE (movie_name, person_id)
    
    , CONSTRAINT votes_movies_movie_name_fkey FOREIGN KEY (movie_name)
        REFERENCES movies (movie_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    
    , CONSTRAINT votes_people_person_id_fkey FOREIGN KEY (person_id)
        REFERENCES people (person_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

DROP TRIGGER IF EXISTS bi_votes;
CREATE TRIGGER bi_votes BEFORE INSERT ON votes FOR EACH ROW
BEGIN
    IF (NEW.vote_created_on IS NULL) THEN
        SET NEW.vote_created_on = (SELECT IFNULL(movie_created_on, CURDATE()) FROM movies WHERE movie_name = NEW.movie_name);
    END IF;
END;