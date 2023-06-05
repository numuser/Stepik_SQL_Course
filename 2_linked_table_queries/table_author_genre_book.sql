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