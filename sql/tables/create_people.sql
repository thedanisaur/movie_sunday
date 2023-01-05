CREATE TABLE people (
      person_id BINARY(16) PRIMARY KEY
    , person_username VARCHAR(255)
    , person_password VARCHAR(255)
    , person_email VARCHAR(255)

    , UNIQUE (person_username, person_email)
);