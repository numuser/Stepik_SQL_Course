-- 3.1
-- Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.
SELECT name_student, date_attempt, result
FROM student
    JOIN attempt USING(student_id)
    JOIN subject USING(subject_id)
WHERE subject_id = (
    SELECT subject_id
    FROM subject
    WHERE name_subject = 'Основы баз данных')
ORDER BY result DESC;

-- Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой. 
-- Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.
-- В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.
SELECT name_subject, COUNT(result) AS Количество, ROUND(SUM(result) / COUNT(result), 2) AS Среднее
FROM subject
    LEFT JOIN attempt USING(subject_id)
GROUP BY name_subject
ORDER BY Среднее DESC;

-- Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.
SELECT name_student, result
FROM student
    JOIN attempt USING(student_id)
WHERE result = (
    SELECT MAX(result)
    FROM attempt
               )
ORDER BY name_student;

-- Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой. 
-- В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы. 
-- Студентов, сделавших одну попытку по дисциплине, не учитывать. 
SELECT name_student, name_subject, DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS Интервал
FROM student
    JOIN attempt USING(student_id)
    JOIN subject USING(subject_id)
GROUP BY name_subject, name_student
HAVING COUNT(date_attempt) > 1
ORDER BY Интервал;

-- Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), 
-- которые по ней проходили тестирование. Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины. В результат включить и дисциплины, тестирование по которым студенты еще не проходили,
-- в этом случае указать количество студентов 0.
SELECT name_subject, COUNT(DISTINCT student_id) AS Количество
FROM subject
    LEFT JOIN attempt USING(subject_id)
GROUP BY name_subject
ORDER BY Количество DESC, name_subject;

-- Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.
SELECT question_id, name_question
FROM subject
    JOIN question USING(subject_id)
WHERE subject_id = (
    SELECT subject_id
    FROM subject
    WHERE name_subject = 'Основы баз данных'
)
ORDER BY RAND()
LIMIT 3; 

-- Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17 (значение attempt_id для этой попытки равно 7). 
-- Указать, какой ответ дал студент и правильный он или нет(вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец Результат.
SELECT name_question, 
       name_answer, 
       IF(is_correct = 1, 'Верно', 'Неверно') AS Результат
FROM testing
       JOIN question USING(question_id) 
       JOIN answer USING(answer_id)
WHERE attempt_id = 7;






