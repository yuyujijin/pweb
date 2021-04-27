-- On commence par créer la DB
DROP DATABASE IF EXISTS yasm;
CREATE DATABASE yasm;

-- On s'y connecte
\c yasm;

DROP USER IF EXISTS yasmclient;
-- On créer l'user pour se connecter via le serveur web
CREATE USER yasmclient WITH PASSWORD 'pwd';

CREATE TABLE client(
    id_client SERIAL PRIMARY KEY,
    username VARCHAR(32) NOT NULL UNIQUE,
    password VARCHAR(32) NOT NULL,
    image_url VARCHAR(32) NOT NULL DEFAULT 'default_picture.png'
);

CREATE TABLE post(
    id_post SERIAL PRIMARY KEY,
    id_client INT REFERENCES client(id_client) NOT NULL,
    content TEXT NOT NULL,
    post_date DATE DEFAULT NOW()
);

CREATE TABLE post_like(
    id_post INT REFERENCES post(id_post),
    id_client INT REFERENCES client(id_client),
    PRIMARY KEY(id_post, id_client)
);

CREATE TABLE mention(
    id_post INT REFERENCES post(id_post),
    username VARCHAR(32),
    PRIMARY KEY (id_post, username)
);

CREATE TABLE hashtag(
    id_post INT REFERENCES post(id_post),
    tag VARCHAR(32),
    PRIMARY KEY (id_post, tag)
);

CREATE TABLE subscriber(
    id_from INT REFERENCES client(id_client),
    id_to INT REFERENCES client(id_client),
    PRIMARY KEY (id_from, id_to)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO yasmclient;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO yasmclient;

\copy client(username,password) FROM 'data/client.csv' DELIMITER ';' CSV

\copy post(id_client, content) FROM 'data/post.csv' DELIMITER ';' CSV

INSERT INTO post_like(id_post, id_client) VALUES
(1, 1)
;

INSERT INTO subscriber(id_from, id_to) VALUES
(1, 2)
;