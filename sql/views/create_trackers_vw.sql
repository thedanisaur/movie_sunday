DROP VIEW IF EXISTS trackers_vw;

CREATE OR REPLACE VIEW trackers_vw
AS
    SELECT  BIN_TO_UUID(trackers.tracker_id) AS tracker_id
        , trackers.tracker_text
        , SUM(IFNULL(movie_trackers.tracker_count, 0)) tracker_count
        , trackers.tracker_created_on
        , IFNULL(trackers.tracker_updated_on, trackers.tracker_created_on) AS tracker_updated_on
        , people.person_username AS tracker_created_by
    FROM    trackers
    INNER JOIN people ON
            trackers.person_id = people.person_id
    LEFT JOIN movie_trackers ON
            trackers.tracker_id = movie_trackers.tracker_id
    GROUP BY trackers.tracker_id
    ORDER BY tracker_updated_on DESC
            , tracker_count DESC
            , tracker_created_on
            , tracker_created_by
;
