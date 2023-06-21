-- 2.5
-- Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
INSERT INTO client (name_client, city_id, email)
SELECT DISTINCT 'Попов Илья', city_id, 'popov@test'
FROM client
WHERE city_id = (
    SELECT city_id
    FROM city
    WHERE name_city = 'Москва'
                );

-- Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки»
INSERT INTO buy (buy_description, client_id)
SELECT 'Связаться со мной по вопросу доставки', client_id
FROM client
WHERE client_id = (
    SELECT client_id
    FROM client
    WHERE name_client LIKE 'Попов Илья'
            );

-- В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 2
FROM author 
    JOIN book USING(author_id)
WHERE name_author LIKE 'Пастернак%' AND title LIKE 'Лирика';

INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 1
FROM author 
    JOIN book USING(author_id)
WHERE name_author LIKE 'Булгаков%' AND title LIKE 'Белая гвардия';

SELECT * FROM buy_book;

-- Уменьшить количество тех книг на складе, которые были включены в заказ с номером 5.
UPDATE book JOIN buy_book USING(book_id)
SET book.amount = book.amount - buy_book.amount
WHERE book_id IN 
        (
        SELECT book_id
        FROM buy_book
        WHERE buy_id = 5
        ); 

