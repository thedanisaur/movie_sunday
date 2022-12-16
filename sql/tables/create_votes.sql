CREATE TABLE votes (
      vote_id INTEGER PRIMARY KEY AUTO_INCREMENT
    , vote_value TEXT CHECK (vote_value = 'GOOD' OR vote_value = 'BAD')
    , movie_name VARCHAR(255) NOT NULL
    , person_name VARCHAR(32) NOT NULL

    , UNIQUE (movie_name, person_name)
    
    , CONSTRAINT votes_movie_name_fkey FOREIGN KEY (movie_name)
        REFERENCES movies (movie_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    
    , CONSTRAINT persons_person_name_vote_fkey FOREIGN KEY (person_name)
        REFERENCES persons (person_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);