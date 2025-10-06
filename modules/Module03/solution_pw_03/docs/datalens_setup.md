# Руководство по настройке Yandex DataLens

## 📋 Содержание
1. [Регистрация и создание воркбука](#регистрация-и-создание-воркбука)
2. [Подключение к источникам данных](#подключение-к-источникам-данных)
3. [Создание датасетов](#создание-датасетов)
4. [Настройка типов данных](#настройка-типов-данных)
5. [Создание вычисляемых полей](#создание-вычисляемых-полей)

## 🚀 Регистрация и создание воркбука

### Шаг 1: Регистрация в DataLens
1. Перейдите на [datalens.ru](https://datalens.ru/)
2. Нажмите "Войти" и выберите способ авторизации (Яндекс ID, Google, Microsoft)
3. Заполните профиль и подтвердите email

### Шаг 2: Создание воркбука
1. После входа в систему нажмите "Создать воркбук"
2. Введите название: `SuperStore Analytics`
3. Добавьте описание: `Аналитический дашборд для интернет-магазина SuperStore`
4. Нажмите "Создать"

## 🔌 Подключение к источникам данных

### Вариант 1: Загрузка CSV файлов

#### Подготовка файлов
1. Убедитесь, что CSV файлы созданы скриптом `export_to_csv.py`
2. Проверьте кодировку файлов (должна быть UTF-8)
3. Убедитесь, что в файлах нет пустых строк в начале

#### Загрузка в DataLens
1. В воркбуке нажмите "Создать подключение"
2. Выберите "Файл" → "CSV"
3. Загрузите файл `monthly_sales.csv`
4. Настройте параметры:
   - **Разделитель:** `,` (запятая)
   - **Кодировка:** `UTF-8`
   - **Первая строка как заголовок:** ✅
5. Нажмите "Создать подключение"
6. Повторите для остальных файлов:
   - `customer_ltv.csv`
   - `dormant_customers.csv`

### Вариант 2: Прямое подключение к PostgreSQL

#### Настройка подключения
1. В воркбуке нажмите "Создать подключение"
2. Выберите "База данных" → "PostgreSQL"
3. Заполните параметры подключения:
   ```
  Хост: localhost (или IP вашего сервера)
  Порт: 5432
  База данных: superstore
   Пользователь: postgres
   Пароль: [ваш пароль]
   ```
4. Нажмите "Проверить подключение"
5. После успешной проверки нажмите "Создать подключение"

#### Создание SQL-подключений
1. Создайте отдельное подключение для каждой витрины:
   - **monthly_sales_connection** → SQL запрос из `sql_queries.sql` (раздел 1), со ссылками на `public_dw_test`
   - **customer_ltv_connection** → SQL запрос из `sql_queries.sql` (раздел 2), со ссылками на `public_dw_test`
   - **dormant_customers_connection** → SQL запрос из `sql_queries.sql` (раздел 3), со ссылками на `public_dw_test`

2. Если схемы нет: восстановите `public_dw_test` из `data/public_dw_test` (pg_restore) или выполните `data/from_stg_to_dw.sql`.

## 📊 Создание датасетов

### Датасет 1: Monthly Sales (Месячные продажи)
1. Нажмите "Создать датасет"
2. Выберите подключение к `monthly_sales.csv` или SQL-запрос
3. Назовите датасет: `Monthly Sales`
4. Добавьте описание: `Агрегированные данные по продажам по месяцам, категориям и сегментам`

### Датасет 2: Customer LTV (LTV клиентов)
1. Создайте новый датасет
2. Выберите подключение к `customer_ltv.csv` или SQL-запрос
3. Назовите датасет: `Customer LTV`
4. Добавьте описание: `Метрики Lifetime Value по каждому клиенту`

### Датасет 3: Dormant Customers (Спящие клиенты)
1. Создайте новый датасет
2. Выберите подключение к `dormant_customers.csv` или SQL-запрос
3. Назовите датасет: `Dormant Customers`
4. Добавьте описание: `Ценные спящие клиенты (топ-25% по выручке, не покупали >6 месяцев)`

## 🔧 Настройка типов данных

### Для датасета Monthly Sales:
```
sales_month: Date (Дата)
category: String (Строка)
segment: String (Строка)
total_sales: Float (Дробное число)
total_profit: Float (Дробное число)
profit_margin: Float (Дробное число)
number_of_orders: Integer (Целое число)
year: Integer (Целое число)
month: Integer (Целое число)
sales_month_name: String (Строка)
profitability_category: String (Строка)
```

### Для датасета Customer LTV:
```
customer_id: String (Строка)
customer_name: String (Строка)
segment: String (Строка)
first_order_date: Date (Дата)
last_order_date: Date (Дата)
number_of_orders: Integer (Целое число)
total_sales_lifetime: Float (Дробное число)
average_order_value: Float (Дробное число)
customer_age_days: Integer (Целое число)
first_order_year: Integer (Целое число)
last_order_year: Integer (Целое число)
ltv_category: String (Строка)
order_frequency_category: String (Строка)
```

### Для датасета Dormant Customers:
```
customer_id: String (Строка)
customer_name: String (Строка)
segment: String (Строка)
city: String (Строка)
state: String (Строка)
total_orders: Integer (Целое число)
total_sales: Float (Дробное число)
total_profit: Float (Дробное число)
avg_order_value: Float (Дробное число)
first_order_date: Date (Дата)
last_order_date: Date (Дата)
days_since_last_order: Integer (Целое число)
total_quantity: Integer (Целое число)
avg_discount: Float (Дробное число)
sales_percentile: Float (Дробное число)
customer_status: String (Строка)
dormant_period_category: String (Строка)
recovery_priority: String (Строка)
profit_margin_percent: Float (Дробное число)
discount_category: String (Строка)
```

## 🧮 Создание вычисляемых полей

### Для датасета Monthly Sales:

#### 1. Sales Growth (Рост продаж)
```sql
CASE 
    WHEN [prev_month_sales] IS NOT NULL AND [prev_month_sales] > 0 
    THEN ([total_sales] - [prev_month_sales]) / [prev_month_sales] * 100
    ELSE NULL 
END
```

#### 2. Profit Margin Percent (Маржинальность в процентах)
```sql
[profit_margin] * 100
```

#### 3. Sales per Order (Продажи на заказ)
```sql
[total_sales] / [number_of_orders]
```

### Для датасета Customer LTV:

#### 1. Customer Lifetime (Время жизни клиента в месяцах)
```sql
DATEDIFF([last_order_date], [first_order_date], 'month')
```

#### 2. LTV per Month (LTV в месяц)
```sql
[total_sales_lifetime] / NULLIF(DATEDIFF([last_order_date], [first_order_date], 'month'), 0)
```

#### 3. Order Frequency (Частота заказов)
```sql
[number_of_orders] / NULLIF(DATEDIFF([last_order_date], [first_order_date], 'day'), 0) * 30
```

### Для датасета Dormant Customers:

#### 1. Recovery Potential Score (Оценка потенциала возврата)
```sql
([total_sales] * 0.4) + ([avg_order_value] * 0.3) + (1000 / NULLIF([days_since_last_order], 0) * 0.3)
```

#### 2. Dormant Risk Level (Уровень риска потери)
```sql
CASE 
    WHEN [days_since_last_order] > 730 THEN 'Критический'
    WHEN [days_since_last_order] > 365 THEN 'Высокий'
    ELSE 'Средний'
END
```

#### 3. Expected Recovery Value (Ожидаемая стоимость возврата)
```sql
[total_sales] * 0.1 * (1 - [days_since_last_order] / 1095)
```

## 📝 Рекомендации по настройке

### Форматирование чисел:
- **Денежные значения** (total_sales, total_profit): формат `#,##0.00 ₽`
- **Проценты** (profit_margin): формат `0.00%`
- **Количественные показатели** (number_of_orders): формат `#,##0`

### Настройка фильтров по умолчанию:
- **Временной период**: последние 12 месяцев
- **Категории**: все категории
- **Сегменты**: все сегменты

### Группировка данных:
- **По времени**: месяц, квартал, год
- **По продуктам**: категория, сегмент
- **По клиентам**: LTV категория, частота заказов
- **По географии**: штат, город

## ⚠️ Частые проблемы и решения

### Проблема: Неправильная кодировка CSV файлов
**Решение:** 
1. Откройте файл в текстовом редакторе
2. Сохраните с кодировкой UTF-8
3. Перезагрузите файл в DataLens

### Проблема: Ошибки в вычисляемых полях
**Решение:**
1. Проверьте синтаксис SQL
2. Убедитесь, что все поля существуют в датасете
3. Используйте функции NULLIF для избежания деления на ноль

### Проблема: Медленная загрузка больших датасетов
**Решение:**
1. Используйте фильтры для ограничения данных
2. Создайте агрегированные датасеты
3. Настройте прямое подключение к БД вместо CSV

## 🔗 Полезные ссылки

- [Документация DataLens](https://yandex.cloud/ru/docs/datalens/)
- [Справочник функций DataLens](https://yandex.cloud/ru/docs/datalens/function-ref/)
- [Примеры дашбордов](https://datalens.ru/gallery)
- [Обучение DataLens](https://yandex.cloud/ru/training/datalens)

---

**Следующий шаг:** После настройки датасетов переходите к [руководству по созданию чартов](charts_guide.md).
