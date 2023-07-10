-- +-----------+-----------------------+------------------+--------+--------+
-- | supply_id | title                 | author           | price  | amount |
-- +-----------+-----------------------+------------------+--------+--------+
-- | 1         | Доктор Живаго         | Пастернак Б.Л.   | 380.80 | 4      |
-- | 2         | Черный человек        | Есенин С.А.      | 570.20 | 6      |
-- | 3         | Белая гвардия         | Булгаков М.А.    | 540.50 | 7      |
-- | 4         | Идиот                 | Достоевский Ф.М. | 360.80 | 3      |
-- | 5         | Стихотворения и поэмы | Лермонтов М.Ю.   | 255.90 | 4      |
-- | 6         | Остров сокровищ       | Стивенсон Р.Л.   | 599.99 | 5      |
-- +-----------+-----------------------+------------------+--------+--------+
 
-- +----------+-------------+
-- | genre_id | name_genre  |
-- +----------+-------------+
-- | 1        | Роман       |
-- | 2        | Поэзия      |
-- | 3        | Приключения |
-- +----------+-------------+

-- +-----------+------------------+
-- | author_id | name_author      |
-- +-----------+------------------+
-- | 1         | Булгаков М.А.    |
-- | 2         | Достоевский Ф.М. |
-- | 3         | Есенин С.А.      |
-- | 4         | Пастернак Б.Л.   |
-- | 5         | Лермонтов М.Ю.   |
-- +-----------+------------------+

-- +---------+-----------------------+-----------+----------+--------+--------+
-- | book_id | title                 | author_id | genre_id | price  | amount |
-- +---------+-----------------------+-----------+----------+--------+--------+
-- | 1       | Мастер и Маргарита    | 1         | 1        | 670.99 | 3      |
-- | 2       | Белая гвардия         | 1         | 1        | 540.50 | 5      |
-- | 3       | Идиот                 | 2         | 1        | 460.00 | 10     |
-- | 4       | Братья Карамазовы     | 2         | 1        | 799.01 | 3      |
-- | 5       | Игрок                 | 2         | 1        | 480.50 | 10     |
-- | 6       | Стихотворения и поэмы | 3         | 2        | 650.00 | 15     |
-- | 7       | Черный человек        | 3         | 2        | 570.20 | 6      |
-- | 8       | Лирика                | 4         | 2        | 518.99 | 2      |
-- +---------+-----------------------+-----------+----------+--------+--------+

-- 2.3
-- Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),  необходимо в таблице book увеличить количество на значение,
-- указанное в поставке,  и пересчитать цену. А в таблице  supply обнулить количество этих книг. Формула для пересчета цены:
-- book.price = (book.price * book.amount + supply.price * supply.amount)/(book.amount + supply.amount)
UPDATE book
    JOIN author ON author.author_id = book.author_id
    JOIN supply ON book.title = supply.title
                    AND supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    supply.amount = 0, 
    book.price = (book.price * book.amount + supply.price * supply.amount)/(book.amount + supply.amount)
    
WHERE book.price <> supply.price;

SELECT * FROM book;

SELECT * FROM supply;

-- Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author.  Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.
INSERT INTO author (name_author)
SELECT DISTINCT supply.author
FROM author
    RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS NULL;  

-- Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса. Затем вывести для просмотра таблицу book.
INSERT INTO book (title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM author 
    JOIN supply ON author.name_author = supply.author
WHERE amount <> 0;

-- Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения». (Использовать два запроса).
UPDATE book
SET genre_id = 
    (
        SELECT genre_id
        FROM genre
        WHERE name_genre = 'Поэзия'
    )
WHERE book_id = 10;

UPDATE book
SET genre_id = 
    (
        SELECT genre_id
        FROM genre
        WHERE name_genre = 'Приключения'
    )
WHERE book_id = 11;

-- Удалить всех авторов и все их книги, общее количество книг которых меньше 20.
-- В таблице book ON DELETE CASCADE опция установлена для поля author_id.
DELETE FROM author
WHERE author_id IN 
    (
        SELECT author_id
        FROM book
        GROUP BY author_id
        HAVING SUM(amount) < 20
    );

-- Удалить все жанры, к которым относится меньше 4-х книг. В таблице book для этих жанров установить значение Null.
-- В таблице book SET NULL опция установлена на поле genre_id.
DELETE FROM genre
WHERE genre_id IN (
        SELECT genre_id
        FROM book
        GROUP BY genre_id
        HAVING COUNT(book_id) < 4
    );

-- Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов.
-- В запросе для отбора авторов использовать полное название жанра, а не его id.
DELETE FROM author
USING author 
    INNER JOIN book ON author.author_id = book.author_id
WHERE book.genre_id IN (
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Поэзия'
);

