"""
Конфигурационный файл для скрипта экспорта данных в DataLens
"""

import os
from pathlib import Path

# Настройки базы данных
DATABASE_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': int(os.getenv('DB_PORT', 5432)),
    'database': os.getenv('DB_NAME', 'superstore'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'post1616!'),
    'schema': os.getenv('DB_SCHEMA', 'public_dw_test')
}

# Настройки экспорта
EXPORT_CONFIG = {
    'output_dir': Path(__file__).parent.parent / 'data',
    'encoding': 'utf-8',
    'date_format': '%Y-%m-%d',
    'decimal_separator': '.',
    'thousands_separator': ','
}

# Настройки логирования
LOGGING_CONFIG = {
    'level': 'INFO',
    'format': '%(asctime)s - %(levelname)s - %(message)s',
    'log_file': 'export_log.txt'
}

# Настройки для DataLens
DATALENS_CONFIG = {
    'max_file_size_mb': 100,
    'max_rows': 1000000,
    'date_columns': [
        'sales_month',
        'first_order_date', 
        'last_order_date'
    ],
    'numeric_columns': [
        'total_sales',
        'total_profit',
        'profit_margin',
        'total_sales_lifetime',
        'average_order_value',
        'avg_order_value',
        'number_of_orders',
        'total_orders',
        'days_since_last_order',
        'total_quantity',
        'avg_discount',
        'sales_percentile'
    ],
    'text_columns': [
        'customer_id',
        'customer_name',
        'category',
        'segment',
        'city',
        'state',
        'product_name',
        'sub_category',
        'ship_mode',
        'profitability_category',
        'ltv_category',
        'order_frequency_category',
        'customer_status',
        'dormant_period_category',
        'recovery_priority',
        'discount_category'
    ]
}

# SQL запросы для экспорта
EXPORT_QUERIES = {
    'monthly_sales': """
        SELECT 
            sales_month,
            category,
            segment,
            total_sales,
            total_profit,
            profit_margin,
            number_of_orders,
            EXTRACT(YEAR FROM sales_month) as year,
            EXTRACT(MONTH FROM sales_month) as month,
            TO_CHAR(sales_month, 'Month YYYY') as sales_month_name,
            CASE 
                WHEN profit_margin > 0.2 THEN 'Высокая'
                WHEN profit_margin > 0.1 THEN 'Средняя'
                WHEN profit_margin > 0 THEN 'Низкая'
                ELSE 'Убыточная'
            END as profitability_category
        FROM {schema}.mart_monthly_sales
        ORDER BY sales_month, total_sales DESC;
    """,
    
    'customer_ltv': """
        SELECT 
            customer_id,
            customer_name,
            segment,
            first_order_date,
            last_order_date,
            number_of_orders,
            total_sales_lifetime,
            average_order_value,
            (last_order_date - first_order_date) as customer_age_days,
            EXTRACT(YEAR FROM first_order_date) as first_order_year,
            EXTRACT(YEAR FROM last_order_date) as last_order_year,
            CASE 
                WHEN total_sales_lifetime >= 10000 THEN 'VIP'
                WHEN total_sales_lifetime >= 5000 THEN 'Высокий'
                WHEN total_sales_lifetime >= 1000 THEN 'Средний'
                ELSE 'Низкий'
            END as ltv_category,
            CASE 
                WHEN number_of_orders >= 20 THEN 'Частый'
                WHEN number_of_orders >= 10 THEN 'Регулярный'
                WHEN number_of_orders >= 5 THEN 'Периодический'
                ELSE 'Редкий'
            END as order_frequency_category
        FROM {schema}.mart_customer_ltv
        ORDER BY total_sales_lifetime DESC;
    """,
    
    'dormant_customers': """
        SELECT 
            customer_id,
            customer_name,
            segment,
            city,
            state,
            total_orders,
            total_sales,
            total_profit,
            avg_order_value,
            first_order_date,
            last_order_date,
            days_since_last_order,
            total_quantity,
            avg_discount,
            sales_percentile,
            customer_status,
            CASE 
                WHEN days_since_last_order <= 365 THEN '6-12 месяцев'
                WHEN days_since_last_order <= 730 THEN '1-2 года'
                ELSE 'Более 2 лет'
            END as dormant_period_category,
            CASE 
                WHEN total_sales >= 15000 THEN 'Высокий'
                WHEN total_sales >= 5000 THEN 'Средний'
                ELSE 'Низкий'
            END as recovery_priority,
            ROUND((total_profit / NULLIF(total_sales, 0)) * 100, 2) as profit_margin_percent,
            CASE 
                WHEN avg_discount > 0.2 THEN 'Высокие скидки'
                WHEN avg_discount > 0.1 THEN 'Средние скидки'
                WHEN avg_discount > 0 THEN 'Низкие скидки'
                ELSE 'Без скидок'
            END as discount_category
        FROM {schema}.mart_valuable_dormant_customers
        ORDER BY total_sales DESC, days_since_last_order DESC;
    """
}

# Настройки для разных окружений
ENVIRONMENTS = {
    'development': {
        'database': 'superstore',
        'schema': 'public_dw_test',
        'log_level': 'DEBUG'
    },
    'production': {
        'database': 'superstore',
        'schema': 'public_dw_test',
        'log_level': 'INFO'
    },
    'testing': {
        'database': 'superstore',
        'schema': 'public_dw_test',
        'log_level': 'WARNING'
    }
}

# Получить текущее окружение
CURRENT_ENV = os.getenv('ENVIRONMENT', 'development')

# Применить настройки окружения
if CURRENT_ENV in ENVIRONMENTS:
    env_config = ENVIRONMENTS[CURRENT_ENV]
    DATABASE_CONFIG['database'] = env_config['database']
    DATABASE_CONFIG['schema'] = env_config['schema']
    LOGGING_CONFIG['level'] = env_config['log_level']
