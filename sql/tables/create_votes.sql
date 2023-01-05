CREATE TABLE votes (
      vote_id INTEGER PRIMARY KEY AUTO_INCREMENT
    , vote_value TEXT CHECK (vote_value = 'GOOD' OR vote_value = 'BAD')
    , movie_name VARCHAR(255) NOT NULL
    , person_id BINARY(16) NOT NULL

    , UNIQUE (movie_name, person_id)
    
    , CONSTRAINT votes_movie_name_fkey FOREIGN KEY (movie_name)
        REFERENCES movies (movie_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    
    , CONSTRAINT people_person_id_vote_fkey FOREIGN KEY (person_id)
        REFERENCES people (person_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);