CREATE TABLE users(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR(50) UNIQUE NOT NULL,
age INT NOT NULL CHECK (age >= 18),
email VARCHAR(50) UNIQUE NOT NULL,
login VARCHAR(16) UNIQUE NOT NULL,
password VARCHAR(16) NOT NULL,
date_register TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT * FROM users;
INSERT INTO users(name, age, email, login, password)
VALUES('Алексей', 27, 'alex@yandex.ru', 'alex', 'qwer1234'),
      ('Александр', 30, 'sasha@yandex.ru', 'sasha', 'Sasha321'),
      ('Иван', 32, 'ivan@yandex.ru', 'ivan', 'Ivan213'),
      ('Павел', 29, 'pavel@yandex.ru', 'pavel', 'Pavel1234'),
      ('Анастасия', 33, 'nasty@yandex.ru', 'nasty', 'Nasty1223');

CREATE TABLE account(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
users_id BIGINT NOT NULL,
login VARCHAR(16) UNIQUE NOT NULL,
password VARCHAR(16) NOT NULL,
CONSTRAINT fk_account_user FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE
);
INSERT INTO account (users_id, login, password)
VALUES(1, '1stgamer', 'qqq111'),
      (1, '2stgamer', 'qqq222'),
      (2, 'abrikos1', 'www111'),
      (2, 'abrikos2', 'www222'),
      (3, 'Jimovik', 'Testosterone'),
      (4, 'Java', 'Developer');
SELECT * FROM account;
CREATE TABLE race(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR(20) UNIQUE NOT NULL
);
INSERT INTO race(name)
VALUES('Human'),
      ('Elves'),
      ('Night Elves'),
      ('Orcs'),
      ('Dwarves');
SELECT * FROM race;
CREATE TABLE class(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR(20) UNIQUE NOT NULL
);
INSERT INTO class(name)
VALUES('Knight'),
      ('Warrior'),
      ('Rogue'),
      ('Healer'),
      ('Wizard');
SELECT * FROM class;
CREATE TABLE allowed_race_class(
race_id BIGINT REFERENCES race(id) ON DELETE CASCADE,
class_id BIGINT REFERENCES class(id) ON DELETE CASCADE,
PRIMARY KEY(race_id, class_id)
);
INSERT INTO allowed_race_class(race_id, class_id)
VALUES(1,1),
      (1,2),
      (1,3),
      (2,1),
      (2,3),
      (2,4),
      (2,5),
      (3,2),
      (3,4),
      (3,5),
      (4,2),
      (4,3),
      (4,5),
      (5,2),
      (5,3);

CREATE TABLE character(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
account_id BIGINT NOT NULL,
name VARCHAR(18) UNIQUE NOT NULL,
race_id BIGINT NOT NULL,
class_id BIGINT NOT NULL,
level INT NOT NULL DEFAULT 1 CHECK(level > 0 AND level <= 80),
date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_character_account FOREIGN KEY (account_id) REFERENCES account(id) ON DELETE CASCADE,
CONSTRAINT fk_character_race FOREIGN KEY (race_id) REFERENCES race(id) ON DELETE CASCADE,
CONSTRAINT fk_character_class FOREIGN KEY (class_id) REFERENCES class(id) ON DELETE CASCADE,
CONSTRAINT fk_character_allowed_race_class FOREIGN KEY (race_id,class_id) REFERENCES  allowed_race_class(race_id, class_id) ON DELETE CASCADE
);
INSERT INTO character(account_id, name, race_id, class_id, level)
VALUES(1,'Lunara', 2, 4, 55),
      (1,'Eryndor', 2, 4, 55),
      (5,'Aeloria ', 1, 3, 78),
      (6,'Thalindra', 4, 2, 15),
      (3,'Zephyrix', 3, 5, 23),
      (3,'Stormrider', 3, 2, 67),
      (4,'Dawnwhisper', 2, 4, 48),
      (2,'Kaelith', 5, 2, 37 ),
      (5,'Frostspire', 3, 4, 1);
SELECT * FROM character;
CREATE TABLE type_items (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (100) UNIQUE NOT NULL,
parent_id BIGINT
);

INSERT INTO type_items (name, parent_id)
VALUES ('Weapon', NULL),
       ('Armor', NULL),
       ('Accessory', NULL),
       ('Knife',1),
       ('Bow', 1),
       ('Light armor', 2),
       ('Heavy armor', 2),
       ('Ring', 3),
       ('Earning', 3);

CREATE TABLE items(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR(50) UNIQUE NOT NULL,
type_items_id BIGINT NOT NULL,
CONSTRAINT fk_items_type_items FOREIGN KEY(type_items_id) REFERENCES type_items(id) ON DELETE CASCADE
);

INSERT INTO items(name, type_items_id)
VALUES('Majestic', 6),
      ('Tallum', 7),
      ('Angel Slayer', 4),
      ('Soul Bow', 5),
      ('Black Ore', 8),
      ('Elvens', 9);

CREATE TABLE character_items(
character_id BIGINT,
items_id BIGINT,
PRIMARY KEY(character_id, items_id),
CONSTRAINT fk_character FOREIGN KEY(character_id) REFERENCES character(id),
CONSTRAINT fk_items FOREIGN KEY(items_id) REFERENCES items(id)
);
INSERT INTO character_items(character_id, items_id)
VALUES(1,1),
      (1,3),
      (1,5),
      (2,2),
      (2,4),
      (9,6),
      (5,4),
      (7,3),
      (8,1),
      (9,1);

CREATE FUNCTION validate_email_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email !~ '^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$' THEN
        RAISE EXCEPTION 'Некорректный email: %', NEW.email;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER email_validation
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION validate_email_trigger();
UPDATE users
SET email = 'alex.ru'
WHERE id = 1;

SELECT c.name AS Class, COUNT(ch.id) AS char_count
FROM class c
LEFT JOIN character ch ON c.id = ch.class_id
GROUP BY c.name
ORDER BY char_count DESC;

SELECT
race.name AS "Раса",
COUNT(character.id) AS "Всего персонажей",
ROUND((COUNT(character.id) *100.0 / (SELECT COUNT(*) FROM character)), 2) AS "Количество в %"
FROM race
LEFT JOIN character ON race.id = character.race_id
GROUP BY race.name
ORDER BY "Количество в %" DESC;

CREATE VIEW character_view AS
SELECT
u.name AS "Имя пользователя",
u.login AS "Аккаунт пользователя",
a.login AS "Игровой аккаунт",
c.name AS "Имя персонажа",
r.name AS "Раса",
cl.name AS "Класс",
c.level AS "Уровень"
FROM character c
JOIN race r ON c.race_id = r.id
JOIN class cl ON c.class_id = cl.id
JOIN account a ON c.account_id = a.id
JOIN users u ON a.users_id = u.id
ORDER BY u.id;

SELECT * FROM character_view

SELECT
name, level,
CASE
WHEN level BETWEEN 1 AND 40 THEN 'Новый персонаж'
WHEN level BETWEEN 41 AND 75 THEN 'Персонаж среднего уровня'
WHEN level BETWEEN 76 AND 80 THEN 'Высокоуровневый персонаж'
END AS "Градация уровней"
FROM character
ORDER BY level DESC;

SELECT
u.name AS user_name,
COALESCE(a.login, 'Нет аккаунта') AS "Игровой аккаунт"
FROM
users u
LEFT JOIN
account a ON u.id = a.users_id;

SELECT
i.name AS "Название предмета",
ti2.name AS "Категория",
ti.name AS "Подкатегория"
FROM type_items ti
JOIN type_items ti2 ON ti.parent_id = ti2.id
JOIN items i ON i.type_items_id = ti.id;

SELECT
c.name AS "Имя персонажа",
COALESCE (STRING_AGG(DISTINCT i.name || ' (' || ti.name || ')', ', '), 'Нет предметов') AS "Предметы"
FROM character c
LEFT JOIN character_items ci ON c.id = ci.character_id
LEFT JOIN items i ON ci.items_id = i.id
LEFT JOIN type_items ti ON i.type_items_id = ti.id
GROUP BY c.id, c.name
ORDER BY c.id;

