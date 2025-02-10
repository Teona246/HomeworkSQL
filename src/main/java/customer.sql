CREATE TABLE customer(
"id" BIGINT GENERATED ALWAYS AS IDENTITY,
"name" VARCHAR(200),
"type" VARCHAR(30),
"city" VARCHAR (30)
);
SELECT * FROM CUSTOMER;

INSERT INTO customer ("name", "type", "city")
VALUES ('Алексей', 'NEW', 'Ленинград'),
       ('Олег','Regular','Москва'),
	   ('Игорь', 'VIP', 'Ленинград'),
	   ('Макс', 'New', 'Саратов');

UPDATE customer
SET type = 'New'
WHERE id = 1;

UPDATE customer
SET name = 'Сергей'
WHERE id = 3;

UPDATE customer
SET city = 'Санкт-Петербург'
WHERE city = 'Ленинград';

DELETE FROM customer
WHERE id = 3;

INSERT INTO customer ("name", "type", "city")
VALUES ('Николай', 'NEW', 'Санкт-Петергбург');

UPDATE customer
SET type = 'New'
WHERE id = 5;

UPDATE customer
SET city = 'Санкт-Петербург'
WHERE id = 5;

SELECT * FROM CUSTOMER
WHERE city = 'Санкт-Петербург'
ORDER BY name;