-- 1.6 Trip Table

-- Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а»,
-- в отсортированном по убыванию даты последнего дня командировки виде.
SELECT name,
        city,
        per_diem,
        date_first,
        date_last

FROM trip
WHERE name LIKE '%а %'
ORDER BY date_last DESC;

-- Для ограничения вывода записей в SQL используется оператор LIMIT , после которого указывается количество строк. 
-- Результирующая таблица будет иметь количество строк не более указанного после LIMIT.
-- LIMIT размещается после раздела ORDER BY.

-- SELECT *
-- FROM trip
-- ORDER BY  date_first
-- LIMIT 1;


-- Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество.
SELECT city, count(city) as 'Количество'
FROM trip
GROUP BY city
ORDER BY count(city) DESC LIMIT 2;

-- Для вычитания двух дат используется функция DATEDIFF(дата_1, дата_2), 
-- результатом которой является количество дней между дата_1 и дата_2.

-- DATEDIFF('2020-04-01', '2020-03-28')=4
-- DATEDIFF('2020-05-09','2020-05-01')=8
-- DATEDIFF(date_last, date_first)

-- Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город,
-- длительность командировки в днях, при этом первый и последний день относится к периоду командировки).
-- Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки,
-- а потом по убыванию названий городов (в обратном алфавитном порядке).
SELECT name, 
       city, 
       DATEDIFF(
           date_last, date_first
       ) + 1 as 'Длительность'
FROM trip
WHERE city NOT IN('Москва', 'Санкт-Петербург')
ORDER BY Длительность DESC, city DESC;

-- Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени.
SELECT name, city, date_first, date_last
FROM trip
WHERE DATEDIFF(date_last, date_first) = (
    SELECT MIN(DATEDIFF(date_last, date_first)) 
    FROM trip 
    ORDER BY DATEDIFF(date_last, date_first) 
    );

-- Для того, чтобы выделить номер месяца из даты используется функция MONTH(дата).
-- Например, 
-- MONTH('2020-04-12') = 4.

-- Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой)
SELECT name, city, date_first, date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city, name;

-- Вывести сумму суточных (произведение количества дней командировки и размера суточных) для командировок,
-- первый день которых пришелся на февраль или март 2020 года.
SELECT name, city, date_first,
       (DATEDIFF(date_last, date_first) + 1) * per_diem as 'Сумма'
FROM trip
WHERE MONTHNAME(date_first) IN ('February', 'March')  
ORDER BY name, Сумма DESC

-- Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников,
-- которые были в командировках больше чем 3 раза, в отсортированном по убыванию сумм суточных виде.
SELECT name, 
       SUM((DATEDIFF(date_last, date_first) + 1) * per_diem) AS 'Сумма'
FROM trip
GROUP BY name
HAVING COUNT(name) > 3
ORDER BY Сумма DESC
