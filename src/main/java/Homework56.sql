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
date_of_publishing INT,
publisher_id BIGINT,

CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(id)
);

INSERT INTO book (name, date_of_publishing, publisher_id)
VALUES ('Одноэтажная Америка','2004','1'),
       ('Гарри Поттер','1999','2'),
	   ('Благословение Небожителей','2024','3'),
	   ('Унесенные ветром','1936','1'),
	   ('Зеленая миля','1996','1'),
	   ('Гарри Поттер и узник Азкабана','2001','2');

CREATE TABLE author (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (200),
surname VARCHAR (200)
);

INSERT INTO author (name, surname)
VALUES ('Илья','Ильф'),
       ('Евгений','Петров'),
	   ('Джоан','Роуллинг'),
	   ('Моасян','Тунсю'),
	   ('Маргарет','Митчелл'),
	   ('Стивен','Кинг');

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

