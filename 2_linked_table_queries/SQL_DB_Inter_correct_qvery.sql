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

-- Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и стоимость.
-- Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.
CREATE TABLE buy_pay AS
SELECT
    title, name_author, price, amount, (price * amount) AS 'Стоимость'
FROM author
    JOIN book USING(author_id)
    JOIN buy_book USING(book_id)
WHERE buy_id = 5
ORDER BY title;

-- В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.
INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end)
SELECT buy.buy_id, step.step_id, NULL, NULL
FROM buy CROSS JOIN step
WHERE buy.buy_id = 5; 

-- В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
-- Правильнее было бы занести не конкретную, а текущую дату. Это можно сделать с помощью функции Now(). 
-- Но при этом в разные дни будут вставляться разная дата, и задание нельзя будет проверить, поэтому  вставим дату 12.04.2020.
UPDATE buy_step JOIN step USING(step_id)
SET date_step_beg = '2020.04.12'
WHERE buy_id = 5 AND step.step_id = 1;

-- Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.
-- Реализовать два запроса для завершения этапа и начале следующего. Они должны быть записаны в общем виде, чтобы его можно было применять для любых этапов, изменив только текущий этап. Для примера пусть это будет этап «Оплата».
UPDATE buy_step JOIN step USING(step_id)
SET date_step_end = '2020.04.13'
WHERE buy_id = 5 AND step.step_id = 1;

UPDATE buy_step JOIN step USING(step_id)
SET date_step_beg = '2020.04.13'
WHERE buy_id = 5 AND step.step_id = 2;
--------------------------------------
SELECT '.∧＿∧
( ･ω･｡)つ━☆・*。
⊂　 ノ 　　　・゜+.
しーＪ　　　°。+ *´¨)
　　　　　　　　　.· ´¸.·*´¨)
　　　　　　　　　　(¸.·´ ( ¸.·"* ☆ ВЖУХ ☆" '
FROM book