# Пример решения ПР 4.1. Написание простого DAG в Airflow для запуска dbt-проекта

## Постановка задачи

### Цель работы
Научиться создавать, настраивать и запускать простой Airflow DAG в среде Google Cloud Composer для выполнения команд проекта dbt (data build tool), который преобразует данные непосредственно в BigQuery.

### Задачи
1. **Настроить рабочее окружение** - подготовить необходимые сервисы в GCP, включая BigQuery, Cloud Composer и Cloud Storage
2. **Создать и настроить dbt-проект** - разработать базовый dbt-проект с моделями для трансформации данных в BigQuery
3. **Загрузить dbt-проект в Cloud Storage** - разместить файлы проекта в бакете, доступном для Cloud Composer
4. **Написать и развернуть Airflow DAG** - создать Python-скрипт DAG для выполнения команд dbt run и dbt test
5. **Запустить и отмониторить выполнение DAG** - убедиться в успешном выполнении dbt-задач

### Предметная область
Анализ системы менеджмента качества предприятия с автоматизированной обработкой данных аудитов, включая:
- Мониторинг соответствия стандартам качества
- Анализ эффективности аудитов по отделам
- Отслеживание несоответствий и рекомендаций
- Прогнозирование рисков и планирование аудитов

## Архитектура проекта

### Общая схема архитектуры
```
┌─────────────────┐     ┌─────────────────┐    ┌─────────────────┐
│   Источники     │     │   Cloud Storage │    │   BigQuery      │
│   данных        │───▶│   (Raw Data)    │───▶│   (Raw Dataset) │
│   (CSV файлы)   │     │                 │    │                 │
└─────────────────┘     └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Airflow UI    │◀───│  Cloud Composer │───▶│   BigQuery      │
│   (Мониторинг)  │    │   (Orchestration)│    │   (Transformed) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌───────────────────┐
                       │   dbt Models      │
                       │   (Transformation)│
                       └───────────────────┘
```

### Компоненты системы

#### 1. **Слой данных (Data Layer)**
- **Raw Data**. Исходные CSV-данные аудитов системы менеджмента качества
- **Staging Layer**. Очищенные и стандартизированные данные
- **Marts Layer**. Агрегированные данные для аналитики

#### 2. **Слой трансформации (Transformation Layer)**
- **dbt Core**. Инструмент для трансформации данных
- **dbt Models**. SQL-модели для преобразования данных
- **Data Quality Tests**. Проверки качества данных

#### 3. **Слой оркестрации (Orchestration Layer)**
- **Apache Airflow**. Планировщик задач
- **Cloud Composer**. Управляемая среда Airflow в GCP
- **DAG**. Направленный ациклический граф задач

#### 4. **Слой хранения (Storage Layer)**
- **BigQuery**. Колоночная аналитическая база данных
- **Cloud Storage**. Объектное хранилище для файлов

## Технологический стек

### Основные технологии
- **Google Cloud Platform (GCP)** - облачная платформа
- **Apache Airflow** - оркестрация данных и планировщик задач
- **dbt (data build tool)** - инструмент трансформации данных
- **BigQuery** - аналитическая база данных
- **Cloud Composer** - управляемая среда Airflow
- **Cloud Storage** - объектное хранилище

### Языки программирования и инструменты
- **Python 3.8+** - основной язык разработки
- **SQL** - язык запросов для трансформации данных
- **YAML** - конфигурационные файлы
- **Google Cloud SDK** - командная строка для работы с GCP
- **Bash** - скрипты автоматизации

### Библиотеки и пакеты
- **dbt-bigquery** - адаптер dbt для BigQuery
- **dbt-core** - ядро dbt
- **dbt-utils** - утилиты для dbt
- **google-cloud-bigquery** - клиент BigQuery для Python
- **pandas** - обработка данных
- **numpy** - численные вычисления

## Описание проекта

Данный проект реализует систему анализа данных системы менеджмента качества с использованием Google Cloud Platform, Apache Airflow и dbt (data build tool). Проект включает в себя:

- **Тестовые данные**. CSV-файл с данными аудитов системы менеджмента качества
- **dbt-проект**. Модели для трансформации и анализа данных
- **Airflow DAG**. Автоматизированный пайплайн для выполнения dbt-задач
- **Конфигурационные файлы**. Настройки для всех компонентов системы

## Структура проекта

