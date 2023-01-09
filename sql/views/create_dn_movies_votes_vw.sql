DROP VIEW IF EXISTS dn_movies_votes_vw;

CREATE OR REPLACE VIEW dn_movies_votes_vw
AS
    SELECT  series_name
            , movie_name
            , movie_title
            , IFNULL(MAX(CASE WHEN person_username = 'DAN' THEN vote_value ELSE NULL END), 'NULL') AS 'dan_vote'
            , IFNULL(MAX(CASE WHEN person_username = 'NICK' THEN vote_value ELSE NULL END), 'NULL') AS 'nick_vote'
    FROM    movies_votes_vw
    GROUP BY  series_name
            , movie_name
            , movie_title
    ORDER BY  movie_name
;
