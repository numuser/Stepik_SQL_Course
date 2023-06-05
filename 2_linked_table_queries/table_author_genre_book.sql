-- 2.1
CREATE TABLE author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

INSERT INTO author(name_author)
VALUES 
    ("Булгаков М.А."),
    ("Достоевский Ф.М."),
    ("Есенин С.А."),
    ("Пастернак Б.Л.");

CREATE TABLE genre(
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);

INSERT INTO genre(name_genre)
VALUES
    ("Роман"),
    ("Поэзия")

-- Перепишите запрос на создание таблицы book, чтобы ее структура соответствовала структуре, показанной на логической схеме (таблица genre уже создана, 
-- порядок следования столбцов - как на логической схеме в таблице book, genre_id - внешний ключ).
-- Для genre_id ограничение о недопустимости пустых значений не задавать.
-- В качестве главной таблицы для описания поля  genre_id использовать таблицу genre
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    FOREIGN KEY (author_id) REFERENCES author (author_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
);

-- С помощью выражения ON DELETE можно установить действия, которые выполняются для записей подчиненной таблицы при удалении связанной строки из главной таблицы.
-- При удалении можно установить следующие опции:

-- CASCADE: автоматически удаляет строки из зависимой таблицы при удалении  связанных строк в главной таблице.
-- SET NULL: при удалении  связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение NULL. (В этом случае столбец внешнего ключа должен поддерживать установку NULL).
-- SET DEFAULT похоже на SET NULL за тем исключением, что значение  внешнего ключа устанавливается не в NULL, а в значение по умолчанию для данного столбца.
-- RESTRICT: отклоняет удаление строк в главной таблице при наличии связанных строк в зависимой таблице.
-- CREATE TABLE book(
--     book_id INT PRIMARY KEY AUTO_INCREMENT,
--     title VARCHAR(50),
--     author_id INT NOT NULL,
--     genre_id INT,
--     price DECIMAL(8, 2),
--     amount INT,
--     FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE CASCADE,
--     FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
--     );

-- Добавьте записи в таблицу book
INSERT INTO book(title, author_id, genre_id, price, amount)
VALUES
    ("Мастер и Маргарита", 1, 1, 670.99, 3),
    ("Белая гвардия	", 1, 1, 540.50, 5),
    ("Идиот", 2, 1, 460.00, 10),
    ("Братья Карамазовы", 2, 1, 799.01, 3),
    ("Игрок", 2, 1, 480.50, 10),
    ("Стихотворения и поэмы", 3, 2, 650.00, 15),
    ("Черный человек", 3, 2, 570.20, 6),
    ("Лирика", 4, 2, 518.99, 2);