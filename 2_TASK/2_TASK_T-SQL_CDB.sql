-- 🗃️ ЗАДАНИЕ 1: СОЗДАНИЕ БАЗЫ ДАННЫХ И ТАБЛИЦ
-- Цель: Научиться создавать базу данных и таблицы с различными ограничениями.

-- 1.1. Создаем новую базу данных "CompanyDB"
-- Если база уже существует - удаляем её
USE master;
GO

IF DB_ID('CompanyDB') IS NOT NULL
    DROP DATABASE CompanyDB;
GO

CREATE DATABASE CompanyDB;
GO

-- Переключаемся на созданную базу данных
USE CompanyDB;
GO

-- 1.2. Создаем таблицу Departments (Отделы)
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL,
    Location NVARCHAR(100) NULL,
    Budget DECIMAL(15,2) DEFAULT 0.00,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- 1.3. Создаем таблицу Employees (Сотрудники) с внешним ключом
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20) NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary >= 0),
    DepartmentID INT NULL,
    IsActive BIT DEFAULT 1,
    
    -- Внешний ключ на таблицу Departments
    CONSTRAINT FK_Employees_Departments 
        FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
        ON DELETE SET NULL
);
GO

-- 1.4. Создаем таблицу Projects (Проекты)
CREATE TABLE Projects (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Budget DECIMAL(15,2) NULL,
    Status NVARCHAR(20) DEFAULT 'Active' 
        CHECK (Status IN ('Active', 'Completed', 'On Hold', 'Cancelled'))
);
GO

-- 1.5. Проверяем создание таблиц
SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';