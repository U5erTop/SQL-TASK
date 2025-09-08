-- ЗАДАНИЕ 3: АГРЕГАТНЫЕ ФУНКЦИИ
-- Цель: Научиться агрегировать данные и работать с группировкой.

USE tempdb;
GO

-- Создаем и заполняем таблицу Sales
IF OBJECT_ID('Sales', 'U') IS NOT NULL
    DROP TABLE Sales;

CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Category NVARCHAR(20) NOT NULL
);

INSERT INTO Sales (ProductName, SaleDate, Amount, Category)
VALUES
    ('Ноутбук Lenovo', '2023-10-01', 55000.00, 'Электроника'),
    ('Мышь Logitech', '2023-10-01', 2500.50, 'Электроника'),
    ('Книга "SQL за 10 минут"', '2023-10-02', 1500.00, 'Книги'),
    ('Наушники Sony', '2023-10-02', 12000.00, 'Электроника'),
    ('Книга "Изучаем Python"', '2023-10-03', 2000.00, 'Книги'),
    ('Кофеварка', '2023-10-04', 8000.00, 'Бытовая техника'),
    ('Чайник', '2023-10-04', 3000.00, 'Бытовая техника'),
    ('Монитор Samsung', '2023-10-05', 30000.00, 'Электроника');

-- 1. Задача: Посчитать общую сумму всех продаж.
SELECT SUM(Amount) AS TotalRevenue
FROM Sales;

-- 2. Задача: Найти среднюю сумму продажи.
SELECT AVG(Amount) AS AverageCheck
FROM Sales;

-- 3. Задача: Посчитать количество продаж в каждой категории товаров.
SELECT Category, COUNT(*) AS SalesCount -- COUNT(*) считает количество строк
FROM Sales
GROUP BY Category; -- Группируем по категориям

-- 4. Задача: Вывести категории товаров, у которых общая сумма продаж превышает 10 000 рублей.
SELECT Category, SUM(Amount) AS TotalCategoryRevenue
FROM Sales
GROUP BY Category
HAVING SUM(Amount) > 10000; -- HAVING фильтрует результаты группировки

-- 5. Задача: Найти день с максимальной общей суммой продаж.
SELECT TOP(1) SaleDate, SUM(Amount) AS DailyRevenue
FROM Sales
GROUP BY SaleDate
ORDER BY DailyRevenue DESC; -- Сортируем по выручке по убыванию и берем первую запись