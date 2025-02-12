CREATE TABLE book (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name VARCHAR (200),
price INT NOT NULL CHECK (price > 1000),
publisher_id BIGINT,

CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(id)
ON DELETE SET NULL
);

INSERT INTO book (name, price, publisher_id)
VALUES ('Одноэтажная Америка','2004','1'),
       ('Гарри Поттер','1999','2'),
	   ('Благословение Небожителей','2024','3'),
	   ('Унесенные ветром','1936','1'),
	   ('Зеленая миля','1996','1'),
	   ('Гарри Поттер и узник Азкабана','2001','2');

-- Проверка на NOT NULL и CHECK

INSERT INTO book (name, price, publisher_id)
VALUES ('Одноэтажная Америка', NULL,'1');

INSERT INTO book (name, price, publisher_id)
VALUES ('Гарри Поттер и узник Азкабана','900','2');

CREATE TABLE author_book (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
book_id BIGINT,
author_id BIGINT,

CONSTRAINT fk_book_id FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE,
CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES author(id) ON DELETE CASCADE
);

INSERT INTO author_book (book_id, author_id)
VALUES ('1','1'),
       ('1','2'),
	   ('2','3'),
	   ('3','4'),
	   ('4','5'),
	   ('5','6'),
	   ('6','3');


CREATE TABLE category (
id BIGSERIAL PRIMARY KEY,
name VARCHAR (100),
parent_id BIGINT
);

INSERT INTO category (name, parent_id)
VALUES ('Администрация', NULL),
       ('Шеф повар', NULL);

INSERT INTO category (name, parent_id)
VALUES ('Менеджер', '1'),
       ('Официант', '1'),
	   ('Бармен', '1'),
	   ('Су-шеф', '2'),
	   ('Повар', '2');

SELECT * FROM category;

