CREATE TABLE IF NOT EXISTS projects
(
    owner          VARCHAR(30) NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project VARCHAR(50),
    name           VARCHAR(50) NOT NULL,
    tags project_tag[]
--  FOREIGN KEY (parent_project) REFERENCES projects(name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files(

);
;-- -. . -..- - / . -. - .-. -.--
SELECT CTID FROM projects;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          VARCHAR(30) NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project VARCHAR(50),
    name           VARCHAR(50) NOT NULL,
    tags           project_tag[],
    FOREIGN KEY (owner, parent_project) REFERENCES projects(owner, parent_project, name, tags)  ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          VARCHAR(30) NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project VARCHAR(50),
    name           VARCHAR(50) NOT NULL,
    tags           project_tag[],
    FOREIGN KEY (owner, parent_project) REFERENCES projects(owner, parent_project)  ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          VARCHAR(30) NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project VARCHAR(50),
    name           VARCHAR(50) NOT NULL,
    tags           project_tag[],
    FOREIGN KEY (owner, parent_project) REFERENCES projects(owner, name)  ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS users
(
    name     VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30) NOT NULL,
    role     user_role   NOT NULL
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          VARCHAR(30) NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project VARCHAR(50),
    name           VARCHAR(50) NOT NULL,
    tags           project_tag[],
    UNIQUE (owner, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects(owner, name)  ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id SERIAL PRIMARY KEY,
    parent_project VARCHAR(50),
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id SERIAL PRIMARY KEY,
    parent_project VARCHAR(50) REFERENCES projects(name)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id SERIAL PRIMARY KEY,
    parent_project VARCHAR(50) REFERENCES projects(name),
    data bytea
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project data_name_text
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project data_name_text,
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
drop domain if exists data_name_text cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN data_name_text VARCHAR(100);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project data_name_text,
    name           data_name_text,
    tags           project_tag[],
    UNIQUE (owner, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project data_name_text,
    data           bytea,
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    data           bytea, -- pg_read_binary_file('/path/to/file')
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, data) VALUES;
;-- -. . -..- - / . -. - .-. -.--
SELECT current_user;
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, data)
VALUES ('andrey', 'meshloader', 'Node.h', pg_read_binary_file('/tmp/Node.h'));
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, data)
VALUES ('andrey', 'meshloader', 'Node.h', pg_read_file('/home/plasmaa0/infa/cppbasics/meshloader/src/Node.h')::bytea);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, data)
VALUES ('andrey', 'meshloader', 'Node.h', byteain('/home/plasmaa0/infa/cppbasics/meshloader/src/Node.h'));
;-- -. . -..- - / . -. - .-. -.--
SELECT data FROM files;
;-- -. . -..- - / . -. - .-. -.--
COPY (SELECT data FROM files) TO 'out.h' (FORMAT binary);
;-- -. . -..- - / . -. - .-. -.--
COPY (SELECT data FROM files) TO '/home/plasmaa0/infa/bd_3/database/out.h' (FORMAT binary);
;-- -. . -..- - / . -. - .-. -.--
COPY (SELECT data FROM files) TO '/tmp/out.h' (FORMAT binary);
;-- -. . -..- - / . -. - .-. -.--
COPY (SELECT data FROM files) TO '/tmp/out.h' (FORMAT text );
;-- -. . -..- - / . -. - .-. -.--
COPY (SELECT data FROM files) TO '/tmp/out' (FORMAT binary);
;-- -. . -..- - / . -. - .-. -.--
SELECT encode(data, 'base64') FROM files;
;-- -. . -..- - / . -. - .-. -.--
SELECT pg_ls_dir('/tmp');
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN file_name_text VARCHAR(100);
;-- -. . -..- - / . -. - .-. -.--
SELECT user_name;
;-- -. . -..- - / . -. - .-. -.--
GRANT pg_read_server_files TO postgres WITH ADMIN OPTION;
;-- -. . -..- - / . -. - .-. -.--
GRANT pg_read_server_files TO andrey WITH ADMIN OPTION;
;-- -. . -..- - / . -. - .-. -.--
grant execute on pg_read_binary_file(text) to postgres;
;-- -. . -..- - / . -. - .-. -.--
pg_read_binary_file(text);
;-- -. . -..- - / . -. - .-. -.--
pg_read_binary_file;
;-- -. . -..- - / . -. - .-. -.--
SELECT "current_user"();
;-- -. . -..- - / . -. - .-. -.--
SELECT current_user();
;-- -. . -..- - / . -. - .-. -.--
SELECT role;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM role;
;-- -. . -..- - / . -. - .-. -.--
SELECT role();
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    data           bytea, -- pg_read_binary_file('/path/to/file')
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, data)
VALUES ('andrey', 'meshloader', 'Node.h', pg_read_binary_file('/home/plasmaa0/infa/cppbasics/meshloader/src/Node.h'));
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name)
VALUES ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/Node.h');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    UNIQUE(parent_project, name)
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    UNIQUE(parent_project, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name)
VALUES ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/AneuMeshLoader.cpp'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/FiniteElement.cpp'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/Main.cpp'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/MeshLoader.h'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/AneuMeshLoader.h'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/FiniteElement.h'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/MeshLoader.cpp'),
       ('andrey', 'meshloader', '/home/plasmaa0/infa/cppbasics/meshloader/src/Node.h');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS users
