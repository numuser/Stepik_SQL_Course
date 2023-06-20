-- 2.5
-- Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
INSERT INTO client (name_client, city_id, email)
SELECT DISTINCT 'Попов Илья', city_id, 'popov@test'
FROM client
WHERE city_id = (
    SELECT city_id
    FROM city
    WHERE name_city = 'Москва'
                );
