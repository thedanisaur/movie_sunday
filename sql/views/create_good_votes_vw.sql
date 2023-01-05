DROP VIEW IF EXISTS good_votes_vw;

CREATE OR REPLACE VIEW good_votes_vw
AS
    SELECT  s.series_name
        , COUNT(*) "number"
    FROM    series s
        , 	movies m
        ,	votes v
    WHERE   s.series_name = m.series_name
    AND		m.movie_name = v.movie_name
    AND 	v.vote_value = 'GOOD'
    GROUP BY s.series_name
;
