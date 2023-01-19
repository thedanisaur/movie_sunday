CREATE TABLE people (
      person_id BINARY(16) PRIMARY KEY
    , person_username VARCHAR(255) NOT NULL
    , person_password VARCHAR(255) NOT NULL
    , person_email VARCHAR(255) NOT NULL
    , person_created_on DATE NOT NULL
    , person_updated_on DATE NOT NULL

    , UNIQUE (person_username, person_email)
);

DROP TRIGGER IF EXISTS bi_people;
DELIMITER $$
CREATE TRIGGER bi_people BEFORE INSERT ON people FOR EACH ROW
BEGIN
    SET NEW.person_username = LOWER(NEW.person_username);
    IF (NEW.person_id IS NULL) THEN
        SET NEW.person_id = UUID_TO_BIN(UUID());
    END IF;
    IF (NEW.person_created_on IS NULL) THEN
        SET NEW.person_created_on = CURDATE();
    END IF;
    IF (NEW.person_updated_on IS NULL) THEN
        SET NEW.person_updated_on = CURDATE();
    END IF;
END;
$$