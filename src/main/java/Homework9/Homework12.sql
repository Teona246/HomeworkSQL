CREATE TABLE book (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (200),
price INT NOT NULL CHECK (price > 1000),
publisher_id BIGINT,

CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(id)
ON DELETE SET NULL
);

INSERT INTO book (name, price, publisher_id)
VALUES ('Одноэтажная Америка','1500','1'),
       ('Гарри Поттер','1600','2'),
	   ('Благословение Небожителей','1700','3'),
	   ('Унесенные ветром','1800','1'),
	   ('Зеленая миля','1900','1'),
	   ('Гарри Поттер и узник Азкабана','2000','2');

-- Проверка на NOT NULL и CHECK

INSERT INTO book (name, price, publisher_id)
VALUES ('Одноэтажная Америка', NULL,'1');

INSERT INTO book (name, price, publisher_id)
VALUES ('Гарри Поттер и узник Азкабана','900','2');

ALTER TABLE book
ADD COLUMN publishing_year INTEGER;

ALTER TABLE book
RENAME COLUMN publishing_year TO "год издания";

ALTER TABLE book
ADD COLUMN pages INTEGER;

ALTER TABLE book
RENAME COLUMN pages TO "кол-во страниц";

ALTER TABLE book
ADD COLUMN book_amount INTEGER;

ALTER TABLE book
RENAME COLUMN book_amount TO "кол-во экземпляров";

-- ОБНОВЛЕНИЕ СРАЗУ ТРЕХ СТОЛБЦОВ

UPDATE book
SET publishing_year = CASE
WHEN id = 1 THEN 2019
WHEN id = 2 THEN 2020
WHEN id = 3 THEN 2021
WHEN id = 4 THEN 2022
WHEN id = 5 THEN 2023
WHEN id = 6 THEN 2024
END,
pages = CASE
WHEN id = 1 THEN 150
WHEN id = 2 THEN 200
WHEN id = 3 THEN 300
WHEN id = 4 THEN 170
WHEN id = 5 THEN 569
WHEN id = 6 THEN 800
END,
book_amount = CASE
WHEN id = 1 THEN 4
WHEN id = 2 THEN 6
WHEN id = 3 THEN 2
WHEN id = 4 THEN 4
WHEN id = 5 THEN 8
WHEN id = 6 THEN 9
END
WHERE id IN (1,2,3,4,5,6);

-- ПОКАЗЫВАЕТ КНИГИ, ГДЕ СТРАНИЦ БОЛЬШЕ СРЕДНЕГО

SELECT *
FROM book
WHERE pages > (SELECT AVG (pages)
FROM book);

-- ПОКАЗЫВАЕТ САМЫЕ СВЕЖИЕ КНИГИ

SELECT *
FROM book
WHERE publishing_year = (SELECT MAX (publishing_year) FROM book);



SELECT *
FROM	(SELECT name, SUM(book_amount * price) AS total
		FROM book
		GROUP BY name)
WHERE total > 2000
ORDER BY total;


SELECT name, SUM(book_amount * price) AS total
FROM book
GROUP BY name
HAVING SUM (book_amount*price) > 5000
ORDER BY total;

WITH total_sum AS (
SELECT name, SUM (book_amount * price) AS total
FROM book
GROUP BY name)

SELECT *
FROM total_sum
WHERE total > 5000
ORDER BY total;

CREATE TABLE author_book (
book_id BIGINT REFERENCES book (id) ON DELETE CASCADE,
author_id BIGINT REFERENCES author (id) ON DELETE CASCADE,

PRIMARY KEY(book_id, author_id)
);

INSERT INTO author_book (book_id, author_id)
VALUES ('1','1'),
       ('1','2'),
	   ('2','3'),
	   ('3','4'),
	   ('4','5'),
	   ('5','6'),
	   ('6','3');

SELECT CONCAT(
b.name, ', ',
a.name),
CASE
WHEN b.publishing_year > 2020 THEN 'Новая книга'
ELSE'Старая книга'
END AS type
FROM book b
JOIN author a ON b.id = a.id;
