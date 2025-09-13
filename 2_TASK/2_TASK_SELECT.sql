-- 👀 ЗАДАНИЕ 3: ЧТЕНИЕ ДАННЫХ (SELECT)
-- Цель: Научиться извлекать и фильтровать данные.

-- 3.1. Вывести всех сотрудников
SELECT * FROM Employees;

-- 3.2. Вывести имя, фамилию и зарплату сотрудников
SELECT 
    FirstName,
    LastName, 
    Salary
FROM Employees;

-- 3.3. Вывести сотрудников с зарплатой больше 70000
SELECT 
    FirstName + ' ' + LastName AS FullName,
    Salary,
    HireDate
FROM Employees
WHERE Salary > 70000
ORDER BY Salary DESC;

-- 3.4. Вывести сотрудников IT отдела
SELECT 
    e.FirstName,
    e.LastName,
    e.Salary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';

-- 3.5. Вывести количество сотрудников в каждом отделе
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.Salary) AS AverageSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;

-- 3.6. Вывести активные проекты
SELECT 
    ProjectName,
    StartDate,
    EndDate,
    Budget,
    Status
FROM Projects
WHERE Status = 'Active' AND EndDate IS NOT NULL;