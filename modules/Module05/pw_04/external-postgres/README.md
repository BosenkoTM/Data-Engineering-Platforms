# Локальная разработка с внешним PostgreSQL

## Описание решения

Данное решение предназначено для случаев, когда PostgreSQL уже установлен на виртуальной машине или хосте. Вместо создания нового контейнера PostgreSQL, мы подключаемся к существующей базе данных.

## Архитектура решения

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Источники     │    │   MinIO         │    │   PostgreSQL    │
│   данных        │───▶│   (Object       │───▶│   (External)     │
│   (CSV файлы)   │    │    Storage)     │    │   Host:5432      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Airflow UI    │◀───│  Apache Airflow │───▶│   PostgreSQL    │
│   (Мониторинг)  │    │   (Docker)      │    │   (Transformed) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   dbt Models    │
                       │   (Local)       │
                       └─────────────────┘
```

## Компоненты системы

### 1. **Apache Airflow** (Docker)
- Управляемая среда для оркестрации задач
- Веб-интерфейс для мониторинга DAG'ов
- Поддержка dbt операторов

### 2. **PostgreSQL** (Внешний)
- Существующая база данных на хосте
- Подключение через сеть Docker
- Высокая производительность для аналитических запросов

### 3. **MinIO** (Docker)
- Замена Cloud Storage для файлов
- S3-совместимый API
- Хранение dbt-проектов и данных

### 4. **pgAdmin** (Host)
- Веб-интерфейс для управления PostgreSQL (уже установлен на хосте)
- Визуальное выполнение SQL-запросов
- Мониторинг баз данных и таблиц

### 5. **dbt** (Локально)
- Трансформация данных в PostgreSQL
- Локальное выполнение команд
- Полная совместимость с Airflow

## Предварительные требования

- **PostgreSQL** установлен на хосте (версия 13+)
- **Docker** и **Docker Compose** установлены
- **Python** 3.8+ (для загрузки данных)
- **Git** (для клонирования проекта)
- Доступ к PostgreSQL с хоста (порт 5432)

## Запуск проекта

### Шаг 1: Клонирование проекта

```bash
# Клонируйте проект
git clone <repository-url>
cd pw_04/external-postgres

# Создайте необходимые директории
mkdir -p data/minio logs/airflow dags plugins

# Скопируйте CSV файл с данными
cp ../quality_management_raw_data.csv ./

# Создание виртуального окружения Python
python3 -m venv venv
source venv/bin/activate
pip install pandas psycopg2-binary
```

### Шаг 2: Настройка подключения к PostgreSQL

**Проверьте доступность PostgreSQL:**
```bash
# Проверка подключения к PostgreSQL
psql -h localhost -p 5432 -U postgres -d postgres -c "SELECT version();"
```

**Создайте необходимые базы данных:**
```sql
-- Подключитесь к PostgreSQL
psql -h localhost -p 5432 -U postgres -d postgres

-- Создайте базы данных
CREATE DATABASE raw_data;
CREATE DATABASE dbt_transformed;

-- Создайте пользователя для dbt
CREATE USER dbt_user WITH PASSWORD 'dbt_password';
GRANT ALL PRIVILEGES ON DATABASE raw_data TO dbt_user;
GRANT ALL PRIVILEGES ON DATABASE dbt_transformed TO dbt_user;

-- Подключитесь к базе raw_data и создайте таблицу
\c raw_data;

CREATE TABLE quality_audits (
    audit_id VARCHAR(50) PRIMARY KEY,
    audit_date DATE NOT NULL,
    auditor_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    audit_type VARCHAR(50) NOT NULL,
    process_name VARCHAR(100) NOT NULL,
    compliance_score INTEGER NOT NULL CHECK (compliance_score >= 0 AND compliance_score <= 100),
    non_conformities_count INTEGER NOT NULL CHECK (non_conformities_count >= 0),
    critical_issues INTEGER NOT NULL CHECK (critical_issues >= 0),
    minor_issues INTEGER NOT NULL CHECK (minor_issues >= 0),
    recommendations_count INTEGER NOT NULL CHECK (recommendations_count >= 0),
    audit_status VARCHAR(50) NOT NULL,
    next_audit_date DATE NOT NULL,
    audit_duration_hours INTEGER NOT NULL CHECK (audit_duration_hours > 0),
    certification_level VARCHAR(50) NOT NULL
);

-- Предоставьте права пользователю dbt
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dbt_user;
```

### Шаг 3: Запуск сервисов

```bash
# Запуск всех сервисов (кроме PostgreSQL)
docker compose up -d

# Ожидание готовности (2-3 минуты)
docker compose logs -f airflow-init
```

### Шаг 4: Загрузка данных

```bash
# Активация виртуального окружения
source venv/bin/activate