(
    name     user_data_text PRIMARY KEY,
    password user_data_text NOT NULL,
    role     user_role      NOT NULL
);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired(user user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT expire
        FROM tokens
        WHERE expire < CURRENT_TIMESTAMP)
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired("user" user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT expire
        FROM tokens
        WHERE expire < CURRENT_TIMESTAMP)
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired("user" user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT expire
        FROM tokens
        WHERE expire > CURRENT_TIMESTAMP)
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT CURRENT_TIMESTAMP::TIMESTAMP WITHOUT TIME ZONE;
;-- -. . -..- - / . -. - .-. -.--
SELECT CURRENT_TIMESTAMP::TIMESTAMP WITH TIME ZONE;
;-- -. . -..- - / . -. - .-. -.--
SELECT CURRENT_TIMESTAMP + time(3, HOURS);
;-- -. . -..- - / . -. - .-. -.--
SELECT CURRENT_TIMESTAMP + INTERVAL 3 HOURS;
;-- -. . -..- - / . -. - .-. -.--
SELECT CURRENT_TIMESTAMP + INTERVAL '3 HOURS';
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired("user" user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS (SELECT expire
        FROM tokens
        WHERE expire > CURRENT_TIMESTAMP + INTERVAL '3 HOURS')
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
IF EXISTS (SELECT expire
        FROM tokens
        WHERE expire < CURRENT_TIMESTAMP + INTERVAL '3 HOURS')
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired("user" user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS (SELECT expire
        FROM tokens
        WHERE expire < CURRENT_TIMESTAMP + INTERVAL '3 HOURS')
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT user_token_expired('andrey');
;-- -. . -..- - / . -. - .-. -.--
SELECT CURRENT_TIMESTAMP;
;-- -. . -..- - / . -. - .-. -.--
SELECT user_valid_token('andrey', '5d92bdf1-bc30-455d-8fa1-19cbc84bef8c');
;-- -. . -..- - / . -. - .-. -.--
SELECT user_valid_token('andrey', '6d92bdf1-bc30-455d-8fa1-19cbc84bef8c');
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired("user" user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT expire
              FROM tokens
              WHERE expire < CURRENT_TIMESTAMP + INTERVAL '3 HOURS')
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT name FROM users WHERE name = 'andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*) FROM users WHERE name = 'andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)==1 FROM users WHERE name = 'andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 FROM users WHERE name = 'andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 AS RESULT FROM users WHERE name = 'andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 AS RESULT FROM users WHERE name = 'adrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM tokens WHERE username='andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*) FROM tokens WHERE username='andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 FROM tokens WHERE username='andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 AS result FROM tokens WHERE username='andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andrey' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 FROM users WHERE name='andrey' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 AS is_valid FROM users WHERE name='andrey' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT COUNT(*)=1 AS is_valid FROM users WHERE name='andrey' AND password='1223456789';
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO users(name, password, role)
VALUES ('andrey', '123456789', 'admin'::user_role),
       ('senya', '123456789', 'default'::user_role);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, name, tags)
VALUES ('andrey', 'prog', '{"code"}');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags)
VALUES ('andrey', 'prog', 'cpp', '{"code", "cpp"}'),
       ('andrey', 'prog', 'python', '{"code", "py"}');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags)
VALUES ('andrey', 'cpp', 'meshloader', '{"code", "cpp"}'),
       ('andrey', 'cpp', 'stl', '{"code", "cpp"}'),
       ('andrey', 'python', 'flask-app', '{"code", "py"}'),
       ('andrey', 'python', 'tg-bot', '{"code", "py"}');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name)
