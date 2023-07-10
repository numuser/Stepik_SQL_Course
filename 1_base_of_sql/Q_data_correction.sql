-- 1.5

-- Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблицa book.

CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);

-- Занесите в таблицу supply четыре записи

INSERT INTO supply(
    title, author, price, amount
)
VALUES
    ('Лирика','Пастернак Б.Л.',518.99 ,2),
    ('Черный человек','Есенин С.А.',570.20 ,6),
    ('Белая гвардия','Булгаков М.А.',540.50 ,7),
    ('Идиот','Достоевский Ф.М.',360.80 ,3);

-- Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE author != "Булгаков М.А." AND author != "Достоевский Ф.М.";

SELECT * FROM book;

-- Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE author NOT IN (SELECT author FROM book);

SELECT * FROM book;

-- Под обновлением данных подразумевается изменение значений в существующих записях таблицы. 
-- При этом возможно как изменение значений полей в группе строк (даже всех строк таблицы), так и правка значения поля отдельной строки.
-- Изменение записей в таблице реализуется с помощью запроса UPDATE. Простейший запрос на  обновление выглядит так:

--  "UPDATE таблица SET поле = выражение"

-- Уменьшить на 30% цену тех книг в таблице book, количество которых меньше 5.
UPDATE book
SET price = 0.7 * price
WHERE amount < 5;

SELECT * FROM book;

-- Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10;

SELECT * FROM book

-- Запросом UPDATE можно обновлять значения нескольких столбцов одновременно. В этом случае простейший запрос будет выглядеть так:

--   "UPDATE таблица SET поле1 = выражение1, поле2 = выражение2"

-- В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. 
-- А цену тех книг, которые покупатель не заказывал, снизить на 10%.
UPDATE book 
SET buy = IF(buy > amount, amount, buy),
    price = IF(buy = 0, 0.9 * price, price);

SELECT * FROM book;