# Загрузка данных
cd scripts
python3 load_data.py
cd ..
```

### Шаг 5: Доступ к интерфейсам

- **Airflow UI**: http://localhost:8080 (admin/admin)
- **MinIO Console**: http://localhost:9001 (minioadmin/minioadmin)
- **pgAdmin**: http://localhost:80 (используйте существующие учетные данные)
- **PostgreSQL**: localhost:5432
  - Пользователь: `dbt_user`
  - Пароль: `dbt_password`
  - Базы данных: `raw_data`, `dbt_transformed`

### Шаг 6: Настройка pgAdmin

1. Откройте http://localhost:80 (используйте существующий pgAdmin на хосте)
2. Войдите используя ваши существующие учетные данные
3. Добавьте новый сервер:
   - **Name**: External PostgreSQL
   - **Host**: localhost (или IP адрес хоста)
   - **Port**: 5432
   - **Username**: dbt_user
   - **Password**: dbt_password
4. Сохраните подключение

### Шаг 7: Запуск DAG

1. Откройте http://localhost:8080
2. Войдите как admin/admin
3. Найдите DAG `quality_management_dbt_external`
4. Включите и запустите DAG

## Конфигурационные файлы

Все необходимые файлы уже готовы в проекте:

- `docker-compose.yml` - конфигурация Docker сервисов
- `dbt-project/profiles.yml` - настройки dbt для внешнего PostgreSQL
- `dbt-project/dbt_project.yml` - конфигурация dbt-проекта
- `dbt-project/models/schema.yml` - схема данных
- `dbt-project/models/staging/stg_quality_audits.sql` - staging модель
- `dags/dbt_external_dag.py` - Airflow DAG для внешнего PostgreSQL
- `scripts/load_data.py` - скрипт загрузки данных

## Проверка работы

```bash
# Проверка данных в PostgreSQL через командную строку
psql -h localhost -p 5432 -U dbt_user -d raw_data -c "SELECT COUNT(*) as total_audits FROM quality_audits;"

# Проверка результатов dbt
psql -h localhost -p 5432 -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as staging_count FROM stg_quality_audits;"

# Проверка статуса всех сервисов
docker compose ps
```

**Проверка через pgAdmin:**
1. Откройте http://localhost:80
2. Подключитесь к серверу PostgreSQL
3. Проверьте базы данных `raw_data` и `dbt_transformed`
4. Выполните SQL-запросы для проверки данных

## Проверка результата работы DAG

### 1. Проверка в Airflow UI

1. Откройте http://localhost:8080
2. Найдите DAG `quality_management_dbt_external`
3. Проверьте статус задач:
   - ✅ **Зеленый** - задача выполнена успешно
   - ❌ **Красный** - ошибка выполнения
   - ⏳ **Желтый** - задача в процессе
4. Нажмите на задачу для просмотра логов
5. Проверьте время выполнения и детали

### 2. Проверка в PostgreSQL

**Через командную строку:**
```bash
# Проверка исходных данных
psql -h localhost -p 5432 -U dbt_user -d raw_data -c "SELECT COUNT(*) as total_audits FROM quality_audits;"

# Проверка staging модели
psql -h localhost -p 5432 -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as staging_count FROM stg_quality_audits;"

# Проверка dimension таблицы
psql -h localhost -p 5432 -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as departments_count FROM dim_departments;"

# Проверка fact таблицы
psql -h localhost -p 5432 -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as fact_count FROM fact_audit_performance;"
```

**Через pgAdmin:**
1. Откройте http://localhost:80 (существующий pgAdmin на хосте)
2. Подключитесь к серверу PostgreSQL
3. В базе `dbt_transformed` проверьте таблицы:
   - `stg_quality_audits` (30 записей)
   - `dim_departments` (8 записей)
   - `fact_audit_performance` (30 записей)

### 3. Проверка в MinIO

1. Откройте http://localhost:9001
2. Войдите как minioadmin/minioadmin
3. MinIO используется для хранения:
   - Файлов dbt-проекта
   - Логов Airflow
   - Временных файлов

### 4. Ожидаемые результаты

После успешного выполнения DAG должны быть созданы:

- **База `raw_data`**: таблица `quality_audits` с 30 записями
- **База `dbt_transformed`**: 
  - `stg_quality_audits` - 30 записей с дополнительными полями
  - `dim_departments` - 8 записей (по количеству отделов)
  - `fact_audit_performance` - 30 записей с метриками

## Остановка

```bash
# Остановка всех сервисов
docker compose down

# Остановка с удалением данных
docker compose down -v
```

## Устранение неполадок

### Проблемы с подключением к PostgreSQL

```bash
# Проверка доступности PostgreSQL
psql -h localhost -p 5432 -U postgres -d postgres -c "SELECT 1;"

# Проверка сетевого подключения
telnet localhost 5432

# Проверка прав пользователя
psql -h localhost -p 5432 -U dbt_user -d raw_data -c "SELECT current_user;"
```

### Проблемы с Docker

```bash
# Перезапуск сервисов
docker compose restart

# Просмотр логов
docker compose logs airflow-webserver
docker compose logs pgadmin

# Полная переустановка
docker compose down -v
docker compose up -d
```

### Проблемы с pgAdmin

```bash
# Проверка доступности pgAdmin на хосте
curl -I http://localhost:80

# Проверка подключения pgAdmin к PostgreSQL
psql -h localhost -p 5432 -U dbt_user -d raw_data
```

## Преимущества решения с внешним PostgreSQL

1. **Использование существующей инфраструктуры** - не нужно создавать новый PostgreSQL и pgAdmin
2. **Лучшая производительность** - PostgreSQL работает на хосте
3. **Простота управления** - один PostgreSQL и pgAdmin для всех проектов
4. **Экономия ресурсов** - меньше Docker контейнеров
5. **Гибкость** - можно использовать существующие данные и настройки

## Ограничения

1. **Зависимость от хоста** - PostgreSQL и pgAdmin должны быть доступны
2. **Сетевая конфигурация** - нужно настроить подключение из Docker
3. **Права доступа** - нужно правильно настроить пользователей PostgreSQL
4. **Версии** - совместимость версий PostgreSQL и dbt
5. **Конфигурация pgAdmin** - нужно настроить подключение к существующему PostgreSQL

## Заключение

Решение с внешним PostgreSQL идеально подходит для случаев, когда база данных и pgAdmin уже установлены на хосте. Оно обеспечивает эффективное использование существующей инфраструктуры и упрощает управление данными.
