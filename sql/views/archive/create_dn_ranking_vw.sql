DROP VIEW IF EXISTS dn_ranking_vw;

CREATE OR REPLACE VIEW dn_ranking_vw
AS
    SELECT  series_name
          , chosen_by
          , movies_in_series
          , dan_liked
          , nick_liked
          , ROUND((dan_avg + nick_avg) / 2, 3) AS "rnk"
    FROM  (
            SELECT  s.series_name
                  , p.person_username AS "chosen_by"
                  , mis_vw.movies_in_series
                  , dan_liked.number AS "dan_liked"
                  , nick_liked.number AS "nick_liked"
                  , ROUND(dan_liked.number / mis_vw.movies_in_series * 100, 2) AS "dan_avg"
                  , ROUND(nick_liked.number / mis_vw.movies_in_series * 100, 2) AS "nick_avg"
            FROM    series s
                  , people p
                  , movies_in_series_vw mis_vw
                  , (
                        SELECT  mv_vw.series_name
                            , COUNT(*) "number"
                        FROM    movies_votes_vw mv_vw
                        WHERE   mv_vw.dan_vote = 'GOOD'
                        GROUP BY mv_vw.series_name
                    ) dan_liked
                  , (
                        SELECT  mv_vw.series_name
                            , COUNT(*) "number"
                        FROM    movies_votes_vw mv_vw
                        WHERE   mv_vw.nick_vote = 'GOOD'
                        GROUP BY mv_vw.series_name
                    ) nick_liked
            WHERE   s.series_name = mis_vw.series_name
            AND     s.series_name = dan_liked.series_name
            AND     s.series_name = nick_liked.series_name
            AND     s.person_id = p.person_id
          ) series_ranks
    ORDER BY rnk DESC
            , movies_in_series DESC
            , series_name
;
