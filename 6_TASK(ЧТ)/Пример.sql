
-- =================================================================
-- ПРИМЕР РЕАЛИЗАЦИИ: Предметная область "Университет"
-- Домашнее задание: Вложенные запросы и курсоры в T-SQL  
-- =================================================================

-- Создание базы данных
CREATE DATABASE UniversityDB;
USE UniversityDB;

-- =================================================================
-- СОЗДАНИЕ ТАБЛИЦ
-- =================================================================

-- Справочные таблицы
CREATE TABLE Faculties (
    FacultyID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyName NVARCHAR(100) NOT NULL,
    DeanName NVARCHAR(100),
    EstablishedYear INT
);

CREATE TABLE Specializations (
    SpecializationID INT IDENTITY(1,1) PRIMARY KEY,
    SpecializationName NVARCHAR(100) NOT NULL,
    FacultyID INT FOREIGN KEY REFERENCES Faculties(FacultyID),
    Duration INT, -- в семестрах
    Credits INT
);

CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL,
    Credits INT,
    Description NVARCHAR(500)
);

-- Основные сущности
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    SpecializationID INT FOREIGN KEY REFERENCES Specializations(SpecializationID),
    EnrollmentDate DATE,
    GraduationDate DATE,
    Status NVARCHAR(20) CHECK (Status IN ('Active', 'Graduated', 'Expelled', 'Academic Leave'))
);

CREATE TABLE Teachers (
    TeacherID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    HireDate DATE,
    Position NVARCHAR(50),
    Salary DECIMAL(10,2),
    FacultyID INT FOREIGN KEY REFERENCES Faculties(FacultyID)
);

-- Связующие таблицы
CREATE TABLE TeacherSubjects (
    TeacherID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
    SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    Semester INT,
    AcademicYear INT,
    PRIMARY KEY (TeacherID, SubjectID, Semester, AcademicYear)
);

-- Транзакционные таблицы
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    TeacherID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
    Grade DECIMAL(3,1) CHECK (Grade BETWEEN 0 AND 5),
    ExamDate DATE,
    ExamType NVARCHAR(20) CHECK (ExamType IN ('Exam', 'Test', 'Coursework', 'Laboratory')),
    Semester INT,
    AcademicYear INT
);

-- =================================================================
-- ЗАПОЛНЕНИЕ ТЕСТОВЫМИ ДАННЫМИ
-- =================================================================

-- Факультеты
INSERT INTO Faculties (FacultyName, DeanName, EstablishedYear) VALUES
('Информационных технологий', 'Петров А.И.', 1995),
('Экономический', 'Сидорова М.П.', 1985),
('Юридический', 'Козлов В.С.', 1990),
('Медицинский', 'Иванова Е.В.', 1970);

-- Специализации
INSERT INTO Specializations (SpecializationName, FacultyID, Duration, Credits) VALUES
('Программная инженерия', 1, 8, 240),
('Информационная безопасность', 1, 8, 240),
('Экономика предприятия', 2, 8, 220),
('Банковское дело', 2, 8, 220),
('Гражданское право', 3, 10, 300),
('Лечебное дело', 4, 12, 360);

-- Предметы  
INSERT INTO Subjects (SubjectName, Credits, Description) VALUES
('Основы программирования', 6, 'Изучение базовых концепций программирования'),
('Базы данных', 5, 'Проектирование и администрирование БД'),
('Математический анализ', 8, 'Дифференциальное и интегральное исчисление'),
('Микроэкономика', 4, 'Основы рыночной экономики'),
('Конституционное право', 5, 'Основы конституционного строя'),
('Анатомия человека', 7, 'Строение человеческого тела'),
('Английский язык', 3, 'Иностранный язык для профессионального общения'),
('Философия', 3, 'Основы философских знаний'),
('Физическая культура', 2, 'Физическое развитие студентов'),
('История', 3, 'История России и всеобщая история');

-- =================================================================
-- ПРИМЕРЫ ВЛОЖЕННЫХ ЗАПРОСОВ
-- =================================================================