VALUES ('andrey', 'meshloader', '/src/AneuMeshLoader.cpp'),
       ('andrey', 'meshloader', '/src/FiniteElement.cpp'),
       ('andrey', 'meshloader', '/src/Main.cpp'),
       ('andrey', 'meshloader', '/src/MeshLoader.h'),
       ('andrey', 'meshloader', '/src/AneuMeshLoader.h'),
       ('andrey', 'meshloader', '/src/FiniteElement.h'),
       ('andrey', 'meshloader', '/src/MeshLoader.cpp'),
       ('andrey', 'meshloader', '/src/Node.h');
;-- -. . -..- - / . -. - .-. -.--
SELECT token,expire FROM tokens WHERE username='andrey';
;-- -. . -..- - / . -. - .-. -.--
SELECT token, expire
FROM tokens
WHERE username = 'andrey';
;-- -. . -..- - / . -. - .-. -.--
ascade;
drop table if exists users cascade;
drop table if exists files cascade;
drop table if exists tokens cascade;;
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, name, tags)
VALUES ('andrey123', 'prog', '{"code"}');
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner='andrey123' AND parent_project IS NULL;
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, name, tags)
VALUES ('andrey123', 'prog', '{"code"}'),
       ('andrey123', 'kikir', '{"math"}');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           project_tag[],
    UNIQUE (owner, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, name, tags)
VALUES ('andrey123', 'prog', '{"code"}'),
       ('andrey123', 'kikir', '{"math", "cpp"}');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags)
VALUES ('andrey123', 'prog', 'cpp', '{"code", "cpp"}'),
       ('andrey123', 'prog', 'python', '{"code", "py"}');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags)
VALUES ('andrey123', 'cpp', 'meshloader', '{"code", "cpp"}'),
       ('andrey123', 'cpp', 'stl', '{"code", "cpp"}'),
       ('andrey123', 'python', 'flask-app', '{"code", "py"}'),
       ('andrey123', 'python', 'tg-bot', '{"code", "py"}');
;-- -. . -..- - / . -. - .-. -.--
SELECT name, array_agg(tags)::text[]FROM projects WHERE owner='andrey123' AND parent_project IS NULL
group by name;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, array_agg(tags)::text[] FROM projects WHERE owner='andrey123' AND parent_project IS NULL
group by name;
;-- -. . -..- - / . -. - .-. -.--
tags;
;-- -. . -..- - / . -. - .-. -.--
user_token_expired;
;-- -. . -..- - / . -. - .-. -.--
SELECT name FROM users WHERE username='andrey123' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT name FROM users WHERE name='andrey123' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andrey123' OR '1'='1' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andrey1235' OR '1'='1' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andrey123' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andrey1223' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andre1243567y123' OR '1'='1' AND password='12323425365456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andre1243567y123' OR '1'='1' AND password='123456789';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM users WHERE name='andre1243567y123' OR '1'='1' AND password='12345656789' OR '1'='1';
;-- -. . -..- - / . -. - .-. -.--
SELECT unnest(
  string_to_array('prog/python/tg-bot', '/')
) AS parts;
;-- -. . -..- - / . -. - .-. -.--
DO
$do$
    BEGIN
        FOR i IN unnest(string_to_array('prog/python/tg-bot', '/'))
            LOOP
        SELECT * FROM projects WHERE parent_project=i;
            END LOOP;
    END
$do$;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    UNIQUE (parent_project, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE path_to LIKE '%bot';
;-- -. . -..- - / . -. - .-. -.--
SELECT owner FROM projects WHERE path_to = '/prog/python/tg-bot' AND owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE path_to = '/prog/python/tg-bot' AND owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT parent_project, name, tags FROM projects WHERE path_to = '/prog/python/tg-bot' AND owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text REFERENCES users (name) ON DELETE CASCADE,
    parent_project text           NOT NULL,
    name           file_name_text NOT NULL,
    path           text REFERENCES projects (path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name)
VALUES ('andrey123', 'meshloader', '/src/AneuMeshLoader.cpp'),
       ('andrey123', 'meshloader', '/src/FiniteElement.cpp'),
       ('andrey123', 'meshloader', '/src/Main.cpp'),
       ('andrey123', 'meshloader', '/src/MeshLoader.h'),
       ('andrey123', 'meshloader', '/src/AneuMeshLoader.h'),
       ('andrey123', 'meshloader', '/src/FiniteElement.h'),
       ('andrey123', 'meshloader', '/src/MeshLoader.cpp'),
       ('andrey123', 'meshloader', '/src/Node.h');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, path)
