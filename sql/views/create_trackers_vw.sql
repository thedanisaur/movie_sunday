DROP VIEW IF EXISTS trackers_vw;

CREATE OR REPLACE VIEW trackers_vw
AS
    SELECT  tracker_id
          , tracker_text
          , tracker_count
          , tracker_created_on
          , tracker_updated_on
          , tracker_created_by
    FROM  (
            SELECT  BIN_TO_UUID(trackers.tracker_id) AS tracker_id
                , trackers.tracker_text
                , SUM(IFNULL(movie_trackers.tracker_count, 0)) tracker_count
                , trackers.tracker_created_on
                , IFNULL(trackers.tracker_updated_on, '') AS tracker_updated_on
                , people.person_username AS tracker_created_by
            FROM    trackers
            INNER JOIN people ON
                    trackers.person_id = people.person_id
            LEFT JOIN movie_trackers ON
                    trackers.tracker_id = movie_trackers.tracker_id
            GROUP BY trackers.tracker_id
          ) t
    ORDER BY t.tracker_updated_on DESC
            , t.tracker_count DESC
            , t.tracker_created_on
            , t.tracker_created_by
;
