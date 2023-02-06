INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'mission_impossible_2' AS movie_name
				, 3 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Someone said, "Bitch"'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'mission_impossible_3' AS movie_name
				, 4 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Someone said, "Bitch"'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'blade_runner' AS movie_name
				, 3 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Sexual Assaults'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'blade_runner_2049' AS movie_name
				, 3 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Sexual Assaults'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'blade_runner' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Naked Chicks'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'blade_runner_2049' AS movie_name
				, 14 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Naked Chicks'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'blade_runner_2049' AS movie_name
				, 4 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Naked Dudes'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'puddle_cruiser' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Someone said, "Bitch"'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'puddle_cruiser' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by 
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Sexual Assaults'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'freeloaders' AS movie_name
				, 6 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Naked Chicks'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'freeloaders' AS movie_name
				, 4 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Naked Dudes'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Clowns'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Someone said, "Bitch"'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier' AS movie_name
				, 2 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Naked Chicks'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Sexual Assaults'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier_2' AS movie_name
				, 2 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Clowns'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier_2' AS movie_name
				, 1 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Sexual Assaults'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier_2' AS movie_name
				, 6 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Eye gouges'
    ) t
;

INSERT INTO movie_trackers (
    movie_tracker_id
    , movie_name
    , tracker_id
    , tracker_count
    , movie_tracker_created_by
    , movie_tracker_created_on
    )
SELECT p.movie_tracker_id
, p.movie_name
, t.tracker_id
, p.tracker_count
, p.movie_tracker_created_by
, p.movie_tracker_created_on
FROM (
		SELECT  UUID_TO_BIN(UUID()) AS movie_tracker_id
				, 'terrifier' AS movie_name
				, 5 AS tracker_count
				, person_id AS movie_tracker_created_by
				, CURDATE() AS movie_tracker_created_on
		FROM    people
		WHERE   person_username = 'dan'
	) p,
    (
        SELECT  tracker_id
        FROM    trackers
        WHERE   tracker_text = 'Eye gouges'
    ) t
;