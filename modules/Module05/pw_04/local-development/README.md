# Локальная разработка с Docker Compose

## Описание решения

Данное решение позволяет выполнить практическую работу 4.1 без использования Google Cloud Platform, используя локальные сервисы в Docker контейнерах. Это идеальный вариант для обучения и разработки без необходимости активации биллинга в облаке.

## Архитектура локального решения

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Источники     │    │   MinIO         │    │   PostgreSQL    │
│   данных        │───▶│   (Object       │───▶│   (Raw Data)   │
│   (CSV файлы)   │    │    Storage)     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Airflow UI    │◀───│  Apache Airflow │───▶│   PostgreSQL   │
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

### 2. **PostgreSQL** (Docker)
- Замена BigQuery для хранения данных
- Поддержка всех необходимых типов данных
- Высокая производительность для аналитических запросов

### 3. **MinIO** (Docker)
- Замена Cloud Storage для файлов
- S3-совместимый API
- Хранение dbt-проектов и данных

### 4. **dbt** (Локально)
- Трансформация данных в PostgreSQL
- Локальное выполнение команд
- Полная совместимость с Airflow

### 5. **pgAdmin** (Docker)
- Веб-интерфейс для управления PostgreSQL
- Визуальное выполнение SQL-запросов
- Мониторинг баз данных и таблиц

## Предварительные требования

- **Docker** и **Docker Compose** установлены
- **Python** 3.8+ (для загрузки данных)
- **Git** (для клонирования проекта)

## Запуск проекта

### Шаг 1. Клонирование проекта

```bash
# Клонируйте проект
git clone <repository-url>
cd pw_04/local-development

# Создайте необходимые директории
mkdir -p data/postgres data/minio logs/airflow dags plugins

# Скопируйте CSV файл с данными
cp ../quality_management_raw_data.csv ./

# Создание виртуального окружения Python
python3 -m venv venv
source venv/bin/activate
pip install pandas psycopg2-binary
```

### Шаг 2. Запуск сервисов

```bash
# Запуск всех сервисов
docker compose up -d

# Ожидание готовности (2-3 минуты)
docker compose logs -f airflow-init
```

### Шаг 3. Загрузка данных

```bash
# Активация виртуального окружения
source venv/bin/activate

# Ожидание готовности PostgreSQL (30-60 секунд)
sleep 60

# Загрузка данных
cd scripts
python3 load_data.py
cd ..
```

### Шаг 4. Доступ к интерфейсам

- **Airflow UI**: http://localhost:8080 (admin/admin)
- **MinIO Console**: http://localhost:9001 (minioadmin/minioadmin)
- **pgAdmin**: http://localhost:5050 (admin@example.com/admin)
- **PostgreSQL**: localhost:5432
  - Пользователь: `dbt_user`
  - Пароль: `dbt_password`
  - Базы данных: `raw_data`, `dbt_transformed`

### Шаг 5. Настройка pgAdmin

1. Откройте http://localhost:5050
2. Войдите как admin@example.com / admin
3. Добавьте новый сервер:
   - **Name**: Local PostgreSQL
   - **Host**: postgres
   - **Port**: 5432
   - **Username**: dbt_user
   - **Password**: dbt_password
4. Сохраните подключение

### Шаг 6. Запуск DAG

1. Откройте http://localhost:8080
2. Войдите как admin/admin
3. Найдите DAG `quality_management_dbt_local`
4. Включите и запустите DAG

## Конфигурационные файлы

Все необходимые файлы уже готовы в проекте:

- `docker-compose.yml` - конфигурация Docker сервисов
- `init-scripts/01-init-databases.sql` - инициализация PostgreSQL
- `dbt-project/profiles.yml` - настройки dbt для PostgreSQL
- `dbt-project/dbt_project.yml` - конфигурация dbt-проекта
- `dbt-project/models/schema.yml` - схема данных
- `dbt-project/models/staging/stg_quality_audits.sql` - staging модель
- `dags/dbt_local_dag.py` - Airflow DAG
- `scripts/load_data.py` - скрипт загрузки данных

## Проверка работы

```bash
# Проверка данных в PostgreSQL через командную строку
docker compose exec postgres psql -U dbt_user -d raw_data -c "SELECT COUNT(*) FROM quality_audits;"

# Проверка результатов dbt
docker compose exec postgres psql -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) FROM stg_quality_audits;"

# Проверка статуса всех сервисов
docker compose ps
```

**Проверка через pgAdmin:**
1. Откройте http://localhost:5050
2. Подключитесь к серверу PostgreSQL
3. Проверьте базы данных `raw_data` и `dbt_transformed`
4. Выполните SQL-запросы для проверки данных

## Проверка результата работы DAG

### 1. Проверка в Airflow UI

1. Откройте http://localhost:8080
2. Найдите DAG `quality_management_dbt_local`
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
docker compose exec postgres psql -U dbt_user -d raw_data -c "SELECT COUNT(*) as total_audits FROM quality_audits;"

# Проверка staging модели
docker compose exec postgres psql -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as staging_count FROM stg_quality_audits;"

# Проверка dimension таблицы
docker compose exec postgres psql -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as departments_count FROM dim_departments;"

# Проверка fact таблицы
docker compose exec postgres psql -U dbt_user -d dbt_transformed -c "SELECT COUNT(*) as fact_count FROM fact_audit_performance;"
```

**Через pgAdmin:**
1. Откройте http://localhost:5050
2. Подключитесь к PostgreSQL
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
4. В текущей конфигурации MinIO служит как замена Cloud Storage

### 4. Ожидаемые результаты

После успешного выполнения DAG должны быть созданы:

- **База `raw_data`**: таблица `quality_audits` с 30 записями
- **База `dbt_transformed`**: 
  - `stg_quality_audits` - 30 записей с дополнительными полями
  - `dim_departments` - 8 записей (по количеству отделов)
  - `fact_audit_performance` - 30 записей с метриками

### 5. Примеры аналитических запросов

```sql
-- Топ-3 отдела по уровню соответствия
SELECT 
    department,
    avg_compliance_score,
    total_audits
FROM dim_departments
ORDER BY avg_compliance_score DESC
LIMIT 3;

-- Аудиты с критическими проблемами
SELECT 
    audit_id,
    department,
    process_name,
    compliance_score,
    critical_issues,
    risk_level
FROM fact_audit_performance
WHERE critical_issues > 0
ORDER BY critical_issues DESC;
```

## Остановка

```bash
# Остановка всех сервисов
docker compose down

# Остановка с удалением данных
docker compose down -v
```

## Устранение неполадок

```bash
# Перезапуск сервисов
docker compose restart

# Просмотр логов
docker compose logs airflow-webserver
docker compose logs postgres

# Полная переустановка
docker compose down -v
docker compose up -d
```

## Преимущества локального решения

1. **Без затрат** - не требует активации биллинга
2. **Полный контроль** - все сервисы под вашим управлением
3. **Быстрая разработка** - мгновенный доступ к логам и отладке
4. **Обучение** - возможность изучить все компоненты детально
5. **Офлайн работа** - не требует интернет-соединения

## Ограничения локального решения

1. **Масштабируемость** - ограничена ресурсами локальной машины
2. **Производительность** - может быть медленнее облачных решений
3. **Настройка** - требует больше ручной настройки
4. **Мониторинг** - менее продвинутые инструменты мониторинга

## Заключение


Локальное решение с Docker Compose предоставляет полнофункциональную альтернативу облачному решению для изучения и разработки систем анализа данных. Оно идеально подходит для образовательных целей и позволяет получить полное понимание работы всех компонентов системы.
