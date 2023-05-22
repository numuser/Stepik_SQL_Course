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

