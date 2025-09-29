-- ПРИМЕР РЕАЛИЗАЦИИ ДОМАШНЕГО ЗАДАНИЯ
-- Предметная область: Интернет-магазин электроники

-- =============================================
-- СОЗДАНИЕ СТРУКТУРЫ БАЗЫ ДАННЫХ
-- =============================================

-- Создание таблицы категорий товаров
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500)
);

-- Создание таблицы поставщиков
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    City NVARCHAR(50)
);

-- Создание таблицы товаров
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10,2) NOT NULL,
    UnitsInStock INT DEFAULT 0,
    Description NVARCHAR(500),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Создание таблицы клиентов
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    City NVARCHAR(50),
    RegistrationDate DATETIME DEFAULT GETDATE()
);

-- Создание таблицы заказов
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Создание таблицы деталей заказов
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- =============================================
-- ЗАПОЛНЕНИЕ ТЕСТОВЫМИ ДАННЫМИ
-- =============================================

-- Заполнение категорий
INSERT INTO Categories (CategoryName, Description) VALUES
('Смартфоны', 'Мобильные телефоны и аксессуары'),
('Ноутбуки', 'Портативные компьютеры'),
('Планшеты', 'Планшетные компьютеры'),
('Наушники', 'Аудио устройства'),
('Игровые консоли', 'Игровые приставки');

-- Заполнение поставщиков
INSERT INTO Suppliers (CompanyName, ContactName, Phone, Email, City) VALUES
('TechSupply Ltd', 'Иван Петров', '+7-495-123-4567', 'ivan@techsupply.ru', 'Москва'),
('ElectroWorld', 'Анна Сидорова', '+7-812-987-6543', 'anna@electroworld.ru', 'СПб'),
('GadgetPro', 'Петр Козлов', '+7-495-555-0123', 'petr@gadgetpro.ru', 'Москва'),
('MegaTech', 'Елена Смирнова', '+7-495-777-8888', 'elena@megatech.ru', 'Москва');

-- Заполнение товаров
INSERT INTO Products (ProductName, CategoryID, SupplierID, Price, UnitsInStock, Description) VALUES
('iPhone 15 Pro', 1, 1, 89990.00, 15, 'Флагманский смартфон Apple'),
('Samsung Galaxy S24', 1, 2, 79990.00, 20, 'Флагманский смартфон Samsung'),
('MacBook Air M2', 2, 1, 119990.00, 8, 'Ультрабук Apple с процессором M2'),
('Dell XPS 13', 2, 3, 99990.00, 12, 'Премиальный ультрабук Dell'),
('iPad Air', 3, 1, 59990.00, 25, 'Планшет Apple среднего класса'),
('AirPods Pro', 4, 1, 24990.00, 50, 'Беспроводные наушники Apple'),
('Sony WH-1000XM5', 4, 4, 29990.00, 30, 'Премиальные наушники с шумоподавлением'),
('PlayStation 5', 5, 4, 54990.00, 5, 'Игровая консоль Sony');

-- Заполнение клиентов
INSERT INTO Customers (FirstName, LastName, Email, Phone, City) VALUES
('Алексей', 'Иванов', 'alexey.ivanov@email.com', '+7-915-123-4567', 'Москва'),
('Мария', 'Петрова', 'maria.petrova@email.com', '+7-921-987-6543', 'СПб'),
('Дмитрий', 'Сидоров', 'dmitry.sidorov@email.com', '+7-916-555-0123', 'Москва'),
('Анна', 'Козлова', 'anna.kozlova@email.com', '+7-495-777-8888', 'Екатеринбург'),
('Сергей', 'Смирнов', 'sergey.smirnov@email.com', '+7-903-111-2222', 'Новосибирск');

-- Заполнение заказов
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Status) VALUES
(1, '2024-01-15', 89990.00, 'Completed'),
(2, '2024-01-16', 139980.00, 'Completed'),
(3, '2024-01-17', 119990.00, 'Pending'),
(1, '2024-01-18', 84980.00, 'Completed'),
(4, '2024-01-19', 54990.00, 'Processing');

-- Заполнение деталей заказов
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 89990.00),
(2, 2, 1, 79990.00),
(2, 6, 2, 24990.00),
(2, 5, 1, 59990.00),
(3, 3, 1, 119990.00),
(4, 6, 1, 24990.00),
(4, 7, 2, 29990.00),
(5, 8, 1, 54990.00);

