DROP VIEW IF EXISTS dn_movies_votes_vw;

CREATE OR REPLACE VIEW dn_movies_votes_vw
AS
    SELECT  series_name
          , series_title
          , movie_name
          , movie_title
          , movie_created_on
          , IFNULL(MAX(CASE WHEN person_username = 'dan' THEN vote_value ELSE NULL END), 'NULL') AS 'dan_vote'
          , IFNULL(MAX(CASE WHEN person_username = 'nick' THEN vote_value ELSE NULL END), 'NULL') AS 'nick_vote'
    FROM    movies_votes_vw
    GROUP BY  series_name
            , movie_name
            , movie_title
    ORDER BY  movie_created_on DESC
;