VALUES ('andrey123', 'meshloader', 'AneuMeshLoader.cpp', '/src/AneuMeshLoader.cpp'),
       ('andrey123', 'meshloader', 'FiniteElement.cpp', '/src/FiniteElement.cpp'),
       ('andrey123', 'meshloader', 'Main.cpp', '/src/Main.cpp'),
       ('andrey123', 'meshloader', 'MeshLoader.h', '/src/MeshLoader.h'),
       ('andrey123', 'meshloader', 'AneuMeshLoader.h', '/src/AneuMeshLoader.h'),
       ('andrey123', 'meshloader', 'FiniteElement.h', '/src/FiniteElement.h'),
       ('andrey123', 'meshloader', 'MeshLoader.cpp', '/src/MeshLoader.cpp'),
       ('andrey123', 'meshloader', 'Node.h', '/src/Node.h');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, path)
VALUES ('andrey123', 'meshloader', 'AneuMeshLoader.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'FiniteElement.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'Main.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'MeshLoader.h', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'AneuMeshLoader.h', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'FiniteElement.h', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'MeshLoader.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'Node.h', '/prog/cpp/meshloader');
;-- -. . -..- - / . -. - .-. -.--
SELECT parent_project, name, tags
FROM projects
WHERE path_to = '/prog/cpp/meshloader'
  AND owner = 'andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM files WHERE owner='andrey123' AND path='/prog/cpp/meshloader';
;-- -. . -..- - / . -. - .-. -.--
SELECT id,name FROM files WHERE owner='andrey123' AND path='/prog/cpp/meshloader';
;-- -. . -..- - / . -. - .-. -.--
SELECT id, name, split_part(name, '.', 2)
FROM files
WHERE owner = 'andrey123'
  AND path = '/prog/cpp/meshloader';
;-- -. . -..- - / . -. - .-. -.--
SELECT id, name, split_part(name, '.', 2) AS extension
FROM files
WHERE owner = 'andrey123'
  AND path = '/prog/cpp/meshloader';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects JOIN projects ON name=parent_project;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects JOIN projects p ON p.name=parent_project;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project WHERE p2.path_to='/prog/cpp/meshloader';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project WHERE p2.path_to='/prog/cpp/';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project WHERE p2.path_to='/prog/cpp';
;-- -. . -..- - / . -. - .-. -.--
SELECT p1.* FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project WHERE p2.path_to='/prog/cpp';
;-- -. . -..- - / . -. - .-. -.--
SELECT p1.name, p1.tags FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project WHERE p2.path_to='/prog/cpp';
;-- -. . -..- - / . -. - .-. -.--
SELECT p1.name, p1.tags FROM projects p1 JOIN projects p2 ON p2.name=p1.parent_project WHERE p2.path_to='/prog/cpp' AND p2.owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, name, tags, path_to)
VALUES ('andrey123', 'prog', '{"code"}', '/prog'),
       ('andrey123', 'kikir', '{"math", "cpp"}', '/kikir');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags, path_to)
VALUES ('andrey123', 'prog', 'cpp', '{"code", "cpp"}', '/prog/cpp'),
       ('andrey123', 'prog', 'python', '{"code", "py"}', '/prog/python');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags, path_to)
VALUES ('andrey123', 'cpp', 'meshloader', '{"code", "cpp"}', '/prog/cpp/meshloader'),
       ('andrey123', 'cpp', 'stl', '{"code", "cpp"}', '/prog/cpp/stl'),
       ('andrey123', 'python', 'flask-app', '{"code", "py"}', '/prog/python/flask-app'),
       ('andrey123', 'python', 'tg-bot', '{"code", "py"}', '/prog/python/tg-bot');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, path)
VALUES ('andrey123', 'meshloader', 'AneuMeshLoader.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'FiniteElement.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'Main.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'MeshLoader.h', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'AneuMeshLoader.h', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'FiniteElement.h', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'MeshLoader.cpp', '/prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'Node.h', '/prog/cpp/meshloader'),
       ('andrey123', 'cpp', 'clang-format.txt', '/prog/cpp');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO users(name, password, role)
VALUES ('andrey123', '123456789', 'admin'::user_role);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, name, tags, path_to)
VALUES ('andrey123', 'prog', '{"code"}', 'prog'),
       ('andrey123', 'kikir', '{"math", "cpp"}', '/kikir');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags, path_to)
