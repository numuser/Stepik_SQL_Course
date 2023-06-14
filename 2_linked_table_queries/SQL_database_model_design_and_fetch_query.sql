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
SELECT name_author, title, COUNT(buy_book.amount) AS Количество
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
