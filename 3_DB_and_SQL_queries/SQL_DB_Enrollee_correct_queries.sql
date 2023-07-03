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

Из таблицы applicant,  созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету (использовать запрос из предыдущего урока).

