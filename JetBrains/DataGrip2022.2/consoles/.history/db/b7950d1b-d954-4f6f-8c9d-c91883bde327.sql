drop table if exists projects cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    name           project_name_text,
    tags           text,
    path_to        text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (parent_project) REFERENCES projects(name) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS projects
(
    owner          user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    name           project_name_text,
    path_to        text,
    tags           text,
    parent_owner   user_data_text NOT NULL REFERENCES users (name) ON DELETE CASCADE,
    parent_project project_name_text,
    UNIQUE (owner, path_to),
    FOREIGN KEY (parent_owner, parent_project) REFERENCES projects (owner, name) ON DELETE CASCADE
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
CREATE FUNCTION remove_children() RETURNS trigger AS
$$
BEGIN
    DELETE
    FROM projects
    WHERE parent_project = OLD.name
      AND owner = OLD.owner
      AND (old.path_to || '/' || name) = path_to;
END;
$$ LANGUAGE plpgsql;
;-- -. . -..- - / . -. - .-. -.--
CREATE TRIGGER cascade_deleting
    AFTER DELETE
    ON projects
    FOR EACH ROW
EXECUTE PROCEDURE remove_children();
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION remove_children() RETURNS trigger AS
$$
BEGIN
    DELETE
    FROM projects
    WHERE parent_project = OLD.name
      AND owner = OLD.owner
      AND (old.path_to || '/' || name) = path_to;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE TRIGGER cascade_deleting
    AFTER DELETE
    ON projects
    FOR EACH ROW
EXECUTE PROCEDURE remove_children();
;-- -. . -..- - / . -. - .-. -.--
drop table if exists files cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS files
(
    id             SERIAL PRIMARY KEY,
    owner          user_data_text,
    parent_project project_name_text NOT NULL,
    name           file_name_text    NOT NULL,
    path           text,
    UNIQUE (owner, path, name),
    FOREIGN KEY (owner, path) REFERENCES projects (owner, path_to) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
drop table if exists project_classes cascade;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS project_classes
(
    owner   user_data_text,
    path_to text,
    class   class_name_text REFERENCES classification (name) ON DELETE SET NULL,
    UNIQUE (owner, path_to),
    FOREIGN KEY (owner, path_to) REFERENCES projects (owner, path_to) ON DELETE CASCADE
);