VALUES ('andrey123', 'prog', 'cpp', '{"code", "cpp"}', 'prog/cpp'),
       ('andrey123', 'prog', 'python', '{"code", "py"}', 'prog/python');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO projects(owner, parent_project, name, tags, path_to)
VALUES ('andrey123', 'cpp', 'meshloader', '{"code", "cpp"}', 'prog/cpp/meshloader'),
       ('andrey123', 'cpp', 'stl', '{"code", "cpp"}', 'prog/cpp/stl'),
       ('andrey123', 'python', 'flask-app', '{"code", "py"}', 'prog/python/flask-app'),
       ('andrey123', 'python', 'tg-bot', '{"code", "py"}', 'prog/python/tg-bot');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, path)
VALUES ('andrey123', 'meshloader', 'AneuMeshLoader.cpp', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'FiniteElement.cpp', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'Main.cpp', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'MeshLoader.h', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'AneuMeshLoader.h', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'FiniteElement.h', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'MeshLoader.cpp', 'prog/cpp/meshloader'),
       ('andrey123', 'meshloader', 'Node.h', 'prog/cpp/meshloader'),
       ('andrey123', 'cpp', 'clang-format.txt', 'prog/cpp');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO files(owner, parent_project, name, path)
VALUES 
       ('andrey123', 'prog', 'README.md', 'prog');
