-- 1.3

-- Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе.  Столбцы назвать Автор, 
-- Различных_книг и Количество_экземпляров соответственно.
SELECT author AS 'Автор', count(amount) AS 'Различных_книг',
    sum(amount) AS 'Количество_экземпляров'
FROM book
GROUP BY author;

-- Выборка данных c вычислением, групповые функции

-- Для каждого автора вычислить суммарную стоимость книг S (имя столбца Стоимость),
-- а также вычислить налог на добавленную стоимость  для полученных сумм (имя столбца НДС ) , который включен в стоимость и составляет k = 18%,  а также стоимость книг  (Стоимость_без_НДС) без негo
SELECT author, 
    ROUND(sum(price * amount)) AS 'Стоимость',
    ROUND((sum(price * amount) * 0.18 / 100) / (1 + 0.18 / 100)) AS 'НДС',
    ROUND(sum(price * amount) / (1 + 0.18 / 100)) AS 'Стоимость_без_НДС'
FROM book
GROUP BY author;

-- Вычисления по таблице целиком
-- В задании нужно посчитать среднюю цену уникальных книг на складе, а не среднюю цену всех экземпляров книг.
SELECT DISTINCT min(price) AS 'Минимальная_цена',
    max(price) AS 'Максимальная_цена',
    ROUND(avg(price), 2) AS 'Средняя_цена'
FROM book;

-- Найти минимальную и максимальную цену книг всех авторов, общая стоимость книг которых больше 5000.
-- Результат вывести по убыванию минимальной цены.
SELECT author,
    MIN(price) AS Минимальная_цена, 
    MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
HAVING SUM(price * amount) > 5000 
ORDER BY Минимальная_цена DESC;

-- WHERE и HAVING могут использоваться в одном запросе. 
-- При этом необходимо учитывать порядок выполнения  SQL запроса на выборку на СЕРВЕРЕ:
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- ORDER BY


-- Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия».
SELECT author,
    SUM(price * amount) AS 'Стоимомть'
FROM book
WHERE title <> 'Идиот' and title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY SUM(price * amount) DESC;


-- Сгенерировать алфавитный указатель по названию:

-- Объединить книги в разделы по первой букве названия.
-- Каждый раздел начинать со строки, в которой непустой является только колонка 'Буква' - первая буква названия.
-- Для строк с названиями книг колонка 'Буква' - пустая.
-- Упорядочить разделы и названия книг внутри разделов (а также авторов для одинаковых названий) по алфавиту.
-- Вывести колонки Буква, Название и Автор.

SELECT SUBSTR(title, 1, 1) AS Буква, 
    '' AS Название, 
    '' AS Автор
FROM book
UNION
SELECT '' as Буква,
    title,
    author
FROM book
ORDER BY CONCAT(Буква, Название)
 
