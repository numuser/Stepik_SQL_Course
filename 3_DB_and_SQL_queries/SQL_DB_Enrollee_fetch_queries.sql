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
SELECT name_enrollee, IF(SUM(bonus) IS NULL, NULL, SUM(bonus)) AS Бонус
FROM enrollee
    LEFT JOIN enrollee_achievement USING(enrollee_id)
    LEFT JOIN achievement using(achievement_id)
GROUP BY name_enrollee
ORDER BY name_enrollee;

-- Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений деленное на количество мест по плану), 
-- округленный до 2-х знаков после запятой. В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы, план набора абитуриентов на образовательную программу (plan), 
-- количество поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса.
SELECT name_department, name_program, plan, COUNT(enrollee_id) AS Количество, ROUND(COUNT(enrollee_id) / plan, 2) AS Конкурс
FROM department
    JOIN program USING(department_id)
    JOIN program_enrollee USING(program_id)
GROUP BY name_department, name_program, plan
ORDER BY Конкурс DESC;

-- Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» в отсортированном по названию программ виде.
SELECT name_program
FROM program
    JOIN program_subject USING(program_id)
    JOIN subject USING(subject_id)
WHERE name_subject IN ('Математика', 'Информатика')
GROUP BY name_program
HAVING COUNT(program_id) = 2
ORDER BY name_program

-- Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, по результатам ЕГЭ. В результат включить название образовательной программы, фамилию и имя абитуриента, 
-- а также столбец с суммой баллов, который назвать itog. Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде.
SELECT name_program, name_enrollee, SUM(result) AS itog
FROM enrollee 
    JOIN program_enrollee USING(enrollee_id)
    JOIN program USING(program_id)
    JOIN program_subject USING(program_id)
    JOIN subject USING(subject_id)
    JOIN enrollee_subject ON 
        subject.subject_id = enrollee_subject.subject_id 
        AND enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY name_program, name_enrollee
ORDER BY name_program, itog DESC;

-- Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее. Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, 
-- необходимым для поступления на эту образовательную программу, меньше минимального балла. Информацию вывести в отсортированном сначала по программам, а потом по фамилиям абитуриентов виде.
SELECT name_program, name_enrollee
FROM enrollee 
    JOIN program_enrollee USING(enrollee_id)
    JOIN program USING(program_id)
    JOIN program_subject USING(program_id)
    JOIN subject USING(subject_id)
    JOIN enrollee_subject ON 
        subject.subject_id = enrollee_subject.subject_id 
        AND enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE result < min_result
GROUP BY name_program, name_enrollee
ORDER BY name_program, name_enrollee;
