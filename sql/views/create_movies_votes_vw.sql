DROP VIEW IF EXISTS movies_votes_vw;

CREATE OR REPLACE VIEW movies_votes_vw
AS
  SELECT  m.series_name
        , s.series_title
        , m.movie_name
        , m.movie_title
        , m.movie_created_on
        , vw.person_username
        , vw.vote_value
  FROM  movies m
	LEFT JOIN (
              SELECT  v.movie_name
                    , v.vote_value
                    , p.person_username
              FROM    votes v
                    , people p
              WHERE   v.person_id = p.person_id
            ) vw ON
		m.movie_name = vw.movie_name
  INNER JOIN series s ON
    m.series_name = s.series_name
;
