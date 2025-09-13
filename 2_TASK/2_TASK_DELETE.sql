-- 🗑️ ЗАДАНИЕ 5: УДАЛЕНИЕ ДАННЫХ (DELETE)
-- Цель: Научиться удалять данные с учетом ограничений целостности.

-- 5.1. Удалить отмененный проект
DELETE FROM Projects
WHERE Status = 'Cancelled';

-- 5.2. Удалить сотрудника, который уволился
-- Сначала проверяем, есть ли такой сотрудник
SELECT * FROM Employees 
WHERE FirstName = 'Сергей' AND LastName = 'Попов';

-- Затем удаляем (если он существует)
DELETE FROM Employees
WHERE FirstName = 'Сергей' AND LastName = 'Попов';

-- 5.3. Удалить отдел, если в нем нет сотрудников
-- Попытка удалить отдел с сотрудниками вызовет ошибку из-за внешнего ключа
BEGIN TRY
    DELETE FROM Departments 
    WHERE DepartmentName = 'HR';
END TRY
BEGIN CATCH
    PRINT 'Нельзя удалить отдел, так как в нем есть сотрудники!';
END CATCH;

-- 5.4. Удалить все завершенные проекты
DELETE FROM Projects
WHERE Status = 'Completed';

-- 5.5. Безопасное удаление: сначала деактивируем сотрудника, потом удаляем
UPDATE Employees SET IsActive = 0 WHERE EmployeeID = 5;
-- ... через некоторое время ...
DELETE FROM Employees WHERE IsActive = 0;

-- 5.6. Проверяем оставшиеся данные
SELECT 
    (SELECT COUNT(*) FROM Employees) AS EmployeesCount,
    (SELECT COUNT(*) FROM Departments) AS DepartmentsCount,
    (SELECT COUNT(*) FROM Projects) AS ProjectsCount;