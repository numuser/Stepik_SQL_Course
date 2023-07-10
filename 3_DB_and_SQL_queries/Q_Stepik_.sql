-- 3.5
-- Отобрать все шаги, в которых рассматриваются вложенные запросы (то есть в названии шага упоминаются вложенные запросы). Указать к какому уроку и модулю они относятся.
SELECT CONCAT(LEFT(CONCAT(module_id, ' ', module_name), 16), '...') AS 'Модуль',
       CONCAT(LEFT(CONCAT(module_id, '.', lesson_position, ' ', lesson_name), 16), '...') AS 'Урок',
       CONCAT(module_id, '.', lesson_position, '.', step_position, ' ', step_name) AS 'Шаг'
FROM module 
    JOIN lesson USING(module_id)
    JOIN step USING(lesson_id)
WHERE lesson_name IN (
    SELECT lesson_name
    FROM lesson
    WHERE step_name like "%вложен%запрос%"
    )
ORDER BY Модуль, Урок, Шаг





