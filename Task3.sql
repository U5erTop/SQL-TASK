-- ������� 3: ���������� �������
-- ����: ��������� ������������ ������ � �������� � ������������.

USE tempdb;
GO

-- ������� � ��������� ������� Sales
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
    ('������� Lenovo', '2023-10-01', 55000.00, '�����������'),
    ('���� Logitech', '2023-10-01', 2500.50, '�����������'),
    ('����� "SQL �� 10 �����"', '2023-10-02', 1500.00, '�����'),
    ('�������� Sony', '2023-10-02', 12000.00, '�����������'),
    ('����� "������� Python"', '2023-10-03', 2000.00, '�����'),
    ('���������', '2023-10-04', 8000.00, '������� �������'),
    ('������', '2023-10-04', 3000.00, '������� �������'),
    ('������� Samsung', '2023-10-05', 30000.00, '�����������');

-- 1. ������: ��������� ����� ����� ���� ������.
SELECT SUM(Amount) AS TotalRevenue
FROM Sales;

-- 2. ������: ����� ������� ����� �������.
SELECT AVG(Amount) AS AverageCheck
FROM Sales;

-- 3. ������: ��������� ���������� ������ � ������ ��������� �������.
SELECT Category, COUNT(*) AS SalesCount -- COUNT(*) ������� ���������� �����
FROM Sales
GROUP BY Category; -- ���������� �� ����������

-- 4. ������: ������� ��������� �������, � ������� ����� ����� ������ ��������� 10 000 ������.
SELECT Category, SUM(Amount) AS TotalCategoryRevenue
FROM Sales
GROUP BY Category
HAVING SUM(Amount) > 10000; -- HAVING ��������� ���������� �����������

-- 5. ������: ����� ���� � ������������ ����� ������ ������.
SELECT TOP(1) SaleDate, SUM(Amount) AS DailyRevenue
FROM Sales
GROUP BY SaleDate
ORDER BY DailyRevenue DESC; -- ��������� �� ������� �� �������� � ����� ������ ������