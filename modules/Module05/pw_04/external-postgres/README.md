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

### Шаг 1. Клонирование проекта

```bash
# Клонируйте проект
git clone <repository-url>
cd pw_04/external-postgres

# Создайте необходимые директории
mkdir -p data/minio logs/airflow dags plugins

# CSV файл с данными уже присутствует в проекте
# quality_management_raw_data.csv

# Создание виртуального окружения Python
python3 -m venv venv
source venv/bin/activate
pip install pandas psycopg2-binary
```

### Шаг 2. Настройка подключения к PostgreSQL

**Создайте необходимые базы данных через pgAdmin:**
1. Откройте pgAdmin в браузере (http://localhost:80)
2. Подключитесь к PostgreSQL серверу
3. Создайте базы данных:
   ```sql
   CREATE DATABASE raw_data_04;
   CREATE DATABASE dbt_transformed;
   ```
4. Создайте пользователя для dbt:
   ```sql
   CREATE USER dbt_user WITH PASSWORD 'dbt_password';
   GRANT ALL PRIVILEGES ON DATABASE raw_data_04 TO dbt_user;
   GRANT ALL PRIVILEGES ON DATABASE dbt_transformed TO dbt_user;
   ```
5. Создайте таблицу в базе `raw_data_04`:
   ```sql
   \c raw_data_04;
   
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
   
   GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dbt_user;
   ```

### Шаг 3. Запуск сервисов

```bash
# Запуск всех сервисов (кроме PostgreSQL)
docker compose up -d

# Ожидание готовности (2-3 минуты)
docker compose logs -f airflow-init
```

### Шаг 4. Загрузка данных

```bash
# Активация виртуального окружения
source venv/bin/activate

# Загрузка данных
cd scripts
python3 load_data.py
cd ..
```

### Шаг 5. Доступ к интерфейсам

- **Airflow UI**: http://localhost:8080 (admin/admin)
- **MinIO Console**: http://localhost:9001 (minioadmin/minioadmin)
- **pgAdmin**: http://localhost:80 (используйте существующие учетные данные)
- **PostgreSQL**: localhost:5432
  - Пользователь: `dbt_user`
  - Пароль: `dbt_password`
  - Базы данных: `raw_data_04`, `dbt_transformed`

### Шаг 6. Настройка pgAdmin

1. Откройте http://localhost:80 (используйте существующий pgAdmin на хосте)
2. Войдите используя ваши существующие учетные данные
3. Добавьте новый сервер:
   - **Name**: External PostgreSQL
   - **Host**: localhost (или IP адрес хоста)
   - **Port**: 5432
   - **Username**: dbt_user
   - **Password**: dbt_password
4. Сохраните подключение

### Шаг 7. Запуск DAG

1. Откройте http://localhost:8080
2. Войдите как admin/admin
3. Найдите DAG `quality_management_dbt_external`
4. Включите и запустите DAG

## Конфигурационные файлы

Все необходимые файлы уже готовы в проекте:

- `docker-compose.yml` - конфигурация Docker сервисов
- `quality_management_raw_data.csv` - исходные данные для загрузки
- `dbt-project/profiles.yml` - настройки dbt для внешнего PostgreSQL
- `dbt-project/dbt_project.yml` - конфигурация dbt-проекта
- `dbt-project/models/schema.yml` - схема данных
- `dbt-project/models/staging/stg_quality_audits.sql` - staging модель
- `dags/dbt_external_dag.py` - Airflow DAG для внешнего PostgreSQL
- `scripts/load_data.py` - скрипт загрузки данных

## Проверка работы

**Проверка через pgAdmin:**
1. Откройте http://localhost:80
2. Подключитесь к PostgreSQL серверу
3. Проверьте базы данных `raw_data_04` и `dbt_transformed`
4. В базе `raw_data_04` выполните запрос:
   ```sql
   SELECT COUNT(*) as total_audits FROM quality_audits;
   ```
5. В базе `dbt_transformed` проверьте таблицы после выполнения DAG

**Проверка статуса всех сервисов:**
```bash
docker compose ps
```

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

**Через pgAdmin:**
1. Откройте http://localhost:80 (существующий pgAdmin на хосте)
2. Подключитесь к серверу PostgreSQL
3. В базе `dbt_transformed` проверьте таблицы:
   - `stg_quality_audits` (30 записей)
   - `dim_departments` (8 записей)
   - `fact_audit_performance` (30 записей)
4. Выполните запросы для проверки данных:
   ```sql
   -- Проверка исходных данных
   SELECT COUNT(*) as total_audits FROM quality_audits;
   
   -- Проверка staging модели
   SELECT COUNT(*) as staging_count FROM stg_quality_audits;
   
   -- Проверка dimension таблицы
   SELECT COUNT(*) as departments_count FROM dim_departments;
   
   -- Проверка fact таблицы
   SELECT COUNT(*) as fact_count FROM fact_audit_performance;
   ```

### 3. Проверка в MinIO

1. Откройте http://localhost:9001
2. Войдите как minioadmin/minioadmin
3. MinIO используется для хранения:
   - Файлов dbt-проекта
   - Логов Airflow
   - Временных файлов

### 4. Ожидаемые результаты

После успешного выполнения DAG должны быть созданы:

- **База `raw_data_04`**: таблица `quality_audits` с 30 записями
- **База `dbt_transformed`**: 
  - `stg_quality_audits` - 30 записей с дополнительными полями
  - `dim_departments` - 8 записей (по количеству отделов)
  - `fact_audit_performance` - 30 записей с метриками

## Остановка и очистка проекта

### Остановка сервисов

```bash
# Остановка всех сервисов
docker compose down

# Остановка с удалением данных
docker compose down -v
```

### Полная очистка проекта

```bash
# 1. Деактивация виртуального окружения Python (если активно)
# Если вы находитесь внутри окружения, выйдите из него
# Ваша строка будет выглядеть примерно так: (venv) user@hostname:~/my_project$
deactivate
# Теперь строка выглядит так: user@hostname:~/my_project$

# 2. Убедитесь, что вы находитесь в папке проекта
# и удалите папку с окружением
ls # Вы должны увидеть папку 'venv' в списке
rm -rf venv

# 3. Остановка и удаление всех контейнеров и данных
docker compose down -v

# 4. Удаление образов (опционально)
docker compose down --rmi all

# 5. Очистка неиспользуемых ресурсов Docker
docker system prune -a
```

### Удаление проекта

```bash
# 1. Деактивация виртуального окружения Python (если активно)
deactivate

# 2. Остановка сервисов
docker compose down -v

# 3. Удаление директории проекта
cd ..
rm -rf external-postgres
```

## Заключение

Решение с внешним PostgreSQL обеспечивает эффективное использование существующей инфраструктуры и упрощает управление данными для проектов качества управления.
