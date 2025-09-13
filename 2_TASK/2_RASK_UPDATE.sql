-- 🔄 ЗАДАНИЕ 4: ОБНОВЛЕНИЕ ДАННЫХ (UPDATE)
-- Цель: Научиться изменять существующие данные.

-- 4.1. Повысить зарплату всем сотрудникам IT отдела на 10%
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'IT');

-- Проверяем изменение
SELECT * FROM Employees WHERE DepartmentID = 1;

-- 4.2. Изменить статус завершенного проекта
UPDATE Projects
SET Status = 'Completed', EndDate = GETDATE()
WHERE ProjectName = 'Ребрендинг компании' AND Status = 'Active';

-- 4.3. Назначить сотрудника без отдела в отдел Marketing
UPDATE Employees
SET DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Marketing')
WHERE DepartmentID IS NULL;

-- 4.4. Увеличить бюджет отделу Sales на 50000
UPDATE Departments
SET Budget = Budget + 50000.00
WHERE DepartmentName = 'Sales';

-- 4.5. Обновить email сотрудника (важно использовать уникальный email)
UPDATE Employees
SET Email = 'ivanov.new@company.com'
WHERE FirstName = 'Иван' AND LastName = 'Иванов';

-- 4.6. Перевести сотрудника в другой отдел
UPDATE Employees
SET DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Finance')
WHERE FirstName = 'Мария' AND LastName = 'Петрова';