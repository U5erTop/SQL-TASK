-- 📝 ЗАДАНИЕ 2: ДОБАВЛЕНИЕ ДАННЫХ (INSERT)
-- Цель: Научиться добавлять данные в таблицы.

-- 2.1. Добавляем отделы в таблицу Departments
INSERT INTO Departments (DepartmentName, Location, Budget)
VALUES
    ('IT', '3 этаж', 500000.00),
    ('HR', '2 этаж', 250000.00),
    ('Finance', '1 этаж', 400000.00),
    ('Marketing', '4 этаж', 350000.00),
    ('Sales', '5 этаж', 600000.00);

-- 2.2. Добавляем сотрудников в таблицу Employees
INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, Salary, DepartmentID)
VALUES
    ('Иван', 'Иванов', 'ivanov@company.com', '+7(999)123-45-67', '2020-01-15', 75000.00, 1),
    ('Мария', 'Петрова', 'petrova@company.com', '+7(999)234-56-78', '2019-03-10', 82000.00, 2),
    ('Алексей', 'Сидоров', 'sidorov@company.com', '+7(999)345-67-89', '2021-05-20', 68000.00, 1),
    ('Ольга', 'Кузнецова', 'kuznetsova@company.com', NULL, '2018-11-05', 95000.00, 3),
    ('Дмитрий', 'Смирнов', 'smirnov@company.com', '+7(999)456-78-90', '2022-02-28', 55000.00, 5),
    ('Екатерина', 'Васильева', 'vasilieva@company.com', '+7(999)567-89-01', '2020-07-15', 72000.00, 4),
    ('Сергей', 'Попов', 'popov@company.com', NULL, '2023-01-10', 48000.00, NULL);

-- 2.3. Добавляем проекты в таблицу Projects
INSERT INTO Projects (ProjectName, StartDate, EndDate, Budget, Status)
VALUES
    ('Разработка нового сайта', '2023-01-15', '2023-06-30', 200000.00, 'Active'),
    ('Автоматизация отчетности', '2023-02-01', '2023-08-15', 150000.00, 'Active'),
    ('Ребрендинг компании', '2022-11-01', '2023-03-31', 300000.00, 'Completed'),
    ('Внедрение CRM системы', '2023-03-01', NULL, 250000.00, 'On Hold'),
    ('Исследование рынка', '2023-04-10', '2023-05-31', 80000.00, 'Active');

-- 2.4. Проверяем добавленные данные
SELECT 'Departments' AS TableName, COUNT(*) AS RowCount FROM Departments
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects;