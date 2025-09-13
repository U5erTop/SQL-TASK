-- 🎯 ЗАДАНИЕ 6: КОМПЛЕКСНЫЕ CRUD-ОПЕРАЦИИ
-- Цель: Закрепить навыки работы с CRUD операциями.

-- 6.1. Добавить новый отдел и сразу нанять в него сотрудника
BEGIN TRANSACTION;

INSERT INTO Departments (DepartmentName, Location, Budget)
VALUES ('Research & Development', '6 этаж', 450000.00);

DECLARE @NewDeptID INT = SCOPE_IDENTITY();

INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, Salary, DepartmentID)
VALUES ('Анна', 'Новикова', 'novikova@company.com', '+7(999)678-90-12', GETDATE(), 78000.00, @NewDeptID);

COMMIT TRANSACTION;

-- 6.2. Массовое обновление зарплат по отделам
UPDATE Employees
SET Salary = 
    CASE 
        WHEN DepartmentID = 1 THEN Salary * 1.15 -- IT +15%
        WHEN DepartmentID = 5 THEN Salary * 1.10 -- Sales +10%
        ELSE Salary * 1.05 -- Все остальные +5%
    END;

-- 6.3. Удалить неактивных сотрудников и проекты без ответственных
-- Сначала находим ID отделов, которые будут удалены
SELECT DepartmentID 
INTO #DeptsToDelete
FROM Departments 
WHERE DepartmentName IN ('Temp Department', 'Old Department');

-- Удаляем сотрудников этих отделов
DELETE FROM Employees 
WHERE DepartmentID IN (SELECT DepartmentID FROM #DeptsToDelete);

-- Удаляем отделы
DELETE FROM Departments 
WHERE DepartmentID IN (SELECT DepartmentID FROM #DeptsToDelete);

-- Очищаем временную таблицу
DROP TABLE #DeptsToDelete;

-- 6.4. Копирование данных: создать архив завершенных проектов
SELECT *
INTO ProjectsArchive
FROM Projects
WHERE Status = 'Completed';

-- 6.5. Обновить несколько записей одним запросом на основе условия
UPDATE Projects
SET 
    Status = 'On Hold',
    Budget = Budget * 0.9 -- Уменьшаем бюджет на 10%
WHERE EndDate IS NULL AND DATEDIFF(MONTH, StartDate, GETDATE()) > 6;

-- 6.6. Финальная проверка всех данных
SELECT 
    'Employees' AS TableName, 
    COUNT(*) AS RecordCount 
FROM Employees
UNION ALL
SELECT 'Departments', COUNT(*) FROM Departments
UNION ALL
SELECT 'Projects', COUNT(*) FROM Projects
UNION ALL
SELECT 'ProjectsArchive', COUNT(*) FROM ProjectsArchive;