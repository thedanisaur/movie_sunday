CREATE TABLE movies (
      movie_name VARCHAR(255) PRIMARY KEY
    , movie_title TEXT NOT NULL
    , movie_year_watched DATE
    , series_name VARCHAR(255) NOT NULL
    
    , CONSTRAINT movies_series_name_fkey FOREIGN KEY (series_name)
        REFERENCES series (series_name) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