```
pw_04/
├── quality_management_raw_data.csv    # Исходные тестовые данные
├── dbt_project.yml                    # Конфигурация dbt-проекта
├── profiles.yml                       # Настройки подключения к BigQuery
├── packages.yml                       # Зависимости dbt
├── requirements.txt                   # Python-зависимости для Cloud Composer
├── upload_to_bigquery.py             # Скрипт загрузки данных в BigQuery
├── dbt_quality_management_dag.py     # Airflow DAG
├── models/
│   ├── schema.yml                     # Схема данных и тесты
│   ├── staging/
│   │   └── stg_quality_audits.sql     # Staging модель
│   └── marts/
│       ├── dim_departments.sql        # Dimension таблица отделов
│       └── fact_audit_performance.sql # Fact таблица производительности аудитов
└── README.md                          # Данный файл
```

## Работа с Google Cloud Platform

### Первоначальная настройка GCP

#### 1. Регистрация и авторизация в GCP

**Шаг 1. Создание аккаунта Google Cloud**
1. Перейдите на сайт [Google Cloud Platform](https://cloud.google.com/)
2. Нажмите "Get started for free" или "Начать бесплатно"
3. Войдите в свой Google аккаунт или создайте новый
4. Заполните форму регистрации:
   - Страна/регион
   - Тип аккаунта (личный/корпоративный)
   - Согласие с условиями использования

**Шаг 2. Первый вход в консоль GCP**
1. Перейдите в [Google Cloud Console](https://console.cloud.google.com/)
2. Примите условия использования
3. Ознакомьтесь с интерфейсом консоли

#### 2. Создание проекта в GCP

**Способ 1. Через веб-консоль**
1. В консоли GCP нажмите на выпадающий список проектов в верхней части
2. Нажмите "New Project" или "Новый проект"
3. Заполните форму:
   - **Project name**: `quality-management-analysis` (или любое другое имя)
   - **Organization**: выберите организацию (если есть)
   - **Location**: выберите местоположение
4. Нажмите "Create"
5. Дождитесь создания проекта (обычно несколько секунд)

**Способ 2. Через командную строку**
```bash
# Установите Google Cloud SDK
# https://cloud.google.com/sdk/docs/install

# Аутентификация
gcloud auth login

# Создание проекта
gcloud projects create quality-management-analysis \
    --name="Quality Management Analysis" \
    --labels=environment=development,purpose=learning

# Установка проекта по умолчанию
gcloud config set project quality-management-analysis
```

#### 3. Настройка биллинга

**Активация биллинга:**
1. В консоли GCP перейдите в раздел "Billing" (Биллинг)
2. Нажмите "Link a billing account" (Связать аккаунт биллинга)
3. Создайте новый аккаунт биллинга:
   - Выберите страну/регион
   - Добавьте способ оплаты
   - Укажите адрес для выставления счетов
4. Подтвердите создание аккаунта

**Важно**. Даже при использовании бесплатных ресурсов активация биллинга обязательна.

> **Альтернативное решение**: Если у вас нет возможности активировать биллинг в GCP, вы можете использовать [локальное решение с Docker Compose](./local-development/README.md), которое полностью эмулирует облачную архитектуру на вашем компьютере без необходимости активации биллинга.

#### 4. Навигация по консоли GCP

**Основные разделы консоли:**
- **Cloud overview** - обзор ресурсов проекта
- **APIs & Services** - управление API
- **Billing** - управление биллингом
- **IAM & Admin** - управление доступом и пользователями
- **Compute Engine** - виртуальные машины
- **Cloud Storage** - объектное хранилище
- **BigQuery** - аналитическая база данных
- **Cloud Composer** - управляемая среда Airflow

**Поиск сервисов:**
- Используйте поиск в верхней части консоли
- Нажмите на иконку меню (☰) для доступа ко всем сервисам

### Настройка компонентов GCP

#### 1. Активация необходимых API

**Через веб-консоль:**
1. Перейдите в раздел "APIs & Services" → "Library"
2. Найдите и активируйте следующие API:
   - **Cloud Composer API**
   - **BigQuery API**
   - **Cloud Storage API**
   - **Compute Engine API**
   - **IAM Service Account Credentials API**

**Через командную строку:**
```bash
# Установите проект по умолчанию
export PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Активируйте необходимые API
gcloud services enable composer.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
```

#### 2. Создание сервисного аккаунта

**Через веб-консоль:**
1. Перейдите в "IAM & Admin" → "Service Accounts"
2. Нажмите "Create Service Account"
3. Заполните данные:
   - **Name**: `dbt-service-account`
   - **Description**: `Service account for dbt operations`
4. Нажмите "Create and Continue"
5. Назначьте роли:
   - `BigQuery Data Editor`
   - `BigQuery Job User`
   - `Storage Object Viewer`
6. Нажмите "Done"

**Через командную строку:**
```bash
# Создайте сервисный аккаунт
gcloud iam service-accounts create dbt-service-account \
    --display-name="DBT Service Account" \
    --description="Service account for dbt operations"

# Назначьте роли
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/bigquery.dataEditor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/bigquery.jobUser"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectViewer"

# Создайте ключ сервисного аккаунта
gcloud iam service-accounts keys create service-account-key.json \
    --iam-account=dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com
```

### Проверка компонентов в GCP

#### 1. Проверка активации API

**Через веб-консоль:**
1. Перейдите в "APIs & Services" → "Enabled APIs & services"
2. Убедитесь, что все необходимые API активированы:
   - Cloud Composer API ✅
   - BigQuery API ✅
   - Cloud Storage API ✅
   - Compute Engine API ✅

**Через командную строку:**
```bash
# Проверьте активированные API
gcloud services list --enabled --filter="name:(composer OR bigquery OR storage OR compute)"
```

#### 2. Проверка сервисного аккаунта

**Через веб-консоль:**
1. Перейдите в "IAM & Admin" → "Service Accounts"
2. Найдите созданный сервисный аккаунт `dbt-service-account`
3. Проверьте назначенные роли

**Через командную строку:**
```bash
# Проверьте сервисные аккаунты
gcloud iam service-accounts list

# Проверьте роли сервисного аккаунта
gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --format="table(bindings.role)" \
    --filter="bindings.members:dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com"
```

#### 3. Проверка биллинга

**Через веб-консоль:**
1. Перейдите в раздел "Billing"
2. Убедитесь, что аккаунт биллинга активен
3. Проверьте остаток кредитов

**Через командную строку:**
```bash
# Проверьте информацию о биллинге
gcloud billing accounts list
```

## Шаги выполнения практической работы

## Шаги выполнения практической работы

### Этап 1: Подготовка данных и инфраструктуры

#### Шаг 1: Настройка BigQuery

**1.1 Создание наборов данных**

**Через веб-консоль:**
1. Перейдите в раздел "BigQuery"
2. В левой панели нажмите на ваш проект
3. Нажмите "Create Dataset"
4. Создайте первый набор данных:
   - **Dataset ID**: `raw_data`
   - **Description**: `Raw data from quality management system`
   - **Location type**: `Multi-region`
   - **Data location**: `US (multiple regions in United States)`
5. Нажмите "Create dataset"
6. Повторите для второго набора данных:
   - **Dataset ID**: `dbt_transformed`
   - **Description**: `Transformed data from dbt models`

**Через командную строку:**
```bash
# Создание набора данных для исходных данных
bq mk --location=US --dataset $PROJECT_ID:raw_data

# Создание набора данных для трансформированных данных
bq mk --location=US --dataset $PROJECT_ID:dbt_transformed

# Проверка создания наборов данных
bq ls $PROJECT_ID
```

**1.2 Загрузка тестовых данных**

```bash
# Запустите скрипт загрузки данных
python upload_to_bigquery.py

# Проверьте загруженные данные
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`$PROJECT_ID.raw_data.quality_audits\`"
```

**Проверка результата:**
- В BigQuery должны появиться 2 набора данных: `raw_data` и `dbt_transformed`
- В наборе `raw_data` должна быть таблица `quality_audits` с 30 записями

#### Шаг 2: Создание Cloud Composer

**2.1 Создание среды Composer**

**Через веб-консоль:**
1. Перейдите в раздел "Cloud Composer"
2. Нажмите "Create Environment"
3. Заполните параметры:
   - **Name**: `quality-management-composer`
   - **Location**: `us-central1`
   - **Python version**: `3`
   - **Image version**: `composer-2.4.0-airflow-2.6.3`
   - **Node count**: `3`
   - **Disk size**: `100 GB`
   - **Machine type**: `n1-standard-1`
4. В разделе "PyPI packages" добавьте пакеты из `requirements.txt`
5. Нажмите "Create"

**Через командную строку:**
```bash
# Создание среды Cloud Composer
gcloud composer environments create quality-management-composer \
    --location=us-central1 \
    --python-version=3 \
    --image-version=composer-2.4.0-airflow-2.6.3 \
    --node-count=3 \
    --disk-size=100GB \
    --machine-type=n1-standard-1 \
    --pypi-packages-from-file=requirements.txt \
    --service-account=dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com
```

**2.2 Получение информации о среде**

```bash
# Получение информации о бакете GCS
COMPOSER_BUCKET=$(gcloud composer environments describe quality-management-composer \
    --location=us-central1 \
    --format="value(config.dagGcsPrefix)" | sed 's|/dags||')

echo "Composer bucket: $COMPOSER_BUCKET"

# Получение URL Airflow UI
AIRFLOW_URI=$(gcloud composer environments describe quality-management-composer \
    --location=us-central1 \
    --format="value(config.airflowUri)")

echo "Airflow UI: $AIRFLOW_URI"
```

**Проверка результата:**
- Среда Composer должна быть создана и активна
- Должен быть получен URL для доступа к Airflow UI
- Должен быть определен путь к GCS бакету

### Этап 2. Развертывание dbt-проекта

#### Шаг 3. Подготовка dbt-проекта

**3.1 Обновление конфигурационных файлов**

```bash
# Обновите ID проекта в конфигурационных файлах
sed -i "s/your-gcp-project-id/$PROJECT_ID/g" profiles.yml
sed -i "s/your-gcp-project-id/$PROJECT_ID/g" upload_to_bigquery.py
sed -i "s/your-project-id/$PROJECT_ID/g" dbt_quality_management_dag.py
```

**3.2 Загрузка файлов в Cloud Storage**

```bash
# Загрузка dbt-проекта
gsutil -m cp -r models/ $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
gsutil cp dbt_project.yml $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
gsutil cp profiles.yml $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
gsutil cp packages.yml $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/

# Загрузка DAG
gsutil cp dbt_quality_management_dag.py $COMPOSER_BUCKET/dags/

# Загрузка ключа сервисного аккаунта
gsutil cp service-account-key.json $COMPOSER_BUCKET/dags/dbt/

# Проверка загруженных файлов
gsutil ls -r $COMPOSER_BUCKET/dags/
```

**Проверка результата:**
- Все файлы должны быть загружены в соответствующие папки GCS
- Структура папок должна соответствовать требованиям Airflow

### Этап 3. Запуск и мониторинг

#### Шаг 4. Запуск DAG

**4.1 Доступ к Airflow UI**

1. Откройте браузер и перейдите по URL Airflow UI
2. Войдите в систему (используйте ваш Google аккаунт)
3. Найдите DAG `quality_management_dbt_pipeline` в списке

**4.2 Активация и запуск DAG**

1. Включите DAG, переключив переключатель в колонке "On"
2. Нажмите на название DAG для просмотра деталей
3. Нажмите кнопку "Trigger DAG" для ручного запуска
4. Выберите "Trigger DAG" в выпадающем меню

**4.3 Мониторинг выполнения**

1. **Просмотр графа DAG:**
   - Перейдите на вкладку "Graph"
   - Наблюдайте за выполнением задач (зеленый = успешно, красный = ошибка)

2. **Просмотр логов:**
   - Нажмите на задачу в графе
   - Выберите "Log" для просмотра детальных логов

3. **Проверка статуса задач:**
   - `start_pipeline` - начальная задача
   - `log_dbt_start` - логирование начала
   - `dbt_deps` - установка зависимостей
   - `dbt_seed` - загрузка seed-данных
   - `dbt_run` - выполнение моделей
   - `dbt_test` - запуск тестов
   - `data_quality_check` - проверка качества
   - `dbt_docs_generate` - генерация документации
   - `log_dbt_completion` - логирование завершения
   - `end_pipeline` - финальная задача

#### Шаг 5. Проверка результатов

**5.1 Проверка в BigQuery**

```sql
-- Проверка staging модели
SELECT * FROM `your-project-id.dbt_transformed.stg_quality_audits` LIMIT 5;

-- Проверка dimension таблицы
SELECT * FROM `your-project-id.dbt_transformed.dim_departments`;

-- Проверка fact таблицы
SELECT * FROM `your-project-id.dbt_transformed.fact_audit_performance` LIMIT 5;
```

**5.2 Проверка через командную строку**

```bash
# Проверка количества записей в staging модели
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`$PROJECT_ID.dbt_transformed.stg_quality_audits\`"

# Проверка количества отделов в dimension таблице
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`$PROJECT_ID.dbt_transformed.dim_departments\`"

# Проверка количества записей в fact таблице
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`$PROJECT_ID.dbt_transformed.fact_audit_performance\`"
```

**Ожидаемые результаты:**
- В `stg_quality_audits`: 30 записей с дополнительными вычисляемыми полями
- В `dim_departments`: 8 записей (по количеству уникальных отделов)
- В `fact_audit_performance`: 30 записей с детальными метриками

### Этап 4. Анализ и отчетность

#### Шаг 6. Выполнение аналитических запросов

Используйте готовые запросы из файла `analytical_queries.sql`:

```sql
-- Топ-3 отдела по уровню соответствия
SELECT 
    department,
    avg_compliance_score,
    total_audits,
    primary_certification
FROM `your-project-id.dbt_transformed.dim_departments`
ORDER BY avg_compliance_score DESC
LIMIT 3;
```

#### Шаг 7. Документирование результатов

1. **Создание отчета о выполнении:**
   - Зафиксируйте время выполнения каждой задачи
   - Отметьте успешные и неуспешные операции
   - Задокументируйте найденные проблемы и их решения

2. **Анализ производительности:**
   - Измерьте время выполнения DAG
   - Проанализируйте использование ресурсов
   - Определите узкие места в пайплайне

### Критерии успешного выполнения

✅ **Все задачи выполнены успешно, если:**
1. DAG запускается без ошибок
2. Все dbt-модели созданы в BigQuery
3. Тесты качества данных пройдены
4. Данные корректно трансформированы
5. Аналитические запросы возвращают ожидаемые результаты

❌ **Возможные проблемы и решения:**
1. **Ошибки подключения к BigQuery** → Проверьте права сервисного аккаунта
2. **Ошибки в dbt моделях** → Проверьте синтаксис SQL и схему данных
3. **Проблемы с зависимостями** → Убедитесь в корректной установке пакетов
4. **Ошибки загрузки файлов** → Проверьте права доступа к GCS

## Описание компонентов

### Тестовые данные (quality_management_raw_data.csv)

Файл содержит 30 записей аудитов системы менеджмента качества со следующими полями:
- `audit_id`: Уникальный идентификатор аудита
- `audit_date`: Дата проведения аудита
- `auditor_name`: Имя аудитора
- `department`: Отдел, который был проверен
- `audit_type`: Тип аудита (внутренний/внешний)
- `process_name`: Название процесса
- `compliance_score`: Оценка соответствия (0-100)
- `non_conformities_count`: Количество несоответствий
- `critical_issues`: Количество критических проблем
- `minor_issues`: Количество незначительных проблем
- `recommendations_count`. Количество рекомендаций
- `audit_status`. Статус аудита
- `next_audit_date`. Дата следующего аудита
- `audit_duration_hours`. Продолжительность аудита в часах
- `certification_level`. Уровень сертификации

### dbt-модели

#### 1. Staging модель (stg_quality_audits.sql)
- Преобразует исходные данные в правильные типы
- Добавляет вычисляемые поля:
  - `compliance_level`. Уровень соответствия (Excellent/Good/Satisfactory/Needs Improvement)
  - `risk_level`. Уровень риска (Critical/High/Medium/Low)
  - `days_until_next_audit`. Количество дней до следующего аудита

#### 2. Dimension таблица отделов (dim_departments.sql)
- Агрегирует метрики по отделам
- Включает:
  - Общее количество аудитов
  - Средние, минимальные и максимальные оценки соответствия
  - Общее количество несоответствий и проблем
  - Среднюю продолжительность аудитов
  - Основной уровень сертификации
  - Оценку рисков

#### 3. Fact таблица производительности аудитов (fact_audit_performance.sql)
- Содержит детальные метрики производительности
- Включает:
  - Рейтинг производительности (1-5)
  - Оценку эффективности аудита
  - Изменения в оценках соответствия
  - Временные измерения (год, месяц, квартал)

### Airflow DAG (dbt_quality_management_dag.py)

DAG включает следующие задачи:

1. **start_pipeline**. Начальная задача
2. **log_dbt_start**. Логирование начала выполнения
3. **dbt_deps**. Установка зависимостей dbt
4. **dbt_seed**. Загрузка seed-данных
5. **dbt_run**. Выполнение моделей dbt
6. **dbt_test**. Запуск тестов dbt
7. **data_quality_check**. Проверка качества данных
8. **dbt_docs_generate**. Генерация документации
9. **log_dbt_completion**. Логирование завершения
10. **end_pipeline**. Финальная задача

## Запуск и мониторинг

### 1. Запуск DAG

1. Откройте веб-интерфейс Airflow:
   ```bash
   gcloud composer environments describe quality-management-composer \
       --location=us-central1 \
       --format="value(config.airflowUri)"
   ```

2. Найдите DAG `quality_management_dbt_pipeline` в списке
3. Включите DAG, переключив переключатель
4. Запустите DAG вручную, нажав кнопку "Trigger DAG"

### 2. Мониторинг выполнения

1. **Просмотр логов задач:**
   - Нажмите на задачу в графе DAG
   - Выберите "Log" для просмотра логов выполнения

2. **Проверка результатов в BigQuery:**
   ```sql
   -- Проверка staging модели
   SELECT * FROM `your-project-id.dbt_transformed.stg_quality_audits` LIMIT 10;
   
   -- Проверка dimension таблицы
   SELECT * FROM `your-project-id.dbt_transformed.dim_departments`;
   
   -- Проверка fact таблицы
   SELECT * FROM `your-project-id.dbt_transformed.fact_audit_performance` LIMIT 10;
   ```

### 3. Анализ результатов

После успешного выполнения DAG вы можете выполнить следующие аналитические запросы:

```sql
-- Топ-3 отдела по среднему уровню соответствия
SELECT 
    department,
    avg_compliance_score,
    total_audits,
    primary_certification
FROM `your-project-id.dbt_transformed.dim_departments`
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
FROM `your-project-id.dbt_transformed.fact_audit_performance`
WHERE critical_issues > 0
ORDER BY critical_issues DESC;

-- Тренд соответствия по месяцам
SELECT 
    audit_year,
    audit_month,
    AVG(compliance_score) as avg_compliance,
    COUNT(*) as audit_count
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY audit_year, audit_month
ORDER BY audit_year, audit_month;
```

## Устранение неполадок

### Частые проблемы и решения

1. **Ошибка подключения к BigQuery:**
   - Проверьте правильность ID проекта в `profiles.yml`
   - Убедитесь, что ключ сервисного аккаунта загружен в GCS
   - Проверьте права доступа сервисного аккаунта

2. **Ошибки в dbt моделях:**
   - Проверьте синтаксис SQL в моделях
   - Убедитесь, что все источники данных существуют
   - Проверьте логи выполнения задач в Airflow

3. **Проблемы с зависимостями:**
   - Убедитесь, что все пакеты из `requirements.txt` установлены в Cloud Composer
   - Проверьте файл `packages.yml` для dbt-зависимостей

4. **Ошибки загрузки данных:**
   - Проверьте формат CSV-файла
   - Убедитесь, что схема таблицы соответствует данным
   - Проверьте права доступа к исходным данным

## Дополнительные возможности

### Расширение функциональности

1. **Добавление новых моделей:**
   - Создайте новые SQL-файлы в папке `models/`
   - Обновите `schema.yml` для новых моделей
   - Добавьте тесты для проверки качества данных

2. **Настройка уведомлений:**
   - Добавьте email-уведомления в DAG
   - Настройте Slack-интеграцию для мониторинга
   - Используйте Cloud Monitoring для алертов

3. **Оптимизация производительности:**
   - Настройте партиционирование таблиц
   - Используйте кластеризацию для больших таблиц
   - Оптимизируйте SQL-запросы в моделях

## Заключение

Данная практическая работа демонстрирует полный цикл создания системы анализа данных с использованием современных инструментов:

- **Google Cloud Platform** для инфраструктуры
- **Apache Airflow** для оркестрации процессов
- **dbt** для трансформации данных
- **BigQuery** для хранения и анализа данных

Система обеспечивает автоматизированную обработку данных аудитов системы менеджмента качества, предоставляя аналитикам готовые к использованию агрегированные данные и метрики для принятия решений.

## Полезные ссылки

- [Документация Cloud Composer](https://cloud.google.com/composer/docs)
- [Документация dbt](https://docs.getdbt.com/)
- [Документация BigQuery](https://cloud.google.com/bigquery/docs)
- [Документация Apache Airflow](https://airflow.apache.org/docs/)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs)

