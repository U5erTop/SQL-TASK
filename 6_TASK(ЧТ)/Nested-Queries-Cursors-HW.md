# Домашнее задание: Вложенные запросы и курсоры в T-SQL

## Цель работы
Изучить и практически применить технологии работы с вложенными запросами (subqueries) и курсорами в T-SQL для обработки данных в различных предметных областях.

## Поэтапное задание

### Этап 1: Теоретическая подготовка
1. Изучить виды вложенных запросов:
   - Скалярные подзапросы
   - Табличные подзапросы  
   - Коррелированные подзапросы
   - EXISTS/NOT EXISTS
   
2. Изучить работу с курсорами:
   - DECLARE CURSOR
   - OPEN/CLOSE
   - FETCH NEXT/PRIOR/FIRST/LAST
   - @@FETCH_STATUS
   - Вложенные курсоры

### Этап 2: Создание базы данных 
1. Выбрать предметную область из списка (см. файл README.md)
2. Создать базу данных с минимум 5 взаимосвязанными таблицами
3. Заполнить таблицы тестовыми данными (минимум 50 записей в главной таблице)
4. Создать индексы для оптимизации запросов

### Этап 3: Реализация вложенных запросов
Написать и выполнить следующие типы запросов:

1. **Скалярный подзапрос** - найти записи со значением выше/ниже среднего
   ```sql
   SELECT * FROM table1 
   WHERE column1 > (SELECT AVG(column1) FROM table1)
   ```

2. **Табличный подзапрос с IN** - выборка связанных записей
   ```sql
   SELECT * FROM table1 
   WHERE id IN (SELECT table1_id FROM table2 WHERE condition)
   ```

3. **Коррелированный подзапрос** - сравнение записей внутри групп
   ```sql
   SELECT * FROM t1 
   WHERE column1 > (SELECT AVG(column1) FROM t1 t2 WHERE t2.group_id = t1.group_id)
   ```

4. **EXISTS** - проверка существования связанных записей
   ```sql
   SELECT * FROM table1 t1
   WHERE EXISTS (SELECT 1 FROM table2 t2 WHERE t2.table1_id = t1.id)
   ```

### Этап 4: Реализация курсоров (25 баллов)

1. **Простой курсор** - обход таблицы с выводом информации
   ```sql
   DECLARE @var1 INT, @var2 VARCHAR(50)
   DECLARE cursor1 CURSOR FOR SELECT id, name FROM table1
   
   OPEN cursor1
   FETCH NEXT FROM cursor1 INTO @var1, @var2
   
   WHILE @@FETCH_STATUS = 0
   BEGIN
       PRINT CAST(@var1 AS VARCHAR) + ': ' + @var2
       FETCH NEXT FROM cursor1 INTO @var1, @var2
   END
   
   CLOSE cursor1
   DEALLOCATE cursor1
   ```

2. **Вложенные курсоры** - обработка связанных данных
   ```sql
   DECLARE outer_cursor CURSOR FOR SELECT id FROM parent_table
   DECLARE inner_cursor CURSOR LOCAL FOR SELECT name FROM child_table WHERE parent_id = @parent_id
   
   OPEN outer_cursor
   FETCH NEXT FROM outer_cursor INTO @parent_id
   
   WHILE @@FETCH_STATUS = 0
   BEGIN
       SET inner_cursor = CURSOR LOCAL FOR 
           SELECT name FROM child_table WHERE parent_id = @parent_id
       
       OPEN inner_cursor
       FETCH NEXT FROM inner_cursor INTO @child_name
       
       WHILE @@FETCH_STATUS = 0
       BEGIN
           -- Обработка данных
           FETCH NEXT FROM inner_cursor INTO @child_name
       END
       
       CLOSE inner_cursor
       DEALLOCATE inner_cursor
       
       FETCH NEXT FROM outer_cursor INTO @parent_id
   END
   
   CLOSE outer_cursor
   DEALLOCATE outer_cursor
   ```

3. **Курсор с обновлением данных** - модификация записей через курсор

## Требования к выполнению

1. **Документация**: Каждый запрос должен содержать комментарии, объясняющие логику работы
2. **Тестирование**: Проверить работу на различных наборах данных
3. **Оптимизация**: Сравнить производительность курсоров и альтернативных set-based решений
4. **Обработка ошибок**: Добавить проверки и обработку исключительных ситуаций

