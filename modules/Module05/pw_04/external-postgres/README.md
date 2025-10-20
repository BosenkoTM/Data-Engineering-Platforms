# Локальная разработка с внешним PostgreSQL
**⚠️ ВАЖНО. Этот репозиторий предназначен для работы в VM Клон devops_dba_25.ova**
## Описание решения

Данное решение предназначено для случаев, когда PostgreSQL уже установлен на виртуальной машине или хосте. Вместо создания нового контейнера PostgreSQL, мы подключаемся к существующей базе данных.

## Архитектура решения

```
┌─────────────────┐    ┌─────────────────┐     ┌─────────────────┐
│   Источники     │    │   MinIO         │     │   PostgreSQL    │
│   данных        │───▶│   (Object       │───▶│   (External)    │
│   (CSV файлы)   │    │    Storage)     │     │   Host:5432     │
└─────────────────┘    └─────────────────┘     │   Database:     │
                                               │   superstore    │
                                               │   Schema:       │
                                               │   raw_data_04   │
                                               └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐     ┌─────────────────┐
│   Airflow UI    │◀───│  Apache Airflow │───▶│   PostgreSQL    │
│   (Мониторинг)  │    │   (Docker)      │     │   Database:     │
└─────────────────┘    └─────────────────┘     │   superstore    │
                                │              │   Schema:       │
                                ▼              │   marts_04      │
                       ┌─────────────────┐     └─────────────────┘
                       │   dbt Models    │
                       │   (Local)       │
                       └─────────────────┘
```

## Компоненты системы

### 1. **Apache Airflow** (Docker)
- Управляемая среда для оркестрации задач
- Веб-интерфейс для мониторинга DAG'ов
- Поддержка dbt операторов

### 2. **PostgreSQL** (Внешний для данных)
- Существующая база данных `superstore` на хосте для хранения данных проекта
- Подключение через сеть Docker
- Схемы: `raw_data_04` (исходные данные) и `marts_04` (трансформированные данные)
- Высокая производительность для аналитических запросов

