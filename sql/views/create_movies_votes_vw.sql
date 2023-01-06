DROP VIEW IF EXISTS movies_votes_vw;

CREATE OR REPLACE VIEW movies_votes_vw
AS
    SELECT    m.movie_title
            , m.movie_name
            , m.series_name
            , d.vote_value AS "dan_vote"
            , n.vote_value AS "nick_vote"
    FROM      movies m
            , (
                SELECT    v.movie_name
                        , v.person_id
                        , v.vote_value
                FROM    votes v
                GROUP BY  v.movie_name
                        , v.person_id
                        , v.vote_value
              ) vw
            , votes n
            , votes d
            , people pn
            , people pd
    WHERE   m.movie_name = vw.movie_name
    AND     vw.movie_name = n.movie_name AND n.person_id = pn.person_id AND pn.person_username = 'NICK'
    AND     vw.movie_name = d.movie_name AND d.person_id = pd.person_id AND pd.person_username = 'DAN'
    GROUP BY  vw.movie_name
            , m.series_name
            , n.vote_value
            , d.vote_value
    ORDER BY  vw.movie_name
;
