-- -- 3.4
-- Создать вспомогательную таблицу applicant,  куда включить id образовательной программы,  id абитуриента, сумму баллов абитуриентов (столбец itog) 
-- в отсортированном сначала по id образовательной программы, а потом по убыванию суммы баллов виде.
CREATE TABLE applicant 
SELECT program_enrollee.program_id, enrollee_subject.enrollee_id, SUM(result) AS itog
FROM program_enrollee
    JOIN enrollee_subject USING(enrollee_id)
    JOIN program_subject ON 
        program_subject.program_id = program_enrollee.program_id AND
        program_subject.subject_id = enrollee_subject.subject_id
GROUP BY program_enrollee.program_id, enrollee_subject.enrollee_id
ORDER BY 1, 3 DESC;

-- Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету.
DELETE FROM applicant
USING program_subject
    JOIN applicant USING(program_id)
    JOIN enrollee_subject ON
        enrollee_subject.subject_id = program_subject.subject_id AND
        enrollee_subject.enrollee_id = applicant.enrollee_id
        
WHERE result < min_result;

SELECT * FROM applicant;

-- Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов.
UPDATE applicant
JOIN
    (
        SELECT enrollee_id,  IF(SUM(bonus) IS NULL, 0, SUM(bonus)) AS extra_points
        FROM enrollee
            LEFT JOIN enrollee_achievement USING(enrollee_id)
            LEFT JOIN achievement using(achievement_id)
        GROUP BY enrollee_id
    )AS Bonus USING(enrollee_id)
SET itog = itog + extra_points;

-- Поскольку при добавлении дополнительных баллов, абитуриенты по каждой образовательной программе могут следовать не в порядке убывания суммарных баллов, необходимо создать новую таблицу applicant_order 
-- на основе таблицы applicant. 
-- При создании таблицы данные нужно отсортировать сначала по id образовательной программы, потом по убыванию итогового балла. 
-- А таблицу applicant, которая была создана как вспомогательная, необходимо удалить.
CREATE TABLE applicant_order
SELECT * FROM applicant
ORDER BY program_id, itog DESC;

DROP TABLE applicant;

-- Для изменения структуры таблицы используется оператор ALTER TABLE. С его помощью можно вставить новый столбец, удалить существующий, переименовать столбец и пр.
-- Для вставки нового столбца используется SQL запросы:

-- ALTER TABLE таблица ADD имя_столбца тип; - вставляет столбец после последнего
-- ALTER TABLE таблица ADD имя_столбца тип FIRST; - вставляет столбец перед первым
-- ALTER TABLE таблица ADD имя_столбца тип AFTER имя_столбца_1; - вставляет столбец после укзанного столбца

-- Для удаления столбца используется SQL запросы:

-- ALTER TABLE таблица DROP COLUMN имя_столбца; - удаляет столбец с заданным именем
-- ALTER TABLE таблица DROP имя_столбца; - ключевое слово COLUMN не обязательно указывать
-- ALTER TABLE таблица DROP имя_столбца,
--                     DROP имя_столбца_1; - удаляет два столбца

-- Для переименования столбца используется  запрос (тип данных указывать обязательно):

-- ALTER TABLE таблица CHANGE имя_столбца новое_имя_столбца ТИП ДАННЫХ;

-- Включить в таблицу applicant_order новый столбец str_id целого типа , расположить его перед первым.
ALTER TABLE applicant_order ADD str_id INT FIRST;

-- Занести в столбец str_id таблицы applicant_order нумерацию абитуриентов, которая начинается с 1 для каждой образовательной программы.
SET @row_num := 0;
SET @row_num := 1;

UPDATE applicant_order 
SET str_id = if(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1 AND
                @num_pr := program_id);

-- Создать таблицу student,  в которую включить абитуриентов, которые могут быть рекомендованы к зачислению  в соответствии с планом набора. 
-- Информацию отсортировать сначала в алфавитном порядке по названию программ, а потом по убыванию итогового балла.
CREATE TABLE student
SELECT name_program, name_enrollee, itog
FROM program 
    JOIN applicant_order USING(program_id)
    JOIN enrollee USING(enrollee_id)
WHERE str_id <= plan
ORDER BY name_program, itog DESC;