-- =============================================
-- ЭТАП 1: БАЗОВЫЕ ЗАДАНИЯ (INNER JOIN)
-- =============================================

-- Задание 1.1: Вывести все товары с названиями категорий
SELECT p.ProductName, c.CategoryName, p.Price
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;

-- Задание 1.2: Показать товары с информацией о поставщиках
SELECT p.ProductName, s.CompanyName, s.City, p.Price
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- Задание 1.3: Вывести заказы с именами клиентов
SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, 
       o.OrderDate, o.TotalAmount, o.Status
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- =============================================
-- ЭТАП 2: LEFT JOIN ЗАДАНИЯ
-- =============================================

-- Задание 2.1: Показать все категории и количество товаров в каждой
SELECT c.CategoryName, COUNT(p.ProductID) as ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- Задание 2.2: Вывести всех клиентов и их заказы (включая клиентов без заказов)
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, 
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.LastName;

-- =============================================
-- ЭТАП 3: RIGHT JOIN ЗАДАНИЯ
-- =============================================

-- Задание 3.1: Показать все товары и их заказы (включая товары, которые не заказывали)
SELECT p.ProductName, od.Quantity, od.UnitPrice, o.OrderDate
FROM OrderDetails od
RIGHT JOIN Products p ON od.ProductID = p.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
ORDER BY p.ProductName;

-- =============================================
-- ЭТАП 4: FULL OUTER JOIN ЗАДАНИЯ
-- =============================================

-- Задание 4.1: Полное соединение поставщиков и городов клиентов
SELECT COALESCE(s.City, c.City) as City,
       COUNT(DISTINCT s.SupplierID) as SuppliersCount,
       COUNT(DISTINCT c.CustomerID) as CustomersCount
FROM Suppliers s
FULL OUTER JOIN Customers c ON s.City = c.City
GROUP BY COALESCE(s.City, c.City);

-- =============================================
-- ЭТАП 5: МНОЖЕСТВЕННЫЕ JOIN
-- =============================================

-- Задание 5.1: Полная информация о заказах
SELECT 
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.ProductName,
    cat.CategoryName,
    sup.CompanyName as SupplierName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice as LineTotal,
    o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
INNER JOIN Suppliers sup ON p.SupplierID = sup.SupplierID
ORDER BY o.OrderID, od.OrderDetailID;

-- Задание 5.2: Топ-5 самых покупаемых товаров
SELECT TOP 5
    p.ProductName,
    cat.CategoryName,
    SUM(od.Quantity) as TotalSold,
    SUM(od.Quantity * od.UnitPrice) as TotalRevenue
FROM Products p
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, cat.CategoryName
ORDER BY TotalSold DESC;

-- =============================================
-- ЭТАП 6: САМОСОЕДИНЕНИЕ (SELF JOIN)
-- =============================================

-- Задание 6.1: Найти клиентов из одного города
SELECT 
    c1.FirstName + ' ' + c1.LastName AS Customer1,
    c2.FirstName + ' ' + c2.LastName AS Customer2,
    c1.City
FROM Customers c1
INNER JOIN Customers c2 ON c1.City = c2.City AND c1.CustomerID < c2.CustomerID
ORDER BY c1.City;

-- =============================================
-- ЭТАП 7: АГРЕГАТНЫЕ ФУНКЦИИ С JOIN
-- =============================================

-- Задание 7.1: Статистика по поставщикам
SELECT 
    s.CompanyName,
    COUNT(p.ProductID) as ProductsCount,
    AVG(p.Price) as AvgPrice,
    SUM(ISNULL(od.Quantity, 0)) as TotalSold
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.CompanyName
ORDER BY TotalSold DESC;

-- Задание 7.2: Анализ продаж по месяцам
SELECT 
    YEAR(o.OrderDate) as OrderYear,
    MONTH(o.OrderDate) as OrderMonth,
    COUNT(DISTINCT o.OrderID) as OrdersCount,
    COUNT(DISTINCT o.CustomerID) as UniqueCustomers,
    SUM(od.Quantity * od.UnitPrice) as TotalRevenue
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY OrderYear, OrderMonth;