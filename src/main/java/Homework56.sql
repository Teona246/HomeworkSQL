CREATE TABLE publisher (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (200)
);

INSERT INTO publisher (name)
VALUES ('АСТ'),
       ('Machaon'),
	   ('Эксмо');

CREATE TABLE book (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (200),
price INT,
publisher_id BIGINT,

CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(id)
);

INSERT INTO book (name, price, publisher_id)
VALUES ('Одноэтажная Америка','2004','1'),
       ('Гарри Поттер','1999','2'),
	   ('Благословение Небожителей','2024','3'),
	   ('Унесенные ветром','1936','1'),
	   ('Зеленая миля','1996','1'),
	   ('Гарри Поттер и узник Азкабана','2001','2');

SELECT AVG (price), MIN (price), MAX (price)
FROM book;

SELECT a.name,
COUNT (ab.book_id)
AS "counted_books"
FROM author a
     JOIN author_book ab ON a.id = ab.id
	 GROUP BY a.id ORDER BY a.id ASC;

SELECT a.name,
COUNT (b.name), AVG (b.price)
FROM author a
     JOIN author_book ab ON a.id = ab.id
	 JOIN book b ON a.id = b.id
	 GROUP BY a.id ORDER BY a.id ASC;



CREATE TABLE author (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (200)
);

INSERT INTO author (name)
VALUES ('Илья Ильф'),
       ('Евгений Петров'),
	   ('Джоан Роуллинг'),
	   ('Моасян Тунсю'),
	   ('Маргарет Митчелл'),
	   ('Стивен Кинг');

INSERT INTO author (name)
VALUES ('автор 1'),
       ('автор 2');

SELECT a.name, a.id,
       b.name, b.id
FROM book b
RIGHT JOIN author a ON b.id = a.id
WHERE b.name IS NULL;

CREATE TABLE author_book (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
book_id BIGINT,
author_id BIGINT,

CONSTRAINT fk_book_id FOREIGN KEY (book_id) REFERENCES book(id),
CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES author(id)
);

INSERT INTO author_book (book_id, author_id)
VALUES ('1','1'),
       ('1','2'),
	   ('2','3'),
	   ('3','4'),
	   ('4','5'),
	   ('5','6'),
	   ('6','3');

SELECT b.name, b.date_of_publishing,
       p.name
From publisher p
     JOIN book b ON p.id = b.id;


