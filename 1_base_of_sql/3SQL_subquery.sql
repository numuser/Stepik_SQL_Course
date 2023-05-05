----------------------------------------------------------
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);

INSERT INTO book (title, author, price, amount)
VALUES ('Мастер и Маргарита','Булгаков М.А.', 670.99, 3);

INSERT INTO book (title, author, price, amount)
VALUES ('Белая гвардия', 'Булгаков М.А.',540.50, 5),
('Идиот', 'Достоевский Ф.М.', 460, 10),
('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2),
('Игрок', 'Достоевский Ф.М.', 480.50, 10),
('Стихотворения и поэмы	', 'Есенин С.А.',650 ,15);
SELECT * FROM book;
----------------------------------------------------------

-- 1.4
-- Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе.
-- Информацию вывести в отсортированном по убыванию цены виде.
SELECT author,
    title,
    price
FROM book
WHERE price <= (
    SELECT avg(price)
    FROM book
)
ORDER BY price DESC;

-- Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе
-- не более чем на 150 рублей в отсортированном по возрастанию цены виде.
SELECT author,
    title,
    price
FROM book
WHERE price <= (
    SELECT min(price) FROM book) + 150
ORDER BY price ASC;

-- Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.
SELECT author, title, amount
FROM book
WHERE amount IN (
    SELECT amount
    FROM book
    
);

-- Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора.
SELECT author, title, price
FROM book
WHERE price < ANY (
    SELECT MIN(price)
    FROM book 
    GROUP BY author
);

-- Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, 
-- чтобы на складе стало одинаковое количество экземпляров каждой книги, равное значению самого большего количества экземпляров одной книги на складе.
SELECT title, author, amount,
    (SELECT max(amount)
    FROM book
    ) - amount AS Заказ
FROM book               -- or
WHERE amount <> (       -- HAVING Заказ > 0;
    SELECT max(amount)  --
    FROM book           --
);

-- Определить стоимость покупки, если купить самую дешевую книгу каждого автора.
SELECT SUM(price) AS Стоимость_покупки
FROM book
WHERE price = ANY (
    SELECT MIN(price) 
    FROM book
    GROUP BY author
);