-- 1. СКАЛЯРНЫЙ ПОДЗАПРОС
-- Найти студентов со средним баллом выше общего среднего по университету
SELECT 
    s.FirstName,
    s.LastName,
    sp.SpecializationName,
    (SELECT AVG(CAST(g2.Grade AS FLOAT)) 
     FROM Grades g2 
     WHERE g2.StudentID = s.StudentID) AS AvgGrade
FROM Students s
JOIN Specializations sp ON s.SpecializationID = sp.SpecializationID
WHERE (SELECT AVG(CAST(g.Grade AS FLOAT)) 
       FROM Grades g 
       WHERE g.StudentID = s.StudentID) > 
      (SELECT AVG(CAST(Grade AS FLOAT)) FROM Grades)
ORDER BY AvgGrade DESC;

-- 2. ТАБЛИЧНЫЙ ПОДЗАПРОС С IN
-- Найти преподавателей, которые ведут предметы с кредитами больше 5
SELECT DISTINCT
    t.FirstName,
    t.LastName,
    t.Position,
    f.FacultyName
FROM Teachers t
JOIN Faculties f ON t.FacultyID = f.FacultyID
WHERE t.TeacherID IN (
    SELECT ts.TeacherID
    FROM TeacherSubjects ts
    JOIN Subjects s ON ts.SubjectID = s.SubjectID
    WHERE s.Credits > 5
);

-- 3. КОРРЕЛИРОВАННЫЙ ПОДЗАПРОС  
-- Найти студентов с оценками выше среднего по их специализации
SELECT 
    s.FirstName,
    s.LastName,
    sp.SpecializationName,
    g.Grade
FROM Students s
JOIN Specializations sp ON s.SpecializationID = sp.SpecializationID
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.Grade > (
    SELECT AVG(CAST(g2.Grade AS FLOAT))
    FROM Grades g2
    JOIN Students s2 ON g2.StudentID = s2.StudentID
    WHERE s2.SpecializationID = s.SpecializationID
);

-- 4. EXISTS - студенты, которые имеют оценки по математическим дисциплинам
SELECT DISTINCT
    s.FirstName,
    s.LastName,
    s.Email
FROM Students s
WHERE EXISTS (
    SELECT 1
    FROM Grades g
    JOIN Subjects sub ON g.SubjectID = sub.SubjectID
    WHERE g.StudentID = s.StudentID 
    AND sub.SubjectName LIKE '%математ%'
);

-- =================================================================
-- ПРИМЕРЫ КУРСОРОВ
-- =================================================================

-- 1. ПРОСТОЙ КУРСОР - вывод информации о студентах и их средних оценках
DECLARE @StudentID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @AvgGrade FLOAT;

DECLARE student_cursor CURSOR FOR
SELECT 
    s.StudentID,
    s.FirstName, 
    s.LastName,
    AVG(CAST(g.Grade AS FLOAT)) AS AvgGrade
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
WHERE s.Status = 'Active'
GROUP BY s.StudentID, s.FirstName, s.LastName
ORDER BY s.LastName;

OPEN student_cursor;

FETCH NEXT FROM student_cursor INTO @StudentID, @FirstName, @LastName, @AvgGrade;

PRINT 'ОТЧЕТ О СРЕДНИХ ОЦЕНКАХ СТУДЕНТОВ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @AvgGrade IS NULL
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@StudentID AS VARCHAR) + ') - Нет оценок';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@StudentID AS VARCHAR) + 
              ') - Средний балл: ' + CAST(ROUND(@AvgGrade, 2) AS VARCHAR);

    FETCH NEXT FROM student_cursor INTO @StudentID, @FirstName, @LastName, @AvgGrade;
END;

CLOSE student_cursor;
DEALLOCATE student_cursor;

-- 2. ВЛОЖЕННЫЕ КУРСОРЫ - для каждой специализации показать всех студентов
DECLARE @SpecID INT, @SpecName NVARCHAR(100);
DECLARE @StFirstName NVARCHAR(50), @StLastName NVARCHAR(50), @StEmail NVARCHAR(100);

