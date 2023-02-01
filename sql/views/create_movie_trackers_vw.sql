DROP VIEW IF EXISTS movie_trackers_vw;

CREATE OR REPLACE VIEW movie_trackers_vw
AS
  SELECT  BIN_TO_UUID(mt.movie_tracker_id) AS movie_tracker_id
        , mt.movie_name
        , mt.tracker_count
        , BIN_TO_UUID(t.tracker_id) AS tracker_id
        , t.tracker_text
        , BIN_TO_UUID(p.person_id) AS person_id
        , p.person_username
  FROM    movie_trackers mt
        , trackers t
        , people p
  WHERE   mt.movie_tracker_created_by = p.person_id
  AND     mt.tracker_id = t.tracker_id
  ORDER BY mt.movie_name
;
