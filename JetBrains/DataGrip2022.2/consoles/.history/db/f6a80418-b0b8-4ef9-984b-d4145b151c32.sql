CREATE TABLE branches(
    id INT PRIMARY KEY,
    parent_id INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE branches(
    id SERIAL PRIMARY KEY,
    parent_id INT
);
;-- -. . -..- - / . -. - .-. -.--
INSERT INTO branches(parent_id) VALUES (123);
;-- -. . -..- - / . -. - .-. -.--
SELECT MAX(id) from branches;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS houses(
    id SERIAL PRIMARY KEY,
    branch_id INT,
    FOREIGN KEY (branch_id)  REFERENCES branches (id)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS houses(
    id SERIAL PRIMARY KEY,
    branch_id INT,
    squirrel_id INT,
    FOREIGN KEY (branch_id)  REFERENCES branches (id),
    FOREIGN KEY (squirrel_id)  REFERENCES squirrel (id)
);
;-- -. . -..- - / . -. - .-. -.--
CREATE FUNCTION check() RETURNS trigger AS $check$
    BEGIN
        IF NEW.parent_id IS NOT NULL AND IS NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Parent with id % not exist', NEW.parent_id;
        END IF;
        RETURN NEW;
    END;
$check$ LANGUAGE plpgsql;
;-- -. . -..- - / . -. - .-. -.--
CREATE FUNCTION check() RETURNS trigger AS $$
    BEGIN
        IF NEW.parent_id IS NOT NULL AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Parent with id % not exist', NEW.parent_id;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION check() RETURNS trigger AS $asd$
    BEGIN
        IF NEW.parent_id IS NOT NULL AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Parent with id % not exist', NEW.parent_id;
        END IF;
        RETURN NEW;
    END;
$asd$ LANGUAGE plpgsql;
;-- -. . -..- - / . -. - .-. -.--
CREATE FUNCTION trigger_function()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.parent_id IS NOT NULL AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Parent with id % not exist', NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION branch_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.parent_id IS NOT NULL AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Parent with id % not exist', NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE TRIGGER branch_check BEFORE INSERT OR UPDATE ON branches
    FOR EACH ROW EXECUTE PROCEDURE branch_check();
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION branch_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.parent_id <> 0 AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Parent with id % not exist', NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION branch_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.parent_id <> 0 AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Ветка с ID % не существует', NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION branch_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.parent_id <> 0 AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Ветка с ID % не существует\n', NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION branch_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.parent_id <> 0 AND NEW.parent_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Ветка с ID % не существует\\n', NEW.parent_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION house_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.branch_id = 0 OR NEW.branch_id NOT IN (SELECT id FROM branches) THEN
            RAISE EXCEPTION 'Нельзя поставить домик. Ветка с ID % не существует либо является стволом', NEW.branch_id;
    END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE TRIGGER house_check BEFORE INSERT OR UPDATE ON houses
    FOR EACH ROW EXECUTE PROCEDURE house_check();
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION house_check()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
   IF NEW.branch_id NOT IN (SELECT id FROM branches) THEN
        RAISE EXCEPTION 'Нельзя поставить домик. Ветка с ID % не существует.', NEW.branch_id;
    END IF;
   IF (SELECT parent_id FROM branches WHERE id = NEW.branch_id)  = 0 THEN
       RAISE EXCEPTION 'Нельзя поставить домик на ствол (ID %).', NEW.branch_id;
   END IF;
    RETURN NEW;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM branches WHERE id=5;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM branches WHERE id=3;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM branches WHERE id=1;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM branches WHERE id=0;
;-- -. . -..- - / . -. - .-. -.--
WITH R AS (SELECT 1 AS n)
SELECT n + 1 FROM R;
;-- -. . -..- - / . -. - .-. -.--
WITH R AS (SELECT 1 AS n)
SELECT n + 2 FROM R;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT parent_id FROM branches WHERE id=5
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT parent_id FROM branches WHERE id=3
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT 0 AS N
    UNION ALL
    SELECT parent_id FROM branches WHERE id=3
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT 0 AS N
    UNION ALL
    SELECT parent_id FROM branches WHERE id=7
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT 0 AS N
    UNION ALL
    SELECT parent_id FROM branches WHERE id=parent_id
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 3
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE parent.p = branches.id
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 3
    UNION ALL
    SELECT parent_id FROM branches WHERE branches.parent_id = branches.id
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM branches WHERE branches.parent_id = branches.id
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT parent_id AS p FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE id=p
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT parent_id AS next_step FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE id=next_step
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT id AS next_step FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE id=next_step
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT id AS next_step FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE id=next_step AND id <> 0
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT id AS next_step FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE id=next_step AND next_step<>0
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
WITH RECURSIVE parent AS(
    SELECT id AS next_step FROM branches WHERE id = 7
    UNION ALL
    SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id<>0
)
SELECT * FROM parent;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION route_to_root(INT)
   RETURNS TABLE(next_step INT)
   LANGUAGE SQL
AS $$
BEGIN
    WITH RECURSIVE parent AS(
        SELECT id AS next_step FROM branches WHERE id = 7
        UNION ALL
        SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id <> 0
    )
    SELECT * FROM parent;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION route_to_root(INT)
   RETURNS TABLE(next_step INT)
   LANGUAGE SQL
AS $$
    WITH RECURSIVE parent AS(
        SELECT id AS next_step FROM branches WHERE id = 7
        UNION ALL
        SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id <> 0
    )
    SELECT * FROM parent;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT route_to_root(66);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION route_to_root(INT)
   RETURNS TABLE(next_step INT)
   LANGUAGE SQL
AS $$
    WITH RECURSIVE parent AS(
        SELECT id AS next_step FROM branches WHERE id = $1
        UNION ALL
        SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id <> 0
    )
    SELECT * FROM parent;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT route_to_root(6);
;-- -. . -..- - / . -. - .-. -.--
SELECT route_to_root(7);
;-- -. . -..- - / . -. - .-. -.--
SELECT route_to_root(124);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION route_to_root(INT)
   RETURNS TABLE(next_step INT)
   LANGUAGE SQL
AS $$
    WITH RECURSIVE parent AS(
        SELECT id AS next_step FROM branches WHERE id = (SELECT branch_id FROM houses WHERE houses.id=$1)
        UNION ALL
        SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id <> 0
    )
    SELECT * FROM parent;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS branches(
    id SERIAL PRIMARY KEY,
    parent_id INT
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS houses(
    id SERIAL PRIMARY KEY,
    branch_id INT,
    squirrel_id INT,
    FOREIGN KEY (branch_id)  REFERENCES branches (id) on delete cascade,
    FOREIGN KEY (squirrel_id)  REFERENCES squirrel (id) on delete cascade
);
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel_id FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel_id, MAX((squirrel_id)) FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel_id, COUNT(squirrel_id) FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel_id, COUNT(squirrel_id) FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id
LIMIT 1;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel_id, COUNT(squirrel_id) AS house_count FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel, COUNT(squirrel_id) AS house_count FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
SELECT squirrel_id AS squirrel, COUNT(squirrel_id) AS house_count FROM squirrel
JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION on_branch_delete()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM branches WHERE parent_id=OLD.id;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE TRIGGER on_branch_delete AFTER DELETE ON branches
    FOR EACH ROW EXECUTE PROCEDURE on_branch_delete();
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION on_branch_delete()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM branches WHERE parent_id=OLD.id;
    RETURN OLD;
END;
$$;
;-- -. . -..- - / . -. - .-. -.--
DROP TRIGGER on_branch_delete;
;-- -. . -..- - / . -. - .-. -.--
DROP TRIGGER on_branch_delete ON branches;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS branches(
    id SERIAL PRIMARY KEY,
    parent_id INT DEFAULT 0,
    FOREIGN KEY(parent_id) REFERENCES branches(id) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION route_to_root(INT)
   RETURNS TABLE(next_step INT)
   LANGUAGE SQL
AS $$
    WITH RECURSIVE parent AS(
        SELECT id AS next_step FROM branches WHERE id = (SELECT branch_id FROM houses WHERE houses.id=$1)
        UNION ALL
        SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id IS NOT NULL
    )
    SELECT * FROM parent;
$$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION route_to_root(INT)
   RETURNS TABLE(next_step INT)
   LANGUAGE SQL
AS $$
    WITH RECURSIVE parent AS(
        SELECT id AS next_step FROM branches WHERE id = (SELECT branch_id FROM houses WHERE houses.id=$1)
        UNION ALL
        SELECT parent_id FROM parent, branches WHERE id=next_step AND parent_id NOT NULL
    )
    SELECT * FROM parent;
$$;
;-- -. . -..- - / . -. - .-. -.--
SELECT route_to_root(3);
;-- -. . -..- - / . -. - .-. -.--
SELECT route_to_root(4);
;-- -. . -..- - / . -. - .-. -.--
DROP TRIGGER house_check FROM houses;
;-- -. . -..- - / . -. - .-. -.--
DROP TRIGGER house_check ON houses;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION detect_cycle()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$func$
BEGIN
  IF EXISTS (
      WITH RECURSIVE list_referrers(referrer) AS (
         SELECT r.parent_id
         FROM branches AS r
         WHERE r.id = NEW.parent_id
       UNION ALL
         SELECT r.id
         FROM branches AS r,  list_referrers as lr
         WHERE r.id = lr.referrer
       ) SELECT * FROM list_referrers WHERE list_referrers.referrer = NEW.id LIMIT 1
  )
  THEN
    RAISE EXCEPTION 'Loop detected';
  ELSE
    RETURN NEW;
  END IF;
END
$func$;
;-- -. . -..- - / . -. - .-. -.--
SELECT detect_cycle();
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS branches(
    id SERIAL PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY(parent_id) REFERENCES branches(id) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION detect_cycle()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$func$
BEGIN
  IF EXISTS (
      WITH RECURSIVE list_referrers(referrer) AS (
         SELECT r.parent_id
         FROM branches AS r
         WHERE r.id = NEW.parent_id
       UNION ALL
         SELECT r.id
         FROM branches AS r,  list_referrers as lr
         WHERE r.id = lr.referrer
       ) SELECT * FROM list_referrers WHERE list_referrers.referrer = NEW.parent_id LIMIT 1
  )
  THEN
    RAISE EXCEPTION 'Loop detected';
  ELSE
    RETURN NEW;
  END IF;
END
$func$;
;-- -. . -..- - / . -. - .-. -.--
CREATE TRIGGER detect_cycle BEFORE INSERT OR UPDATE ON branches
    FOR EACH ROW EXECUTE PROCEDURE detect_cycle();
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION detect_cycle()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$func$
BEGIN
  IF EXISTS (
      WITH RECURSIVE list_referrers(referrer) AS (
         SELECT r.parent_id
         FROM branches AS r
         WHERE r.id = NEW.parent_id
       UNION ALL
         SELECT r.id
         FROM branches AS r, list_referrers as lr
         WHERE r.id = lr.referrer
       ) SELECT * FROM list_referrers WHERE list_referrers.referrer = NEW.parent_id LIMIT 1
  )
  THEN
    RAISE EXCEPTION 'Loop detected';
  ELSE
    RETURN NEW;
  END IF;
END
$func$;
;-- -. . -..- - / . -. - .-. -.--
CREATE OR REPLACE FUNCTION detect_cycle()
  RETURNS TRIGGER
  LANGUAGE plpgsql AS
$func$
BEGIN
  IF EXISTS (
      WITH RECURSIVE list_referrers(referrer) AS (
         SELECT r.id
         FROM branches AS r
         WHERE r.id = NEW.parent_id
       UNION ALL
         SELECT r.parent_id
         FROM branches AS r,  list_referrers as lr
         WHERE r.id = lr.referrer
       ) SELECT * FROM list_referrers WHERE list_referrers.referrer = NEW.id LIMIT 1
  )
  THEN
    RAISE EXCEPTION 'Loop detected';
  ELSE
    RETURN NEW;
  END IF;
END
$func$;
;-- -. . -..- - / . -. - .-. -.--
DROP TRIGGER IF EXISTS detect_cycle ON branches;
;-- -. . -..- - / . -. - .-. -.--
CREATE TRIGGER detect_cycle AFTER INSERT OR UPDATE ON branches
    FOR EACH ROW EXECUTE PROCEDURE detect_cycle();
;-- -. . -..- - / . -. - .-. -.--
drop table if exists houses;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists branches;
;-- -. . -..- - / . -. - .-. -.--
drop table if exists squirrel;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS branches(
    id SERIAL PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY(parent_id) REFERENCES branches(id) ON DELETE CASCADE,
    CONSTRAINT check_id_not_parent_id CHECK ((id <> branches.parent_id))
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS squirrel(
    id SERIAL PRIMARY KEY
);
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE IF NOT EXISTS houses(
    id SERIAL PRIMARY KEY,
    branch_id INT,
    squirrel_id INT,
    FOREIGN KEY (branch_id)  REFERENCES branches (id) ON DELETE CASCADE,
    FOREIGN KEY (squirrel_id)  REFERENCES squirrel (id) ON DELETE CASCADE
);
;-- -. . -..- - / . -. - .-. -.--
-- топ самых богатых белок
CREATE VIEW squirrel_top AS
SELECT squirrel_id AS squirrel, COUNT(squirrel_id) AS house_count
FROM squirrel
         JOIN houses h on squirrel.id = h.squirrel_id
GROUP BY squirrel_id;