-- 1.7
-- Using alias
-- Для присваивания псевдонима существует 2 варианта: 

-- с использованием ключевого слова AS
-- FROM fine AS f, traffic_violation AS tv

-- а так же и без него
-- FROM fine f, traffic_violation tv

-- а так же и без него
-- FROM fine f, traffic_violation tv


-- Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation.
-- При этом суммы заносить только в пустые поля столбца  sum_fine
UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = tv.sum_fine
WHERE f.sum_fine IS NULL AND f.violation = tv.violation;

SELECT * FROM fine;

-- Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило   два и более раз.
-- При этом учитывать все нарушения, независимо от того оплачены они или нет.
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING count(*) >= 2
ORDER BY name

-- В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей.
UPDATE fine,
    (
        SELECT name, number_plate, violation
        FROM fine
        GROUP BY name, number_plate, violation
        HAVING COUNT(violation) >= 2
        ORDER BY name
    ) AS temp
    
SET fine.sum_fine = fine.sum_fine * 2
WHERE fine.date_payment IS NULL 
AND fine.name = temp.name
AND fine.number_plate = temp.number_plate
AND fine.violation = temp.violation;

SELECT * FROM fine;

-- Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты
-- Необходимо:

-- в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
-- уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE 
    fine, payment
SET 
    fine.date_payment = payment.date_payment,
    fine.sum_fine = IF(DATEDIFF(payment.date_payment, payment.date_violation) <= 20,
                       fine.sum_fine / 2, fine.sum_fine)
WHERE
    fine.date_payment IS NULL 
    AND fine.name = payment.name
    AND fine.number_plate = payment.number_plate
    AND fine.violation = payment.violation;

SELECT name, number_plate, violation, sum_fine, date_violation, date_payment FROM fine;

-- Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
CREATE TABLE back_payment AS
SELECT
    name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;

SELECT * FROM back_payment 

-- Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года.
DELETE FROM fine
WHERE date_violation < '2020-02-01';

SELECT * FROM fine;

