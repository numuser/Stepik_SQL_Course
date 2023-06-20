-- 2.5
-- Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
INSERT INTO name_client, city_id, email
SELECT 'Попов Илья', 1, 'popov@test'
FROM city
WHERE name_city = 'Москва';
SELECT * FROM city;
