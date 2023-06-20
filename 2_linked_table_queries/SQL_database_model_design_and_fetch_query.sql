-- 2.4
-- Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал)
-- в отсортированном по номеру заказа и названиям книг виде.
SELECT buy_book.buy_id, title, price, buy_book.amount 
FROM 
    client 
    JOIN buy ON client.client_id = buy.client_id
    JOIN buy_book ON buy_book.buy_id = buy.buy_id
    JOIN book ON buy_book.book_id=book.book_id
WHERE client.client_id = 1
ORDER BY buy_id, title;

-- Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора.
-- Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT name_author, title, COUNT(buy_book.amount) AS 'Количество'
FROM author
    JOIN book ON author.author_id = book.author_id
    LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY book.book_id
ORDER BY name_author, title;

-- Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество.
-- Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
SELECT name_city, COUNT(buy.client_id) AS 'Количество'
FROM city
    JOIN client ON city.city_id = client.city_id
    JOIN buy ON client.client_id = buy.client_id
GROUP BY city.city_id
ORDER BY Количество DESC, name_city;

-- Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT buy_id, date_step_end
FROM step
    JOIN buy_step ON step.step_id = buy_step.step_id
WHERE date_step_end IS NOT NULL AND buy_step.step_id = 1

-- Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), 
-- в отсортированном по номеру заказа виде.
SELECT buy_book.buy_id, name_client, SUM(buy_book.amount * price) AS 'Стоимость' 
FROM client
    JOIN buy ON client.client_id = buy.client_id
    JOIN buy_book ON buy.buy_id = buy_book.buy_id
    JOIN book ON buy_book.book_id = book.book_id
GROUP BY buy_id, name_client
ORDER BY buy_id; 

-- Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. 
-- Информацию отсортировать по возрастанию buy_id.
SELECT buy_id, name_step
FROM step
    JOIN buy_step ON step.step_id = buy_step.step_id
WHERE date_step_beg IS NOT NULL AND date_step_end IS NULL
ORDER BY buy_id;

-- Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
SELECT DISTINCT name_client
FROM author
    JOIN book USING(author_id)
    JOIN buy_book USING(book_id)
    JOIN buy USING(buy_id)
    JOIN client USING(client_id)
WHERE author.name_author = 'Достоевский Ф.М.'
ORDER BY name_client;

-- Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество . Последний столбец назвать Количество.
SELECT name_genre, SUM(buy_book.amount) AS 'Количество'
FROM genre
    JOIN book USING(genre_id)
    JOIN buy_book USING(book_id)
GROUP BY name_genre
HAVING SUM(buy_book.amount) = 
     (/* вычисляем максимальное из общего количества книг каждого жанра */
      SELECT MAX(sum_amount) AS max_sum_amount
      FROM 
          (/* считаем количество книг каждого жанра */
            SELECT genre_id, SUM(buy_book.amount) AS sum_amount 
            FROM book
                JOIN buy_book USING(book_id) 
            GROUP BY genre_id
          ) query_in
      );

------------------------------------------------- UNION and UNION ALL --------------------------------------------------------------------------
-- Оператор UNION
-- Оператор UNION используется для объединения двух и более SQL запросов, его синтаксис:

-- SELECT столбец_1_1, столбец_1_2, ...
-- FROM 
--   ...
-- UNION
-- SELECT столбец_2_1, столбец_2_2, ...
-- FROM 
--   ...
-- или
-- SELECT столбец_1_1, столбец_1_2, ...
-- FROM 
--   ...
-- UNION ALL
-- SELECT столбец_2_1, столбец_2_2, ...
-- FROM 
--   ...
-- Важно отметить, что каждый из SELECT должен иметь в своем запросе одинаковое количество столбцов и  совместимые типы возвращаемых данных. Каждый запрос может включать разделы WHERE, GROUP BY и пр.
-- В результате выполнения этой конструкции будет выведена таблица, имена столбцов которой соответствуют именам столбцов в первом запросе. А в таблице результата сначала отображаются записи-результаты первого запроса, 
-- а затем второго. Если указано ключевое слово ALL, то в результат включаются все записи запросов, в противном случае - различные.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде.
-- Название столбцов: Год, Месяц, Сумма.

SELECT YEAR(date_payment) AS 'Год',
       MONTHNAME(date_payment) AS 'Месяц',
       SUM(amount * price) AS 'Сумма'
FROM buy_archive
GROUP BY Год, Месяц
UNION ALL
SELECT YEAR(date_step_end) AS 'Год',
       MONTHNAME(date_step_end) AS 'Месяц', 
       SUM(buy_book.amount * book.price) AS 'Сумма'
FROM book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id) 
WHERE buy_step.step_id = 1 AND date_step_end IS NOT NULL
GROUP BY Год, Месяц
ORDER BY Месяц, Год;

