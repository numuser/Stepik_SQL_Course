CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);

INSERT INTO supply(
    title, author, price, amount
)
VALUES ('Доктор Живаго', 'Пастернак Б.Л.', 380.80, 4),
       ('Черный человек', 'Есенин С.А.', 570.20, 6),
       ('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
       ('Идиот', 'Достоевский Ф.М.', 360.80, 3),
       ('Стихотворения и поэмы', 'Лермонтов М.Ю.', 255.90, 4),
       ('Остров сокровищ', 'Стивенсон Р.Л.', 599.99, 5);