-- Внешний курсор по специализациям
DECLARE spec_cursor CURSOR FOR
SELECT SpecializationID, SpecializationName
FROM Specializations
ORDER BY SpecializationName;

OPEN spec_cursor;
FETCH NEXT FROM spec_cursor INTO @SpecID, @SpecName;

PRINT 'СТУДЕНТЫ ПО СПЕЦИАЛИЗАЦИЯМ';
PRINT '===========================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'СПЕЦИАЛИЗАЦИЯ: ' + @SpecName;
    PRINT '----------------------------------------';

    -- Внутренний курсор по студентам специализации
    DECLARE student_spec_cursor CURSOR LOCAL FOR
    SELECT FirstName, LastName, Email
    FROM Students
    WHERE SpecializationID = @SpecID AND Status = 'Active'
    ORDER BY LastName;

    OPEN student_spec_cursor;
    FETCH NEXT FROM student_spec_cursor INTO @StFirstName, @StLastName, @StEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет активных студентов';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @StLastName + ' ' + @StFirstName + ' - ' + ISNULL(@StEmail, 'Нет email');
        FETCH NEXT FROM student_spec_cursor INTO @StFirstName, @StLastName, @StEmail;
    END;

    CLOSE student_spec_cursor;
    DEALLOCATE student_spec_cursor;

    FETCH NEXT FROM spec_cursor INTO @SpecID, @SpecName;
END;

CLOSE spec_cursor;
DEALLOCATE spec_cursor;

-- 3. КУРСОР С ОБНОВЛЕНИЕМ ДАННЫХ - обновление статуса студентов
DECLARE @StudID INT, @GradDate DATE;

DECLARE graduation_cursor CURSOR FOR
SELECT StudentID, GraduationDate
FROM Students
WHERE Status = 'Active' AND GraduationDate <= GETDATE();

OPEN graduation_cursor;
FETCH NEXT FROM graduation_cursor INTO @StudID, @GradDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСОВ ВЫПУСКНИКОВ';
PRINT '================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Students
    SET Status = 'Graduated'
    WHERE StudentID = @StudID;

    PRINT 'Студент ID ' + CAST(@StudID AS VARCHAR) + ' - статус изменен на "Graduated"';

    FETCH NEXT FROM graduation_cursor INTO @StudID, @GradDate;
END;

CLOSE graduation_cursor;
DEALLOCATE graduation_cursor;

PRINT 'Обновление завершено.';

-- =================================================================
-- СОЗДАНИЕ ИНДЕКСОВ ДЛЯ ОПТИМИЗАЦИИ
-- =================================================================

CREATE INDEX IX_Students_SpecializationID ON Students(SpecializationID);
CREATE INDEX IX_Students_Status ON Students(Status);
CREATE INDEX IX_Grades_StudentID ON Grades(StudentID);
CREATE INDEX IX_Grades_SubjectID ON Grades(SubjectID);
CREATE INDEX IX_Grades_Grade ON Grades(Grade);
CREATE INDEX IX_TeacherSubjects_TeacherID ON TeacherSubjects(TeacherID);

-- =================================================================
-- АНАЛИЗ ПРОИЗВОДИТЕЛЬНОСТИ
-- =================================================================

-- Включение отображения плана выполнения
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Сравнение курсора vs set-based операции
-- Курсор (медленно)
DECLARE @Count1 INT = 0;
DECLARE grade_cursor CURSOR FOR SELECT Grade FROM Grades WHERE Grade >= 4.0;
OPEN grade_cursor;
FETCH NEXT FROM grade_cursor INTO @StudID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM grade_cursor INTO @StudID;
END;
CLOSE grade_cursor;
DEALLOCATE grade_cursor;

PRINT 'Курсор - количество хороших оценок: ' + CAST(@Count1 AS VARCHAR);

-- Set-based операция (быстро)
DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Grades WHERE Grade >= 4.0;
PRINT 'Set-based - количество хороших оценок: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