;-- -. . -..- - / . -. - .-. -.--
CREATE TYPE project_tag AS ENUM ('code', 'math', 'cpp', 'py');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           project_tag[],
    path_to        text UNIQUE,
    UNIQUE (owner, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           VARCHAR(20)[],
    path_to        text UNIQUE,
    UNIQUE (owner, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text UNIQUE,
    UNIQUE (owner, name),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andRey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%es%';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%e%';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%e%' AND position('C++', tags)>0;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%e%' AND position('C+++' in tags)>0;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%e%' AND position('C++' in tags)>0;
;-- -. . -..- - / . -. - .-. -.--
SELECT split_part('555,C++,Support,Pythik');
;-- -. . -..- - / . -. - .-. -.--
SELECT split_part('555,C++,Support,Pythik', ',');
;-- -. . -..- - / . -. - .-. -.--
SELECT split_part('555,C++,Support,Pythik', ',', 0);
;-- -. . -..- - / . -. - .-. -.--
SELECT split_part('555,C++,Support,Pythik', ',', 1);
;-- -. . -..- - / . -. - .-. -.--
SELECT split_part('555,C++,Support,Pythik', ',', 2);
;-- -. . -..- - / . -. - .-. -.--
SELECT (char_length('555,C++,Support,Pythik') - char_length(REPLACE('555,C++,Support,Pythik', ',', ''))) / char_length('substring');
;-- -. . -..- - / . -. - .-. -.--
SELECT (char_length('555,C++,Support,Pythik') - char_length(REPLACE('555,C++,Support,Pythik', ',', ''))) / char_length('555,C++,Support,Pythik');
;-- -. . -..- - / . -. - .-. -.--
SELECT (char_length('555,C++,Support,Pythik') - char_length(REPLACE('555,C++,Support,Pythik', ',', ' '))) / char_length('555,C++,Support,Pythik');
;-- -. . -..- - / . -. - .-. -.--
SELECT (char_length('555,C++,Support,Pythik') - char_length(REPLACE('555,C++,Support,Pythik', ',', '')));
;-- -. . -..- - / . -. - .-. -.--
SELECT *, (char_length(tags) - char_length(replace(tags, ',', ''))) FROM projects;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, (char_length(tags) - char_length(replace(tags, ',', ''))+1) FROM projects;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, (char_length(tags) - char_length(replace(tags, ',', ''))+1) AS n_tags FROM projects;
;-- -. . -..- - / . -. - .-. -.--
SELECT (char_length(tags) - char_length(replace(tags, ',', ''))+1) AS n_tags FROM projects;
;-- -. . -..- - / . -. - .-. -.--
SELECT *, (char_length(tags) - char_length(replace(tags, ',', '')) + 1) AS n_tags
FROM projects
WHERE owner ILIKE 'andrey123'
  AND name ILIKE '%e%';
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM projects
WHERE owner ILIKE 'andrey123'
  AND name ILIKE '%e%'
  AND tags ILIKE '%';
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM projects
WHERE owner ILIKE 'andrey123'
  AND name ILIKE '%e%'
  AND tags ILIKE '%'
  LIMIT 1;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM projects
WHERE owner ILIKE 'andrey123'
  AND name ILIKE '%e%'
  AND tags ILIKE '%'
  LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM users
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM users
WHERE name ILIKE '%dr'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM users
WHERE name ILIKE '%dr%'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM users
WHERE name ILIKE '%dr%'
AND role='admin'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM users
WHERE name ILIKE '%dr%'
AND role='default'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
, name, tags, path_to FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%e%' AND tags ILIKE '%' LIMIT 10;;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM files;
;-- -. . -..- - / . -. - .-. -.--
SELECT role FROM users WHERE name='andrey123';
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text UNIQUE,
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        VARCHAR(10),
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        project_name_text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text UNIQUE,
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text,
    UNIQUE (owner, name, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text UNIQUE ,
    UNIQUE (owner, name, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text UNIQUE,
    UNIQUE (owner, name),
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (parent_project) REFERENCES projects (name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    path           text REFERENCES projects (path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
  name class_name_text PRIMARY KEY,
  children class_name_text[] REFERENCES classification(name)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name),
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class_name   class_name_text REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    class     class_name_text PRIMARY KEY,
    children class_name_text[]
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class_name   class_name_text REFERENCES classification (class) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    class_name     class_name_text PRIMARY KEY,
    children class_name_text[]
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class_name   class_name_text REFERENCES classification (class_name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    "name"     class_name_text PRIMARY KEY,
    children class_name_text[]
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class_name   class_name_text REFERENCES classification ("name") ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    class_name class_name_text,
    FOREIGN KEY (class_name) REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    FOREIGN KEY (class_name) REFERENCES classification (name) ON DELETE CASCADE,
    class_name class_name_text,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    class_name class_name_text,
    UNIQUE (owner, path_to, class_name),
    FOREIGN KEY (class_name) REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    class_name class_name_text PRIMARY KEY ,
    UNIQUE (owner, path_to),
    FOREIGN KEY (class_name) REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    class_name class_name_text,
    UNIQUE (owner, path_to),
--     FOREIGN KEY (class_name) REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    name     class_name_text,
    children class_name_text[]
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    class_name class_name_text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (class_name) REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    name     class_name_text,
    children class_name_text[],
    PRIMARY KEY (name)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner      user_data_text,
    path_to    text,
    class class_name_text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (class) REFERENCES classification (name) ON DELETE CASCADE,
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN class_name_text VARCHAR(100) NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    name     class_name_text PRIMARY KEY,
    children class_name_text[]
);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_valid_token("user" user_data_text, token_ uuid)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT *
              FROM tokens
              WHERE username = "user"
                AND token = token_)
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, parent_name FROM classification;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT parent_name, name
                            FROM classification
                            where name = 'cat1'
                            UNION
                            SELECT tp.parent_name, tp.name
                            FROM classification tp
                                     JOIN children c ON tp.parent_name = c.name)
SELECT *
FROM classification;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT parent_name, name
                            FROM classification
                            where name = 'cat2'
                            UNION
                            SELECT tp.parent_name, tp.name
                            FROM classification tp
                                     JOIN children c ON tp.parent_name = c.name)
SELECT *
FROM children;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT parent_name, name
                            FROM classification
                            where name = 'cat3'
                            UNION
                            SELECT tp.parent_name, tp.name
                            FROM classification tp
                                     JOIN children c ON tp.parent_name = c.name)
SELECT *
FROM children;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT parent_name, name
                            FROM classification
                            where name = 'cat1'
                            UNION
                            SELECT tp.parent_name, tp.name
                            FROM classification tp
                                     JOIN children c ON tp.parent_name = c.name)
SELECT *
FROM children;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT name, parent_name
                            FROM classification
                            where name = 'cat1'
                            UNION
                            SELECT tp.name, tp.parent_name
                            FROM classification tp
                                     JOIN children c ON tp.parent_name = c.name)
SELECT *
FROM children;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_valid_token("user" user_data_text, token_ uuid)
    RETURNS TABLE (
                    name class_name_text,
                    parent class_name_text
                  )
    LANGUAGE plpgsql
AS
$$
BEGIN
    WITH RECURSIVE children AS (SELECT name, parent_name
                                FROM classification
                                WHERE name = 'cat1'
                                UNION
                                SELECT tp.name, tp.parent_name
                                FROM classification tp
                                         JOIN children c ON tp.parent_name = c.name)
    SELECT *
    FROM children;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_valid_token("user" user_data_text, token_ uuid)
    RETURNS TABLE (
                    name_ class_name_text,
                    parent class_name_text
                  )
    LANGUAGE plpgsql