### 3. **PostgreSQL** (Внутренний для Airflow)
- Собственная база данных Airflow в Docker контейнере
- Используется для метаданных Airflow (DAG'и, задачи, логи)
- Изолирован от данных проекта

### 4. **MinIO** (Docker)
- Замена Cloud Storage для файлов
- S3-совместимый API
- Хранение dbt-проектов и данных

### 5. **pgAdmin** (Host)
- Веб-интерфейс для управления PostgreSQL (уже установлен на хосте)
- Визуальное выполнение SQL-запросов
- Мониторинг баз данных и таблиц

### 6. **dbt** (Локально)
- Трансформация данных в PostgreSQL
- Локальное выполнение команд
- Полная совместимость с Airflow

## Предварительные требования

- **PostgreSQL** установлен на хосте (версия 13+) для хранения данных проекта
- **Docker** и **Docker Compose** установлены
- **Python** 3.8+ (для загрузки данных)
- **Git** (для клонирования проекта)
- Доступ к PostgreSQL с хоста (порт 5432)


## Запуск проекта

### Шаг 1. Подготовка каталогов и прав доступа

**Создайте каталоги и установите права доступа (Ubuntu/Linux):**
```bash
sudo mkdir -p data/minio logs dags plugins
sudo chown -R 50000:0 logs/ dags/ plugins/ dbt-project/
sudo chmod -R 777 logs/ dags/ plugins/ dbt-project/
```

### Шаг 2. Клонирование проекта

```bash
git clone <repository-url>
cd pw_04/external-postgres

mkdir data\minio
mkdir logs
mkdir dags
mkdir plugins
```

### Шаг 3. Создание схем и таблиц в pgAdmin

**Откройте pgAdmin в браузере:**
- **URL**: http://localhost:80
- **Email**: `admin@admin.com`
- **Password**: `admin1617!`

**Подключитесь к PostgreSQL серверу:**
1. В pgAdmin нажмите **"Add New Server"**
2. Заполните параметры:
   - **Name**: `External PostgreSQL`
   - **Host**: `postgres16`
   - **Port**: `5432`
   - **Username**: `postgres`
   - **Password**: `post1616!`
3. Нажмите **"Save"**

**Создайте схемы:**
1. Разверните сервер → Databases → superstore → Schemas
2. Правой кнопкой на Schemas → Create → Schema
3. Создайте схему `raw_data_04`
4. Повторите для схемы `marts_04`

-- Создание схем
   CREATE SCHEMA IF NOT EXISTS raw_data_04;
   CREATE SCHEMA IF NOT EXISTS marts_04;
   ```
5. Создайте таблицу в схеме `raw_data_04`:
   ```sql
   SET search_path TO raw_data_04;
   
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
   ```

### Шаг 4. Загрузка данных

```bash
python3 -m venv venv
source venv/bin/activate
pip install psycopg2-binary pandas
python scripts/load_data.py
deactivate
```

### Шаг 5. Запуск проекта

```bash
docker compose up -d
```

### Шаг 6. Проверка доступности Airflow

Откройте Airflow UI: http://localhost:8080
- **Username**: `admin`
- **Password**: `admin`

### Шаг 7. Настройка Airflow Connection

**Создайте Connection для внешнего PostgreSQL:**
1. Перейдите в **Admin → Connections**
2. Нажмите **+** для создания новой связи
3. Заполните параметры:
   - **Connection Id**: `external_postgres`
   - **Connection Type**: `Postgres`
   - **Host**: `postgres16`
   - **Schema**: `superstore`
   - **Login**: `postgres`
   - **Password**: `post1616!`
   - **Port**: `5432`
4. Нажмите **Save**

### Шаг 8. Проверка выполнения DAG

1. Найдите DAG `quality_management_dbt_external`
2. Активируйте DAG (переключатель ON)
3. Нажмите **"Trigger DAG"** для запуска
4. Проверьте выполнение задач в Airflow UI
5. Убедитесь, что данные появились в схеме `marts_04`

### Шаг 9. Работа с MinIO

**MinIO доступен по адресам:**
- **Console**: http://localhost:9001
- **API**: http://localhost:9000
- **Username**: `minioadmin`
- **Password**: `minioadmin`

**Создайте bucket и access key:**
1. Откройте MinIO Console (http://localhost:9001)
2. Войдите с учетными данными: `minioadmin` / `minioadmin`
3. Создайте bucket `quality-management-data`
4. Создайте Access Key:
   - **Access Key**: `quality-mgmt-key`
   - **Secret Key**: `quality-mgmt-secret123`
   - **Expiry**: `Never` (или выберите нужный период)

**Запустите DAG экспорта в MinIO:**
1. Найдите DAG `export_to_minio`
2. Активируйте DAG (переключатель ON)
3. Нажмите **"Trigger DAG"** для запуска
4. Проверьте файлы в MinIO Console


**Проверьте файлы в MinIO:**
- Откройте http://localhost:9001
- Перейдите в bucket `quality-management-data`
- Убедитесь, что созданы файлы `audit_data_*.csv` и `compliance_summary_*.csv`


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
3. В базе `superstore` проверьте схемы:
   - `raw_data_04.quality_audits` (30 записей)
   - `marts_04.stg_quality_audits` (30 записей)
   - `marts_04.dim_departments` (8 записей)
   - `marts_04.fact_audit_performance` (30 записей)
4. Выполните запросы для проверки данных:
   ```sql
   -- Проверка исходных данных
   SELECT COUNT(*) as total_audits FROM raw_data_04.quality_audits;
   
   -- Проверка staging модели
   SELECT COUNT(*) as staging_count FROM marts_04.stg_quality_audits;
   
   -- Проверка dimension таблицы
   SELECT COUNT(*) as departments_count FROM marts_04.dim_departments;
   
   -- Проверка fact таблицы
   SELECT COUNT(*) as fact_count FROM marts_04.fact_audit_performance;
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

- **База `superstore`, схема `raw_data_04`**: таблица `quality_audits` с 30 записями
- **База `superstore`, схема `marts_04`**: 
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

