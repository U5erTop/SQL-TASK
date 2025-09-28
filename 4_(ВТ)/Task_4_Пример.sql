-- ПРИМЕР ВЫПОЛНЕНИЯ ЗАДАНИЯ: БИБЛИОТЕКА

-- ==========================================
-- ЭТАП 1: ИСХОДНАЯ ДЕНОРМАЛИЗОВАННАЯ ТАБЛИЦА
-- ==========================================

CREATE TABLE Library_Original (
    book_id INT,
    title NVARCHAR(100),
    authors NVARCHAR(200),        -- НАРУШЕНИЕ 1НФ: несколько авторов в одном поле
    genres NVARCHAR(100),         -- НАРУШЕНИЕ 1НФ: несколько жанров
    publisher_name NVARCHAR(100),
    publisher_address NVARCHAR(200), -- Можно разбить на компоненты
    publish_year INT,
    isbn NVARCHAR(20),
    reader_id INT,
    reader_name NVARCHAR(100),
    reader_phone NVARCHAR(50),    -- НАРУШЕНИЕ 1НФ: может содержать несколько номеров
    reader_address NVARCHAR(200),
    issue_date DATE,
    return_date DATE,
    librarian_name NVARCHAR(100)
);

-- Пример данных с нарушениями 1НФ
INSERT INTO Library_Original VALUES
(1, 'Война и мир', 'Толстой Л.Н.', 'Роман, Классика', 'АСТ', 'г. Москва, ул. Пушкина, 10', 2020, '978-5-17-123456-7', 101, 'Иванов И.И.', '+7-123-456-78-90, +7-987-654-32-10', 'г. Москва, ул. Ленина, 5', '2024-01-15', '2024-02-15', 'Петрова А.В.'),
(2, 'Мастер и Маргарита', 'Булгаков М.А.', 'Фантастика, Классика', 'Эксмо', 'г. Москва, ул. Тверская, 15', 2019, '978-5-04-098765-4', 102, 'Петров П.П.', '+7-111-222-33-44', 'г. Санкт-Петербург, Невский пр., 20', '2024-01-20', '2024-02-20', 'Сидорова М.К.');

-- ==========================================
-- ЭТАП 2: ПРИВЕДЕНИЕ К 1НФ
-- ==========================================

-- Таблица в 1НФ с разделением составных значений
CREATE TABLE Library_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    title NVARCHAR(100),
    author NVARCHAR(100),         -- ОДИН автор в записи
    genre NVARCHAR(50),           -- ОДИН жанр в записи
    publisher_name NVARCHAR(100),
    publisher_city NVARCHAR(50),
    publisher_street NVARCHAR(100),
    publisher_building NVARCHAR(10),
    publish_year INT,
    isbn NVARCHAR(20),
    reader_id INT,
    reader_name NVARCHAR(100),
    reader_phone NVARCHAR(20),    -- ОДИН номер телефона
    reader_city NVARCHAR(50),
    reader_street NVARCHAR(100),
    reader_building NVARCHAR(10),
    issue_date DATE,
    return_date DATE,
    librarian_name NVARCHAR(100)
);

-- Данные в 1НФ (каждая комбинация автор-жанр = отдельная запись)
INSERT INTO Library_1NF VALUES
(1, 'Война и мир', 'Толстой Л.Н.', 'Роман', 'АСТ', 'Москва', 'ул. Пушкина', '10', 2020, '978-5-17-123456-7', 101, 'Иванов И.И.', '+7-123-456-78-90', 'Москва', 'ул. Ленина', '5', '2024-01-15', '2024-02-15', 'Петрова А.В.'),
(1, 'Война и мир', 'Толстой Л.Н.', 'Классика', 'АСТ', 'Москва', 'ул. Пушкина', '10', 2020, '978-5-17-123456-7', 101, 'Иванов И.И.', '+7-987-654-32-10', 'Москва', 'ул. Ленина', '5', '2024-01-15', '2024-02-15', 'Петрова А.В.'),
(2, 'Мастер и Маргарита', 'Булгаков М.А.', 'Фантастика', 'Эксмо', 'Москва', 'ул. Тверская', '15', 2019, '978-5-04-098765-4', 102, 'Петров П.П.', '+7-111-222-33-44', 'Санкт-Петербург', 'Невский пр.', '20', '2024-01-20', '2024-02-20', 'Сидорова М.К.'),
(2, 'Мастер и Маргарита', 'Булгаков М.А.', 'Классика', 'Эксмо', 'Москва', 'ул. Тверская', '15', 2019, '978-5-04-098765-4', 102, 'Петров П.П.', '+7-111-222-33-44', 'Санкт-Петербург', 'Невский пр.', '20', '2024-01-20', '2024-02-20', 'Сидорова М.К.');

