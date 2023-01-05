DROP VIEW IF EXISTS ranking_vw;

CREATE OR REPLACE VIEW ranking_vw
AS
    SELECT  series_title
          , chosen_by
          , movies_in_series
          , good_votes
          , bad_votes
          , total_votes
          , IFNULL(ROUND(good_votes / total_votes, 5) * 100, 0) AS "rnk"
    FROM  (
            SELECT  series.series_title
                  , series.series_name
                  , people.person_username AS "chosen_by"
                  , movies_in_series_vw.movies_in_series
                  , IFNULL(good_votes_vw.number, 0) AS "good_votes"
                  , IFNULL(bad_votes_vw.number, 0) AS "bad_votes"
                  , IFNULL(good_votes_vw.number, 0) + IFNULL(bad_votes_vw.number,0) AS "total_votes"
            FROM  series
            LEFT JOIN good_votes_vw ON
                  series.series_name = good_votes_vw.series_name
            LEFT JOIN bad_votes_vw ON
                  series.series_name = bad_votes_vw.series_name
            INNER JOIN movies_in_series_vw ON
                  series.series_name = movies_in_series_vw.series_name
            INNER JOIN people ON
                  series.person_id = people.person_id
          ) series_ranks
    ORDER BY rnk DESC
            , movies_in_series DESC
            , series_ranks.series_name
;
