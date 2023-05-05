-- sql
-- step 7
-- Создание таблицы

CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);
-- step 8
-- Добавление одной строки
INSERT INTO book (title, author, price, amount)
VALUES ('Мастер и Маргарита','Булгаков М.А.', 670.99, 3);

-- step 9
-- Multi добавление строк
INSERT INTO book (title, author, price, amount)
VALUES ('Белая гвардия', 'Булгаков М.А.',540.50, 5),
('Идиот', 'Достоевский Ф.М.', 460, 10),
('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);
SELECT * FROM book;

-- step 1.2
-- ПОдсчет значений из строк на строки
SELECT title, author, price, amount,
    price * amount AS total
FROM book;

-- Из строк на число
SELECT title, amount,
    amount * 1.65 AS pack
FROM book;

-- Из строк на формулу НДС c функцией округления до 2 после запятой
SELECT title, 
    price, 
    ROUND((price*18/100)/(1+18/100),2) AS tax, 
    ROUND(price/(1+18/100),2) AS price_tax 
FROM book;

-- Из строк на -30% от стоимости, с функцией округления до 2 после запятой
SELECT title, author, amount,
    ROUND(price - (price * 0.30), 2) AS new_price
FROM book;

-- Проверка типа IF(условие, если TRUE, eсли FALSE)
SELECT author, title,
    ROUND(IF(author = 'Булгаков М.А.', price * 1.1, IF(author = 'Есенин С.А.', price * 1.05, price)), 2) AS new_price
FROM book;

-- С помощью запросов можно включать в итоговую выборку не все строки исходной таблицы, а только те, которые отвечают некоторому условию. 
-- Для этого после указания таблицы, откуда выбираются данные, задается ключевое слово WHERE и логическое выражение,
-- от результата которого зависит будет ли включена строка в выборку или нет.

SELECT author, title, price
FROM book
WHERE amount < 10;

-- Усложненные запросы с фильтром WHERE
SELECT title, author, price, amount
FROM book
WHERE (price < 500 OR price > 600) AND (price * amount >= 5000);

-- Усложненные запросы с фильтром WHERE, BETWEEN и IN

-- Выбрать названия и количества тех книг, количество которых от 5 до 14 включительно.
SELECT title, amount
FROM book
WHERE amount BETWEEN 5 AND 14;
-- или
SELECT title, amount 
FROM book
WHERE amount >= 5 AND amount <=14;

-- Оператор  IN  позволяет выбрать данные, соответствующие значениям из списка.
SELECT title, price 
FROM book
WHERE author IN ('Булгаков М.А.', 'Достоевский Ф.М.');
-- или
SELECT title, price 
FROM book
WHERE author = 'Булгаков М.А.' OR author = 'Достоевский Ф.М.';

-- Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы),  а количество или 2, или 3, или 5, или 7 .
SELECT title, author
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND amount IN (2,3,5,7);

-- Сортировка при помощи WH3RE, 0RDER_BY и ASC/D3SC
SELECT author, title 
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY 1 DESC, 2 ASC; -- тут 1 это колонка author и 2 - title

------------------------------------------
INSERT INTO book (title, author, price, amount)
VALUES ('                     ', 'Иванов С.С.', 50.00, 10),
('Дети полуночи', 'Рушди Салман', 950, 5),
('Лирика', 'Гумилев Н.С.', 460, 10),
('Поэмы', 'Бехтерев С.С.', 460, 10),
('Капитанская дочка', 'Пушкин А.С.', 520.50, 7);
------------------------------------------

-- Фильтр значений с помощью LIKE
SELECT title, author
FROM book
WHERE title LIKE '%_ %_' AND author LIKE '%С.%'
ORDER BY title ASC;

-- practice task 1
-- Магазин счёл, что классика уже не пользуется популярностью, поэтому необходимо в выборке:
-- 1. Сменить всех авторов на "Донцова Дарья".
-- 2. К названию каждой книги в начале дописать "Евлампия Романова и".
-- 3. Цену поднять на 42%.
-- 4. Отсортировать по убыванию цены и убыванию названия.

SELECT 'Донцова Дарья' AS author, 
CONCAT('Евлампия романова и ', title) AS title, 
ROUND(price + (price * 0.42), 2) AS price
FROM book
ORDER BY 2 ASC, 3 ASC; 