-- ==========================================
-- ЭТАП 3: ФУНКЦИОНАЛЬНЫЕ ЗАВИСИМОСТИ
-- ==========================================

/*
ВЫЯВЛЕННЫЕ ФУНКЦИОНАЛЬНЫЕ ЗАВИСИМОСТИ:

1. book_id → title, publish_year, isbn
2. isbn → title, publish_year (альтернативный ключ)
3. publisher_name → publisher_city, publisher_street, publisher_building
4. reader_id → reader_name, reader_city, reader_street, reader_building
5. reader_phone → reader_id (каждый телефон принадлежит одному читателю)
6. (book_id, reader_id, issue_date) → return_date, librarian_name

ЧАСТИЧНЫЕ ЗАВИСИМОСТИ (нарушения 2НФ):
- Если PK = (book_id, reader_id, issue_date), то:
  - book_id → title, publish_year, isbn (зависит только от части ключа)
  - reader_id → reader_name, address (зависит только от части ключа)

ТРАНЗИТИВНЫЕ ЗАВИСИМОСТИ (нарушения 3НФ):
- publisher_name → publisher_address (через book_id)
- reader_phone → reader_name (через reader_id)
*/

-- ==========================================
-- ЭТАП 4: ПРИВЕДЕНИЕ К 3НФ
-- ==========================================

-- 1. Справочник издательств
CREATE TABLE Publishers (
    publisher_id INT IDENTITY(1,1) PRIMARY KEY,
    publisher_name NVARCHAR(100) NOT NULL,
    city NVARCHAR(50),
    street NVARCHAR(100),
    building NVARCHAR(10)
);

-- 2. Справочник авторов
CREATE TABLE Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(100) NOT NULL
);

-- 3. Справочник жанров
CREATE TABLE Genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name NVARCHAR(50) NOT NULL
);

-- 4. Справочник книг
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    publisher_id INT,
    publish_year INT,
    isbn NVARCHAR(20) UNIQUE,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- 5. Связь книг и авторов (многие ко многим)
CREATE TABLE BookAuthors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- 6. Связь книг и жанров (многие ко многим)
CREATE TABLE BookGenres (
    book_id INT,
    genre_id INT,
    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- 7. Справочник читателей
CREATE TABLE Readers (
    reader_id INT PRIMARY KEY,
    reader_name NVARCHAR(100) NOT NULL,
    city NVARCHAR(50),
    street NVARCHAR(100),
    building NVARCHAR(10)
);

-- 8. Телефоны читателей (один ко многим)
CREATE TABLE ReaderPhones (
    phone_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT,
    phone_number NVARCHAR(20),
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id)
);

-- 9. Справочник библиотекарей
CREATE TABLE Librarians (
    librarian_id INT IDENTITY(1,1) PRIMARY KEY,
    librarian_name NVARCHAR(100) NOT NULL
);

-- 10. Основная таблица выдач (без избыточности)
CREATE TABLE BookIssues (
    issue_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    reader_id INT,
    librarian_id INT,
    issue_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id),
    FOREIGN KEY (librarian_id) REFERENCES Librarians(librarian_id)
);

-- ==========================================
-- ЭТАП 5: ЗАПОЛНЕНИЕ ДАННЫМИ
-- ==========================================

