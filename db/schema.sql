CREATE DATABASE my_eleven;

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name TEXT,
    image_url TEXT,
    age INTEGER,
    team TEXT,
    playing_role TEXT

);

INSERT INTO players (name, image_url, age, team, playing_role) VALUES ('Virat Kohli', 'https://www.espncricinfo.com/inline/content/image/1183835.html?alt=1', '31', 'India', 'Top-order batsman');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT,
    password_digest TEXT
);

ALTER TABLE players ADD COLUMN user_id INTEGER;