AS
$$
BEGIN
    WITH RECURSIVE children AS (SELECT name, parent_name
                                FROM classification
                                WHERE name = 'cat1'
                                UNION
                                SELECT tp.name, tp.parent_name
                                FROM classification tp
                                         JOIN children c ON tp.parent_name = c.name)
    SELECT *
    FROM children;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT name, parent_name
                                FROM classification
                                WHERE name = 'cat1'
                                UNION
                                SELECT tp.name, tp.parent_name
                                FROM classification tp
                                         JOIN children c ON tp.parent_name = c.name)
    SELECT name
    FROM children WHERE parent_name IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT name, parent_name
                                FROM classification
                                WHERE name = 'cat2'
                                UNION
                                SELECT tp.name, tp.parent_name
                                FROM classification tp
                                         JOIN children c ON tp.parent_name = c.name)
    SELECT name
    FROM children WHERE parent_name IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT name, parent_name
                                FROM classification
                                WHERE name = 'root'
                                UNION
                                SELECT tp.name, tp.parent_name
                                FROM classification tp
                                         JOIN children c ON tp.parent_name = c.name)
    SELECT name
    FROM children WHERE parent_name IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
SELECT name FROM classification WHERE parent_name=class_name;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION class_children(class_name class_name_text)
    RETURNS TABLE
            (
                name_ class_name_text
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    SELECT name FROM classification WHERE parent_name=class_name;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT class_children('root');
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION class_children(class_name class_name_text)
    RETURNS TABLE
            (
                name_ class_name_text
            )
AS
$$
BEGIN
   SELECT name FROM classification WHERE parent_name=class_name;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION class_children(class_name class_name_text)
    RETURNS TABLE
            (
                name_ class_name_text
            )
    LANGUAGE sql
AS
$$
BEGIN
   SELECT name FROM classification WHERE parent_name=class_name;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION class_children(class_name class_name_text)
    RETURNS TABLE
            (
                name_ class_name_text
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
   SELECT name FROM classification WHERE parent_name=class_name;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
class_children('root');
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM class_children('root');
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION class_children;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION class_children(class_name class_name_text)
    RETURNS TABLE
            (
                name_ class_name_text
            )
    LANGUAGE sql
AS
$$
SELECT name
FROM classification
WHERE parent_name = class_name;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT name
FROM classification
WHERE parent_name = class_name
    ORDER BY name;
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM class_children('root');
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name) ON DELETE CASCADE,
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name) ON DELETE CASCADE,
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION user_token_expired;
;-- -. . -..- - / . -. - .-. -.--
SELECT user_token_expired('andrey123');
;-- -. . -..- - / . -. - .-. -.--
SELECT user_valid_token('andrey', '37745dac-53da-4103-b019-fc91c1796f8a');
;-- -. . -..- - / . -. - .-. -.--
SELECT owner, name, tags, path_to
FROM projects
WHERE owner ILIKE 'andrey123'
  AND name ILIKE '%e%'
  AND tags ILIKE '%'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, role
FROM users
WHERE name ILIKE '%dr%'
  AND role = 'default'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT owner, parent_project, name, path
FROM files
WHERE owner ILIKE 'asdasd'
  AND parent_project ILIKE 'asdasd'
  AND name ILIKE 'asdasd'
  AND path ILIKE 'asdasd';
;-- -. . -..- - / . -. - .-. -.--
SELECT role
FROM users
WHERE name = 'andrey123';
;-- -. . -..- - / . -. - .-. -.--
UPDATE users
SET role = 'admin'::user_role
WHERE name = 'pukinzandr';
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE children AS (SELECT name, parent_name
                            FROM classification
                            WHERE name = 'root'
                            UNION
                            SELECT tp.name, tp.parent_name
                            FROM classification tp
                                     JOIN children c ON tp.parent_name = c.name)
SELECT name
FROM children
WHERE parent_name IS NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
n(name, parent_name)
VALUES ('class-1', 'root'),
       ('class-2', 'root'),
       ('class-1', 'root');;
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO classification(name, parent_name)
VALUES ('class-1', 'root'),
       ('class-2', 'root'),
       ('class-1', 'root');
