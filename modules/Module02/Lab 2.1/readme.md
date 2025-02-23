# Задание для модуля 2

```
Результаты домашней работы загружайте к себе в git репозиторий. Создайте папки
DEP-MGPU/Module2/
...
И сохраняйте там результат.
```

Требования к электронному отчету по лабораторной работе

## 1. Прикрепить скрипты выполнения варианта задания

```sql
-- Задание 1: [Описание задания]
CREATE VIEW dw.sales_by_region AS
SELECT ...;

-- Задание 2: [Описание задания]
CREATE TABLE dw.product_metrics AS
SELECT ...;

-- Задание 3: [Описание задания]
SELECT ...;
```

## 2.  Комментарии к запросам
- Описание логики работы каждого запроса.
- Обоснование выбора типов данных.
- Пояснения по использованию индексов.
- Особенности реализации.
## 3. Моделирование данных (обратный реинжиниринг)
### STG слой

```sql
-- Описание структуры таблиц staging-слоя
DESCRIBE stg.orders;
DESCRIBE stg.returns;
DESCRIBE stg.people;
```

-- Связи между таблицами
-- Особенности первичных данных


### DW слой

```sql
-- Описание структуры таблиц витрин данных
DESCRIBE dw.sales_fact;
DESCRIBE dw.customer_dim;
DESCRIBE dw.product_dim;
DESCRIBE dw.location_dim;
```
-- Связи между таблицами
-- Описание трансформаций данных

### Словари (Dimensions)

```sql
-- Описание структуры справочников
DESCRIBE dw.shipping_dim;
DESCRIBE dw.calendar_dim;
```

-- Правила наполнения справочников
-- Обработка медленно меняющихся измерений

## 4. Проверка данных
### Количество записей

```sql
-- Проверка количества записей в источнике и приемнике
SELECT COUNT(*) FROM stg.orders;
SELECT COUNT(*) FROM dw.sales_fact;

-- Проверка распределения данных
SELECT category, COUNT(*) 
FROM dw.product_dim 
GROUP BY category;
```

### Целостность данных

```sql
-- Проверка отсутствия дубликатов
SELECT customer_id, COUNT(*)
FROM dw.customer_dim
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Проверка ссылочной целостности
SELECT COUNT(*) 
FROM dw.sales_fact f
LEFT JOIN dw.customer_dim c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

## 5. Корректность расчетов

```sql
-- Проверка корректности агрегатов
SELECT 
    SUM(sales) as total_sales,
    SUM(profit) as total_profit
FROM stg.orders;

SELECT 
    SUM(sales) as total_sales,
    SUM(profit) as total_profit
FROM dw.sales_fact;

-- Проверка основных метрик
-- Сверка контрольных сумм
```

## Требования к оформлению.
1. Структура файлов:
   - create_tables.sql - создание всех таблиц.
   - variant_XX_tasks.sql` - решение задач варианта.
   - data_quality.sql - проверки качества данных.
2. Документация:
   - Описание структуры БД.
   - Пояснения к реализации заданий.
   - Результаты проверок.
3. Формат:
   - SQL-файлы с комментариями.
   - Результаты в формате Excel/CSV.
   - Диаграммы в формате PNG/PDF.
