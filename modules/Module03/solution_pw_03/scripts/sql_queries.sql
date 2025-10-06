-- SQL запросы для извлечения данных из витрин DWH
-- для последующего экспорта в CSV и загрузки в DataLens

-- =====================================================
-- 1. ЗАПРОС ДЛЯ ВИТРИНЫ МЕСЯЧНЫХ ПРОДАЖ
-- =====================================================

SELECT 
    sales_month,
    category,
    segment,
    total_sales,
    total_profit,
    profit_margin,
    number_of_orders,
    -- Дополнительные вычисляемые поля для DataLens
    EXTRACT(YEAR FROM sales_month) as year,
    EXTRACT(MONTH FROM sales_month) as month,
    TO_CHAR(sales_month, 'Month YYYY') as sales_month_name,
    CASE 
        WHEN profit_margin > 0.2 THEN 'Высокая'
        WHEN profit_margin > 0.1 THEN 'Средняя'
        WHEN profit_margin > 0 THEN 'Низкая'
        ELSE 'Убыточная'
    END as profitability_category
FROM public_dw_test.mart_monthly_sales
ORDER BY sales_month, total_sales DESC;

-- =====================================================
-- 2. ЗАПРОС ДЛЯ ВИТРИНЫ LTV КЛИЕНТОВ
-- =====================================================

SELECT 
    customer_id,
    customer_name,
    segment,
    first_order_date,
    last_order_date,
    number_of_orders,
    total_sales_lifetime,
    average_order_value,
    -- Дополнительные вычисляемые поля
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
FROM public_dw_test.mart_customer_ltv
ORDER BY total_sales_lifetime DESC;

-- =====================================================
-- 3. ЗАПРОС ДЛЯ ВИТРИНЫ СПЯЩИХ ЦЕННЫХ КЛИЕНТОВ
-- =====================================================

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
    -- Дополнительные вычисляемые поля
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
FROM public_dw_test.mart_valuable_dormant_customers
ORDER BY total_sales DESC, days_since_last_order DESC;

-- =====================================================
-- 4. ДОПОЛНИТЕЛЬНЫЕ АГРЕГИРОВАННЫЕ ЗАПРОСЫ
-- =====================================================

-- 4.1. Сводка по продажам по регионам
SELECT 
    state,
    city,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(total_sales) as total_sales,
    SUM(total_profit) as total_profit,
    AVG(total_sales) as avg_customer_sales,
    ROUND((SUM(total_profit) / NULLIF(SUM(total_sales), 0)) * 100, 2) as profit_margin_percent
FROM public_dw_test.mart_customer_ltv cl
JOIN (
    SELECT DISTINCT customer_id, city, state 
    FROM public_dw_test.mart_valuable_dormant_customers
) geo ON cl.customer_id = geo.customer_id
GROUP BY state, city
ORDER BY total_sales DESC;

-- 4.2. Анализ сезонности продаж
SELECT 
    EXTRACT(MONTH FROM sales_month) as month_number,
    TO_CHAR(sales_month, 'Month') as month_name,
    COUNT(*) as months_count,
    AVG(total_sales) as avg_monthly_sales,
    AVG(total_profit) as avg_monthly_profit,
    AVG(profit_margin) as avg_profit_margin,
    SUM(total_sales) as total_sales_by_month,
    SUM(number_of_orders) as total_orders_by_month
FROM public_dw_test.mart_monthly_sales
GROUP BY EXTRACT(MONTH FROM sales_month), TO_CHAR(sales_month, 'Month')
ORDER BY month_number;

-- 4.3. Топ категорий и сегментов
SELECT 
    category,
    segment,
    COUNT(DISTINCT sales_month) as active_months,
    SUM(total_sales) as total_sales,
    SUM(total_profit) as total_profit,
    AVG(profit_margin) as avg_profit_margin,
    SUM(number_of_orders) as total_orders,
    RANK() OVER (ORDER BY SUM(total_sales) DESC) as sales_rank,
    RANK() OVER (ORDER BY SUM(total_profit) DESC) as profit_rank
FROM public_dw_test.mart_monthly_sales
GROUP BY category, segment
ORDER BY total_sales DESC;

-- =====================================================
-- 5. ЗАПРОСЫ ДЛЯ ПРЯМОГО ПОДКЛЮЧЕНИЯ К DATALENS
-- =====================================================

-- 5.1. Универсальный запрос для дашборда продаж
WITH monthly_metrics AS (
    SELECT 
        sales_month,
        category,
        segment,
        total_sales,
        total_profit,
        profit_margin,
        number_of_orders,
        -- Расчеты для трендов
        LAG(total_sales) OVER (PARTITION BY category, segment ORDER BY sales_month) as prev_month_sales,
        LAG(total_profit) OVER (PARTITION BY category, segment ORDER BY sales_month) as prev_month_profit
    FROM public_dw_test.mart_monthly_sales
)
SELECT 
    *,
    -- Расчет роста/падения
    CASE 
        WHEN prev_month_sales IS NOT NULL THEN 
            ROUND(((total_sales - prev_month_sales) / prev_month_sales) * 100, 2)
        ELSE NULL 
    END as sales_growth_percent,
    CASE 
        WHEN prev_month_profit IS NOT NULL THEN 
            ROUND(((total_profit - prev_month_profit) / prev_month_profit) * 100, 2)
        ELSE NULL 
    END as profit_growth_percent
FROM monthly_metrics
ORDER BY sales_month, total_sales DESC;

-- 5.2. Запрос для анализа клиентской базы
SELECT 
    cl.customer_id,
    cl.customer_name,
    cl.segment,
    cl.total_sales_lifetime,
    cl.average_order_value,
    cl.number_of_orders,
    cl.first_order_date,
    cl.last_order_date,
    -- Информация о спящих клиентах
    CASE WHEN dc.customer_id IS NOT NULL THEN 'Спящий' ELSE 'Активный' END as customer_status,
    dc.days_since_last_order,
    dc.sales_percentile,
    -- Географическая информация
    dc.city,
    dc.state
FROM public_dw_test.mart_customer_ltv cl
LEFT JOIN public_dw_test.mart_valuable_dormant_customers dc ON cl.customer_id = dc.customer_id
ORDER BY cl.total_sales_lifetime DESC;
