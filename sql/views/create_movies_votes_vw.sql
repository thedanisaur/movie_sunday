DROP VIEW IF EXISTS movies_votes_vw;

CREATE OR REPLACE VIEW movies_votes_vw
AS
    SELECT    vw.movie_name
            , m.series_name
            , d.vote_value AS "dan"
            , n.vote_value AS "nick"
    FROM      movies m
            , (
                SELECT    v.movie_name
                        , v.person_name
                        , v.vote_value
                FROM    votes v
                GROUP BY  v.movie_name
                        , v.person_name
                        , v.vote_value
              ) vw
            , votes n
            , votes d
    WHERE   m.movie_name = vw.movie_name
    AND     vw.movie_name = n.movie_name AND n.person_name = 'NICK'
    AND     vw.movie_name = d.movie_name AND d.person_name = 'DAN'
    GROUP BY  vw.movie_name
            , m.series_name
            , n.vote_value
            , d.vote_value
    ORDER BY  vw.movie_name
;