;-- -. . -..- - / . -. - .-. -.--
SELECT name, tags FROM projects WHERE owner='andrey123' AND parent_project IS NULL;
;-- -. . -..- - / . -. - .-. -.--
SELECT name, tags, path_to FROM projects WHERE owner='andrey123' AND parent_project IS NULL;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM project_classes WHERE owner='andrey123' AND path_to='123';
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM project_classes WHERE owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT class FROM project_classes WHERE owner='andrey123';
;-- -. . -..- - / . -. - .-. -.--
SELECT owner, name, tags, path_to FROM projects WHERE owner ILIKE 'andrey123' AND name ILIKE '%' AND tags ILIKE '%' LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT owner, name, tags, path_to
FROM projects
JOIN project_classes pc on projects.owner = pc.owner and projects.path_to = pc.path_to
WHERE owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT p.owner, name, tags, p.path_to
FROM projects p
JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT p.owner, name, tags, p.path_to, class
FROM projects p
JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT p.owner, name, tags, p.path_to, class
FROM projects p
JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
AND (class='class-2' OR class='class-3')
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT p.owner, name, tags, p.path_to
FROM projects p
JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
AND (class='class-2' OR class='class-3')
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT p.owner, name, tags, p.path_to
FROM projects p
JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
AND (class='class-2' OR class='class-3')
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT p.owner, name, tags, p.path_to
FROM projects p
         JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
--   AND (class = 'class-2' OR class = 'class-3')
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT p.owner, name, tags, p.path_to
FROM projects p
         JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE p.owner ILIKE 'andrey123'
  AND name ILIKE '%'
  AND tags ILIKE '%'
  AND (class = 'class-2' OR class = 'class-3')
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
SELECT DISTINCT p.owner, name, tags, p.path_to, class
FROM projects p
         JOIN project_classes pc on p.owner = pc.owner and p.path_to = pc.path_to
WHERE class = 'class-2'
   OR class = 'class-3'
LIMIT 10;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name) ON DELETE CASCADE,
    UNIQUE (owner, path_to, class),
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO classification(name, parent_name)
VALUES ('class-1', 'root'),
       ('class-2', 'root'),
       ('class-3', 'root');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO classification(name, parent_name)
VALUES ('class-1-1', 'class-1'),
       ('class-1-2', 'class-1'),
       ('class-2-1', 'class-2');
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO classification(name, parent_name)
VALUES ('class-2-1-1', 'class-2-1');
;-- -. . -..- - / . -. - .-. -.--
drop type if exists user_role cascade;
;-- -. . -..- - / . -. - .-. -.--
drop type if exists project_tag cascade;
;-- -. . -..- - / . -. - .-. -.--
drop domain if exists user_data_text cascade;
;-- -. . -..- - / . -. - .-. -.--
drop domain if exists project_name_text cascade;
;-- -. . -..- - / . -. - .-. -.--
drop domain if exists file_name_text cascade;
;-- -. . -..- - / . -. - .-. -.--
drop domain if exists class_name_text cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TYPE user_role AS ENUM ('default', 'admin');
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN user_data_text VARCHAR(30) NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN project_name_text VARCHAR(100);
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN class_name_text VARCHAR(100);
;-- -. . -..- - / . -. - .-. -.--
CREATE DOMAIN file_name_text VARCHAR(255);
;-- -. . -..- - / . -. - .-. -.--
drop table if exists projects cascade;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists users cascade;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists files cascade;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists tokens cascade;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists project_classes cascade;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists classification cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS users
(
    name     user_data_text PRIMARY KEY,
    password user_data_text NOT NULL,
    role     user_role      NOT NULL DEFAULT 'default'
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS classification
(
    name        class_name_text PRIMARY KEY,
    parent_name class_name_text REFERENCES classification (name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text,
    UNIQUE (owner, path_to)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name) ON DELETE SET NULL,
    UNIQUE (owner, path_to, class),
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    path           text,
    FOREIGN KEY (owner, path) REFERENCES projects (owner, path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS tokens
(
    username user_data_text REFERENCES users (name) ON DELETE CASCADE,
    token    uuid,
    expire   timestamp
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO classification(name)
VALUES ('root');
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION IF EXISTS user_token_expired;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_token_expired("user" user_data_text)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT expire
              FROM tokens
              WHERE expire > CURRENT_TIMESTAMP + INTERVAL '3 HOURS')
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION IF EXISTS user_valid_token;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION user_valid_token("user" user_data_text, token_ uuid)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXISTS(SELECT *
              FROM tokens
              WHERE username = "user"
                AND token = token_)
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
DROP FUNCTION IF EXISTS class_children;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION class_children(class_name class_name_text)
    RETURNS TABLE
            (
                name_ class_name_text
            )
    LANGUAGE sql
AS
$$
SELECT name
FROM classification
WHERE parent_name = class_name
ORDER BY name;
$$;