-- 3.3
-- Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде.
SELECT name_enrollee
FROM enrollee
    JOIN program_enrollee USING(enrollee_id)
    JOIN program USING(program_id)
WHERE name_program = 'Мехатроника и робототехника'
ORDER BY name_enrollee;

-- Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». Программы отсортировать в обратном алфавитном порядке.
SELECT name_program
FROM program
    JOIN program_subject USING(program_id)
    JOIN subject USING(subject_id)
WHERE name_subject = 'Информатика'
ORDER BY name_program DESC;

-- Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ. 
-- Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее. Информацию отсортировать по названию предмета в алфавитном порядке, 
-- среднее значение округлить до одного знака после запятой.
SELECT name_subject, 
        COUNT(result) AS 'Количество', 
        MAX(result) AS 'Максимум', 
        MIN(result) AS 'Минимум', 
        ROUND(AVG(result), 1) AS 'Среднее'
FROM subject
    JOIN enrollee_subject USING(subject_id)
GROUP BY name_subject
ORDER BY name_subject;

-- Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде.
SELECT DISTINCT name_program
FROM program
    JOIN program_subject USING(program_id)
GROUP BY name_program 
HAVING MIN(min_result) >= 40
ORDER BY name_program;

-- Вывести образовательные программы, которые имеют самый большой план набора, вместе с этой величиной.
SELECT name_program, plan
FROM program
WHERE plan = (
    SELECT MAX(plan)
    FROM program
    );

-- Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус. Информацию вывести в отсортированном по фамилиям виде.




