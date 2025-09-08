-- ������� 2: �������� � �������
-- ����: ��������� ��������� �������, ���������, �������� � ������� ������.

-- 1. ������� ���� ������ ��� ������������ (���� � ���)
-- IF NOT EXISTS �������� ������� � SQL Server 2016
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'University')
CREATE DATABASE University;
GO -- ��������� GO ��������� ������� ����� ������ � ��������� ���

-- ����������� �������� �� ��������� ���� ������
USE University;
GO

-- 2. ������� ������� Students, ���� ��� �� ����������
IF OBJECT_ID('Students', 'U') IS NOT NULL
    DROP TABLE Students;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1), -- ��������� ����, ������������� (1, 2, 3...)
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE NULL,
    Email NVARCHAR(100) NULL,
    GroupName NVARCHAR(20) NULL
);
GO

-- 3. ������: �������� � ������� 5-7 ������������ ������� � ���������.
INSERT INTO Students (FirstName, LastName, BirthDate, Email, GroupName)
VALUES
    ('����', '������', '2000-05-15', 'ivanov@example.com', '��-101'),
    ('����', '������', '2001-12-03', 'petrov@example.com', '��-101'),
    ('�����', '��������', '2000-08-21', 'sidorova@example.com', '��-101'),
    ('����', '���������', '2002-03-10', 'kuznetsova@example.com', '���-102'),
    ('������', '�������', '1999-11-25', 'smirnov@example.com', '���-102'),
    ('�����', '������', '2000-07-30', 'popova@example.com', '��-101');

-- ���������, ��� ����������
SELECT * FROM Students;

-- 4. ������: ������� ���� ��������� �� ������ "��-101".
SELECT *
FROM Students
WHERE GroupName = '��-101';

-- 5. ������: ������� ���� ������ ������� � ������ "��-102". �������� ��� ������.
UPDATE Students
SET GroupName = '��-102'
WHERE FirstName = '����' AND LastName = '������'; -- ����� ����� ���������������� ������!

-- �������� ���������
SELECT * FROM Students WHERE LastName = '������';

-- 6. ������: ������� ������ ������� ����������. ������� ��� ������.
DELETE FROM Students
WHERE FirstName = '������' AND LastName = '�������';

-- �������� ���������
SELECT * FROM Students;