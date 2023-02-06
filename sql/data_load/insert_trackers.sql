INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Naked Chicks'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'dan';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Naked Dudes'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'dan';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Sexual Assaults'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'nick';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Wedding Cakes Ruined'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'dan';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Jason Bourne the Bitch'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'nick';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Reverse Jason Bourne the Bitch'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'nick';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Someone said, "Bitch"'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'dan';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Clowns'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'dan';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Affairs'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'nick';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Frenchmen Punched'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'nick';

INSERT INTO trackers (tracker_id, tracker_text, tracker_created_on, tracker_updated_on, person_id)
SELECT  UUID_TO_BIN(UUID())
        , 'Eye gouges'
        , CURDATE()
        , NULL
        , person_id
FROM people
WHERE person_username = 'dan';