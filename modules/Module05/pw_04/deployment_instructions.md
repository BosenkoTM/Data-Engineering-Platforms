# Инструкции по развертыванию проекта

## Предварительные требования

1. Установленный Google Cloud SDK
2. Активный проект в GCP с включенным биллингом
3. Права администратора проекта
4. Python 3.8+ (для локальной разработки)

## Пошаговое развертывание

### 1. Подготовка окружения

```bash
# Установите Google Cloud SDK (если не установлен)
# https://cloud.google.com/sdk/docs/install

# Аутентификация в GCP
gcloud auth login
gcloud auth application-default login

# Установите переменные окружения
export PROJECT_ID="your-project-id"
export REGION="us-central1"
export COMPOSER_ENV="quality-management-composer"
```

### 2. Настройка проекта GCP

```bash
# Установите проект по умолчанию
gcloud config set project $PROJECT_ID

# Активируйте необходимые API
gcloud services enable composer.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
```

### 3. Создание сервисного аккаунта

```bash
# Создайте сервисный аккаунт
gcloud iam service-accounts create dbt-service-account \
    --display-name="DBT Service Account" \
    --description="Service account for dbt operations in quality management project"

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

### 4. Настройка BigQuery

```bash
# Создайте наборы данных
bq mk --location=US --dataset $PROJECT_ID:raw_data
bq mk --location=US --dataset $PROJECT_ID:dbt_transformed

# Загрузите тестовые данные
python upload_to_bigquery.py
```

### 5. Создание Cloud Composer

```bash
# Создайте среду Cloud Composer
gcloud composer environments create $COMPOSER_ENV \
    --location=$REGION \
    --python-version=3 \
    --image-version=composer-2.4.0-airflow-2.6.3 \
    --node-count=3 \
    --disk-size=100GB \
    --machine-type=n1-standard-1 \
    --pypi-packages-from-file=requirements.txt \
    --service-account=dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com
```

### 6. Получение информации о среде Composer

```bash
# Получите информацию о бакете GCS
COMPOSER_BUCKET=$(gcloud composer environments describe $COMPOSER_ENV \
    --location=$REGION \
    --format="value(config.dagGcsPrefix)" | sed 's|/dags||')

echo "Composer bucket: $COMPOSER_BUCKET"

# Получите URL Airflow UI
AIRFLOW_URI=$(gcloud composer environments describe $COMPOSER_ENV \
    --location=$REGION \
    --format="value(config.airflowUri)")

echo "Airflow UI: $AIRFLOW_URI"
```

### 7. Обновление конфигурационных файлов

```bash
# Обновите profiles.yml
sed -i "s/your-gcp-project-id/$PROJECT_ID/g" profiles.yml

# Обновите upload_to_bigquery.py
sed -i "s/your-gcp-project-id/$PROJECT_ID/g" upload_to_bigquery.py

# Обновите DAG файл
sed -i "s/your-project-id/$PROJECT_ID/g" dbt_quality_management_dag.py
```

### 8. Загрузка файлов в Cloud Composer

```bash
# Загрузите dbt-проект
gsutil -m cp -r models/ $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
gsutil cp dbt_project.yml $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
gsutil cp profiles.yml $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
gsutil cp packages.yml $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/

# Загрузите DAG
gsutil cp dbt_quality_management_dag.py $COMPOSER_BUCKET/dags/

# Загрузите ключ сервисного аккаунта
gsutil cp service-account-key.json $COMPOSER_BUCKET/dags/dbt/
```

### 9. Проверка развертывания

```bash
# Проверьте статус среды Composer
gcloud composer environments describe $COMPOSER_ENV --location=$REGION

# Проверьте загруженные файлы
gsutil ls -r $COMPOSER_BUCKET/dags/

# Проверьте данные в BigQuery
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`$PROJECT_ID.raw_data.quality_audits\`"
```

### 10. Запуск DAG

1. Откройте Airflow UI: `$AIRFLOW_URI`
2. Найдите DAG `quality_management_dbt_pipeline`
3. Включите DAG (переключите переключатель)
4. Запустите DAG вручную (кнопка "Trigger DAG")

## Проверка результатов

### В BigQuery

```sql
-- Проверьте staging модель
SELECT * FROM `your-project-id.dbt_transformed.stg_quality_audits` LIMIT 5;

-- Проверьте dimension таблицу
SELECT * FROM `your-project-id.dbt_transformed.dim_departments`;

-- Проверьте fact таблицу
SELECT * FROM `your-project-id.dbt_transformed.fact_audit_performance` LIMIT 5;
```

### В Airflow

1. Проверьте статус задач в графе DAG
2. Просмотрите логи выполнения задач
3. Убедитесь, что все задачи завершились успешно

## Устранение неполадок

### Проблемы с правами доступа

```bash
# Проверьте права сервисного аккаунта
gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --format="table(bindings.role)" \
    --filter="bindings.members:dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com"
```

### Проблемы с загрузкой файлов

```bash
# Проверьте права на бакет
gsutil iam get $COMPOSER_BUCKET

# Перезагрузите файлы при необходимости
gsutil -m cp -r . $COMPOSER_BUCKET/dags/dbt/quality_management_dbt/
```

### Проблемы с dbt

```bash
# Проверьте подключение к BigQuery
gcloud auth application-default print-access-token

# Проверьте данные в исходной таблице
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`$PROJECT_ID.raw_data.quality_audits\`"
```

## Очистка ресурсов

```bash
# Удалите среду Composer
gcloud composer environments delete $COMPOSER_ENV --location=$REGION

# Удалите наборы данных BigQuery
bq rm -r -f $PROJECT_ID:raw_data
bq rm -r -f $PROJECT_ID:dbt_transformed

# Удалите сервисный аккаунт
gcloud iam service-accounts delete dbt-service-account@$PROJECT_ID.iam.gserviceaccount.com

# Удалите ключ сервисного аккаунта
rm service-account-key.json
```

## Мониторинг и поддержка

### Настройка алертов

```bash
# Создайте политику алертов для Cloud Composer
gcloud alpha monitoring policies create \
    --policy-from-file=monitoring-policy.yaml
```

### Резервное копирование

```bash
# Создайте резервную копию данных
bq extract --destination_format=CSV \
    $PROJECT_ID:raw_data.quality_audits \
    gs://your-backup-bucket/quality_audits_backup.csv
```

## Дополнительные настройки

### Оптимизация производительности

1. Настройте партиционирование таблиц в dbt моделях
2. Используйте кластеризацию для больших таблиц
3. Оптимизируйте SQL-запросы

### Безопасность

1. Используйте VPC для изоляции ресурсов
2. Настройте шифрование данных
3. Регулярно ротируйте ключи сервисных аккаунтов

### Масштабирование

1. Увеличьте количество узлов в Cloud Composer при необходимости
2. Настройте автоматическое масштабирование
3. Используйте предварительно вычисленные агрегаты для больших объемов данных
