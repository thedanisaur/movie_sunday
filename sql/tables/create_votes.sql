CREATE SEQUENCE votes_id_seq;

CREATE TABLE votes (
      vote_id INTEGER PRIMARY KEY DEFAULT nextval('votes_id_seq')
    , vote_value TEXT CHECK (vote_value = 'GOOD' OR vote_value = 'BAD')
    , movie_name TEXT NOT NULL
    , person_name TEXT NOT NULL

    , UNIQUE (movie_name, person_name)
    
    , CONSTRAINT votes_movie_name_fkey FOREIGN KEY (movie_name)
        REFERENCES movies (movie_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
    
    , CONSTRAINT persons_person_name_fkey FOREIGN KEY (person_name)
        REFERENCES persons (person_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