-- Заполнение справочников
INSERT INTO Publishers VALUES 
('АСТ', 'Москва', 'ул. Пушкина', '10'),
('Эксмо', 'Москва', 'ул. Тверская', '15');

INSERT INTO Authors VALUES 
('Толстой Л.Н.'),
('Булгаков М.А.');

INSERT INTO Genres VALUES 
('Роман'),
('Классика'),
('Фантастика');

INSERT INTO Books VALUES 
(1, 'Война и мир', 1, 2020, '978-5-17-123456-7'),
(2, 'Мастер и Маргарита', 2, 2019, '978-5-04-098765-4');

INSERT INTO BookAuthors VALUES 
(1, 1), (2, 2);

INSERT INTO BookGenres VALUES 
(1, 1), (1, 2), (2, 3), (2, 2);

INSERT INTO Readers VALUES 
(101, 'Иванов И.И.', 'Москва', 'ул. Ленина', '5'),
(102, 'Петров П.П.', 'Санкт-Петербург', 'Невский пр.', '20');

INSERT INTO ReaderPhones VALUES 
(101, '+7-123-456-78-90'),
(101, '+7-987-654-32-10'),
(102, '+7-111-222-33-44');

INSERT INTO Librarians VALUES 
('Петрова А.В.'),
('Сидорова М.К.');

INSERT INTO BookIssues VALUES 
(1, 101, 1, '2024-01-15', '2024-02-15'),
(2, 102, 2, '2024-01-20', '2024-02-20');

-- ==========================================
-- КОНТРОЛЬНЫЕ ЗАПРОСЫ
-- ==========================================

-- 1. Восстановление исходного представления
SELECT 
    b.book_id,
    b.title,
    STRING_AGG(a.author_name, ', ') AS authors,
    STRING_AGG(g.genre_name, ', ') AS genres,
    p.publisher_name,
    CONCAT(p.city, ', ', p.street, ', ', p.building) AS publisher_address,
    b.publish_year,
    b.isbn,
    r.reader_id,
    r.reader_name,
    STRING_AGG(rp.phone_number, ', ') AS reader_phones,
    CONCAT(r.city, ', ', r.street, ', ', r.building) AS reader_address,
    bi.issue_date,
    bi.return_date,
    l.librarian_name
FROM Books b
    LEFT JOIN BookAuthors ba ON b.book_id = ba.book_id
    LEFT JOIN Authors a ON ba.author_id = a.author_id
    LEFT JOIN BookGenres bg ON b.book_id = bg.book_id
    LEFT JOIN Genres g ON bg.genre_id = g.genre_id
    LEFT JOIN Publishers p ON b.publisher_id = p.publisher_id
    LEFT JOIN BookIssues bi ON b.book_id = bi.book_id
    LEFT JOIN Readers r ON bi.reader_id = r.reader_id
    LEFT JOIN ReaderPhones rp ON r.reader_id = rp.reader_id
    LEFT JOIN Librarians l ON bi.librarian_id = l.librarian_id
GROUP BY 
    b.book_id, b.title, p.publisher_name, p.city, p.street, p.building,
    b.publish_year, b.isbn, r.reader_id, r.reader_name, r.city, r.street, r.building,
    bi.issue_date, bi.return_date, l.librarian_name;

-- 2. Статистика по жанрам
SELECT 
    g.genre_name,
    COUNT(*) AS books_count
FROM Genres g
    JOIN BookGenres bg ON g.genre_id = bg.genre_id
    JOIN Books b ON bg.book_id = b.book_id
GROUP BY g.genre_name;

-- 3. Читатели с просроченными книгами
SELECT 
    r.reader_name,
    b.title,
    bi.issue_date,
    bi.return_date,
    DATEDIFF(day, bi.return_date, GETDATE()) AS days_overdue
FROM BookIssues bi
    JOIN Readers r ON bi.reader_id = r.reader_id
    JOIN Books b ON bi.book_id = b.book_id
WHERE bi.return_date < GETDATE();