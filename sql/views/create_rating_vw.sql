DROP VIEW IF EXISTS rating_vw;

CREATE OR REPLACE VIEW rating_vw
AS
    SELECT  series_title
          , series_name
          , series_order
          , series_created_on
          , chosen_by
          , movies_in_series
          , good_votes
          , bad_votes
          , total_votes
          , IFNULL(ROUND(good_votes / total_votes, 5) * 100, 0) AS "rating"
    FROM  (
            SELECT  series.series_title
                  , series.series_name
                  , series.series_order
                  , series.series_created_on
                  , people.person_username AS "chosen_by"
                  , IFNULL(movies_in_series_vw.movies_in_series, 0) AS "movies_in_series"
                  , IFNULL(good_votes_vw.number, 0) AS "good_votes"
                  , IFNULL(bad_votes_vw.number, 0) AS "bad_votes"
                  , IFNULL(good_votes_vw.number, 0) + IFNULL(bad_votes_vw.number,0) AS "total_votes"
            FROM  series
            LEFT JOIN good_votes_vw ON
                  series.series_name = good_votes_vw.series_name
            LEFT JOIN bad_votes_vw ON
                  series.series_name = bad_votes_vw.series_name
            LEFT JOIN movies_in_series_vw ON
                  series.series_name = movies_in_series_vw.series_name
            INNER JOIN people ON
                  series.person_id = people.person_id
          ) series_rating
    ORDER BY rating DESC
            , movies_in_series DESC
            , series_rating.series_name
;
