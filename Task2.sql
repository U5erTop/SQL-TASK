-- ЗАДАНИЕ 2: ОПЕРАЦИИ С ДАННЫМИ
-- Цель: Научиться создавать таблицы, добавлять, изменять и удалять данные.

-- 1. Создаем базу данных для университета (если её нет)
-- IF NOT EXISTS работает начиная с SQL Server 2016
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'University')
CREATE DATABASE University;
GO -- Директива GO завершает текущий пакет команд и выполняет его

-- Переключаем контекст на созданную базу данных
USE University;
GO

-- 2. Создаем таблицу Students, если она не существует
IF OBJECT_ID('Students', 'U') IS NOT NULL
    DROP TABLE Students;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1), -- Первичный ключ, автоинкремент (1, 2, 3...)
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE NULL,
    Email NVARCHAR(100) NULL,
    GroupName NVARCHAR(20) NULL
);
GO

-- 3. Задача: Добавить в таблицу 5-7 произвольных записей о студентах.
INSERT INTO Students (FirstName, LastName, BirthDate, Email, GroupName)
VALUES
    ('Иван', 'Иванов', '2000-05-15', 'ivanov@example.com', 'ПИ-101'),
    ('Петр', 'Петров', '2001-12-03', 'petrov@example.com', 'ПИ-101'),
    ('Мария', 'Сидорова', '2000-08-21', 'sidorova@example.com', 'ПИ-101'),
    ('Анна', 'Кузнецова', '2002-03-10', 'kuznetsova@example.com', 'ИВТ-102'),
    ('Сергей', 'Смирнов', '1999-11-25', 'smirnov@example.com', 'ИВТ-102'),
    ('Ольга', 'Попова', '2000-07-30', 'popova@example.com', 'ПИ-101');

-- Посмотрим, что получилось
SELECT * FROM Students;

-- 4. Задача: Вывести всех студентов из группы "ПИ-101".
SELECT *
FROM Students
WHERE GroupName = 'ПИ-101';

-- 5. Задача: Студент Петр Петров перешел в группу "ПИ-102". Изменить его данные.
UPDATE Students
SET GroupName = 'ПИ-102'
WHERE FirstName = 'Петр' AND LastName = 'Петров'; -- Важно точно идентифицировать запись!

-- Проверим изменение
SELECT * FROM Students WHERE LastName = 'Петров';

-- 6. Задача: Студент Сергей Смирнов отчислился. Удалить его запись.
DELETE FROM Students
WHERE FirstName = 'Сергей' AND LastName = 'Смирнов';

-- Проверим результат
SELECT * FROM Students;