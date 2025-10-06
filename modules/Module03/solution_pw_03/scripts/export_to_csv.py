#!/usr/bin/env python3
"""
Скрипт для экспорта данных из хранилища данных (DWH) в CSV формат
для последующей загрузки в Yandex DataLens.

Автор: Data Engineering Team
Дата: 2025
"""

import os
import sys
import pandas as pd
import psycopg2
from datetime import datetime
import logging
from pathlib import Path
from psycopg2.extras import RealDictCursor

from config import DATABASE_CONFIG, EXPORT_QUERIES, LOGGING_CONFIG

# Настройка логирования
logging.basicConfig(
    level=getattr(logging, LOGGING_CONFIG.get('level', 'INFO')),
    format=LOGGING_CONFIG.get('format', '%(asctime)s - %(levelname)s - %(message)s'),
    handlers=[
        logging.FileHandler(LOGGING_CONFIG.get('log_file', 'export_log.txt')),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Конфигурация подключения из единого файла настроек
DB_CONFIG = DATABASE_CONFIG

# Путь к папке для сохранения CSV файлов
OUTPUT_DIR = Path(__file__).parent.parent / 'data'
OUTPUT_DIR.mkdir(exist_ok=True)

# SQL запросы берём из конфигурации и подставляем актуальную схему
SCHEMA = DB_CONFIG.get('schema', 'public_dw_test')
QUERIES = {name: sql.format(schema=SCHEMA) for name, sql in EXPORT_QUERIES.items()}

def connect_to_database():
    """Создает подключение к базе данных PostgreSQL."""
    try:
        connection = psycopg2.connect(**DB_CONFIG)
        logger.info("Успешное подключение к базе данных")
        return connection
    except psycopg2.Error as e:
        logger.error(f"Ошибка подключения к базе данных: {e}")
        raise

def healthcheck(connection):
    """Мини-проверка доступности БД и наличия схемы и витрин (быстро)."""
    try:
        with connection.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT 1 AS ok")
            _ = cur.fetchone()
            # Быстрая проверка существования схемы
            cur.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name = %s", (SCHEMA,))
            schema_exists = cur.fetchone() is not None
            if not schema_exists:
                logger.warning(f"Схема {SCHEMA} не найдена. Убедитесь, что выполнен импорт data/public_dw_test или скрипт data/from_stg_to_dw.sql")
            else:
                logger.info(f"Схема {SCHEMA} доступна")
    except Exception as e:
        logger.warning(f"Healthcheck предупреждение: {e}")

def export_table_to_csv(connection, query, filename):
    """Экспортирует данные из таблицы в CSV файл."""
    try:
        logger.info(f"Начинаю экспорт данных в {filename}")
        
        # Выполняем запрос и загружаем данные в DataFrame
        df = pd.read_sql_query(query, connection)
        
        # Обработка данных для DataLens
        df = prepare_data_for_datalens(df, filename)
        
        # Сохраняем в CSV
        filepath = OUTPUT_DIR / filename
        df.to_csv(filepath, index=False, encoding='utf-8')
        
        logger.info(f"Данные успешно экспортированы в {filepath}")
        logger.info(f"Количество записей: {len(df)}")
        
        return filepath
        
    except Exception as e:
        logger.error(f"Ошибка при экспорте {filename}: {e}")
        raise

def prepare_data_for_datalens(df, filename):
    """Подготавливает данные для оптимальной работы в DataLens."""
    
    # Удаляем дубликаты
    df = df.drop_duplicates()
    
    # Обработка дат
    date_columns = df.select_dtypes(include=['datetime64']).columns
    for col in date_columns:
        df[col] = pd.to_datetime(df[col]).dt.strftime('%Y-%m-%d')
    
    # Обработка числовых колонок
    numeric_columns = df.select_dtypes(include=['float64', 'int64']).columns
    for col in numeric_columns:
        # Заменяем NaN на 0 для числовых колонок
        df[col] = df[col].fillna(0)
        # Округляем до 2 знаков после запятой для денежных значений
        if 'sales' in col.lower() or 'profit' in col.lower() or 'value' in col.lower():
            df[col] = df[col].round(2)
    
    # Обработка текстовых колонок
    text_columns = df.select_dtypes(include=['object']).columns
    for col in text_columns:
        # Заменяем NaN на пустую строку
        df[col] = df[col].fillna('')
        # Убираем лишние пробелы
        df[col] = df[col].astype(str).str.strip()
    
    # Специфичная обработка для разных типов данных
    if 'monthly_sales' in filename:
        # Для месячных продаж добавляем дополнительные поля
        df['sales_month_name'] = pd.to_datetime(df['sales_month']).dt.strftime('%B %Y')
        df['year'] = pd.to_datetime(df['sales_month']).dt.year
        df['month'] = pd.to_datetime(df['sales_month']).dt.month
    
    elif 'customer_ltv' in filename:
        # Для LTV клиентов добавляем категоризацию
        df['ltv_category'] = pd.cut(
            df['total_sales_lifetime'], 
            bins=[0, 1000, 5000, 10000, float('inf')],
            labels=['Низкий', 'Средний', 'Высокий', 'VIP']
        )
        df['customer_age_days'] = (pd.to_datetime(df['last_order_date']) - 
                                 pd.to_datetime(df['first_order_date'])).dt.days
    
    elif 'dormant_customers' in filename:
        # Для спящих клиентов добавляем приоритизацию
        df['recovery_priority'] = pd.cut(
            df['total_sales'], 
            bins=[0, 5000, 15000, float('inf')],
            labels=['Низкий', 'Средний', 'Высокий']
        )
        df['dormant_category'] = pd.cut(
            df['days_since_last_order'], 
            bins=[180, 365, 730, float('inf')],
            labels=['6-12 мес', '1-2 года', '>2 лет']
        )
    
    return df

def validate_csv_files():
    """Проверяет созданные CSV файлы на корректность."""
    logger.info("Начинаю валидацию CSV файлов")
    
    for filename in ['monthly_sales.csv', 'customer_ltv.csv', 'dormant_customers.csv']:
        filepath = OUTPUT_DIR / filename
        if not filepath.exists():
            logger.error(f"Файл {filename} не найден")
            continue
            
        try:
            df = pd.read_csv(filepath)
            logger.info(f"Файл {filename}: {len(df)} записей, {len(df.columns)} колонок")
            
            # Проверяем на пустые значения
            null_counts = df.isnull().sum()
            if null_counts.sum() > 0:
                logger.warning(f"В файле {filename} найдены пустые значения:")
                for col, count in null_counts[null_counts > 0].items():
                    logger.warning(f"  {col}: {count} пустых значений")
            
        except Exception as e:
            logger.error(f"Ошибка при валидации {filename}: {e}")

def generate_summary_report():
    """Генерирует сводный отчет по экспортированным данным."""
    report_path = OUTPUT_DIR / 'export_summary.txt'
    
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write("СВОДНЫЙ ОТЧЕТ ПО ЭКСПОРТУ ДАННЫХ\n")
        f.write("=" * 50 + "\n")
        f.write(f"Дата экспорта: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        for filename in ['monthly_sales.csv', 'customer_ltv.csv', 'dormant_customers.csv']:
            filepath = OUTPUT_DIR / filename
            if filepath.exists():
                df = pd.read_csv(filepath)
                f.write(f"Файл: {filename}\n")
                f.write(f"  Записей: {len(df)}\n")
                f.write(f"  Колонок: {len(df.columns)}\n")
                f.write(f"  Размер файла: {filepath.stat().st_size / 1024:.1f} KB\n")
                f.write(f"  Колонки: {', '.join(df.columns)}\n\n")
    
    logger.info(f"Сводный отчет сохранен в {report_path}")

def main():
    """Основная функция скрипта."""
    logger.info("Запуск скрипта экспорта данных для DataLens")
    
    try:
        # Подключаемся к базе данных
        connection = connect_to_database()
        # Мини healthcheck (без длительных тестов)
        healthcheck(connection)
        
        # Экспортируем каждую витрину данных
        exported_files = []
        for table_name, query in QUERIES.items():
            filename = f"{table_name}.csv"
            filepath = export_table_to_csv(connection, query, filename)
            exported_files.append(filepath)
        
        # Закрываем подключение
        connection.close()
        logger.info("Подключение к базе данных закрыто")
        
        # Валидируем созданные файлы
        validate_csv_files()
        
        # Генерируем сводный отчет
        generate_summary_report()
        
        logger.info("Экспорт данных завершен успешно!")
        logger.info(f"Создано файлов: {len(exported_files)}")
        logger.info(f"Файлы сохранены в: {OUTPUT_DIR}")
        
    except Exception as e:
        logger.error(f"Критическая ошибка: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
