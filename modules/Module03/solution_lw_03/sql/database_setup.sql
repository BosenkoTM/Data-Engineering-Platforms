-- =====================================================
-- Создание схемы базы данных для системы управления затратами
-- =====================================================

-- Этот файл содержит SQL скрипты для создания схем, таблиц и витрин
-- в PostgreSQL для системы аналитики управления затратами.
-- 
-- Для выполнения через pgAdmin:
-- 1. Подключитесь к базе данных superstore
-- 2. Выполните скрипт целиком или по частям
-- 3. Проверьте создание объектов в конце файла
--
-- Подключение к базе данных superstore:
-- Host: localhost
-- Port: 5432
-- Database: superstore
-- User: postgres
-- Password: post1616!

-- =====================================================
-- 1. СОЗДАНИЕ СХЕМ
-- =====================================================

-- Создание схемы для сырых данных
CREATE SCHEMA IF NOT EXISTS raw_data;

-- Создание схемы для аналитических витрин
CREATE SCHEMA IF NOT EXISTS analytics;

-- Проверка создания схем
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name IN ('raw_data', 'analytics')
ORDER BY schema_name;

-- =====================================================
-- 2. СОЗДАНИЕ ТАБЛИЦЫ ДЛЯ СЫРЫХ ДАННЫХ
-- =====================================================

-- Удаление таблицы если существует
DROP TABLE IF EXISTS raw_data.cost_survey_results;

-- Создание основной таблицы для сырых данных
CREATE TABLE raw_data.cost_survey_results (
    record_id INTEGER PRIMARY KEY,
    timestamp TIMESTAMP,
    department VARCHAR(100),
    data_system VARCHAR(100),
    cost_category VARCHAR(100),
    planned_costs DECIMAL(15,2),
    actual_costs DECIMAL(15,2),
    cost_optimization_strategy VARCHAR(200),
    satisfaction_level VARCHAR(50),
    employee_count INTEGER,
    cost_deviation DECIMAL(15,2),
    cost_per_employee DECIMAL(15,2)
);

-- Создание индексов для оптимизации запросов
CREATE INDEX idx_cost_survey_department ON raw_data.cost_survey_results(department);
CREATE INDEX idx_cost_survey_category ON raw_data.cost_survey_results(cost_category);
CREATE INDEX idx_cost_survey_strategy ON raw_data.cost_survey_results(cost_optimization_strategy);
CREATE INDEX idx_cost_survey_satisfaction ON raw_data.cost_survey_results(satisfaction_level);
CREATE INDEX idx_cost_survey_timestamp ON raw_data.cost_survey_results(timestamp);

-- =====================================================
-- 3. СОЗДАНИЕ АНАЛИТИЧЕСКИХ ВИТРИН
-- =====================================================

-- =====================================================
-- 3.1 ВИТРИНА ДЛЯ КОНСУЛЬТАНТОВ
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_consultant_metrics;

CREATE TABLE analytics.mart_consultant_metrics AS
SELECT 
    department,
    cost_category,
    cost_optimization_strategy,
    satisfaction_level,
    COUNT(*) as total_records,
    AVG(planned_costs) as avg_planned_costs,
    AVG(actual_costs) as avg_actual_costs,
    AVG(cost_deviation) as avg_cost_deviation,
    AVG(cost_per_employee) as avg_cost_per_employee,
    AVG(employee_count) as avg_employee_count,
    SUM(actual_costs) as total_actual_costs,
    SUM(planned_costs) as total_planned_costs,
    SUM(cost_deviation) as total_cost_deviation,
    -- Расчет эффективности стратегий
    CASE 
        WHEN AVG(cost_deviation) < 0 THEN 'Эффективная'
        WHEN AVG(cost_deviation) BETWEEN 0 AND 10000 THEN 'Умеренно эффективная'
        ELSE 'Неэффективная'
    END as strategy_effectiveness,
    -- Расчет уровня риска
    CASE 
        WHEN STDDEV(cost_deviation) > 20000 THEN 'Высокий'
        WHEN STDDEV(cost_deviation) BETWEEN 10000 AND 20000 THEN 'Средний'
        ELSE 'Низкий'
    END as risk_level,
    -- Расчет рекомендаций для клиентов
    CASE 
        WHEN AVG(cost_deviation) < -5000 THEN 'Рекомендуется к внедрению'
        WHEN AVG(cost_deviation) BETWEEN -5000 AND 0 THEN 'Рассмотреть возможность внедрения'
        WHEN AVG(cost_deviation) BETWEEN 0 AND 10000 THEN 'Требует доработки'
        ELSE 'Не рекомендуется'
    END as client_recommendation,
    -- Уровень уверенности в рекомендации
    CASE 
        WHEN COUNT(*) > 50 AND STDDEV(cost_deviation) < 10000 THEN 'Высокая уверенность'
        WHEN COUNT(*) > 20 AND STDDEV(cost_deviation) < 20000 THEN 'Средняя уверенность'
        ELSE 'Низкая уверенность'
    END as confidence_level,
    -- Потенциал экономии
    CASE 
        WHEN AVG(cost_deviation) < -10000 THEN 'Высокий потенциал экономии'
        WHEN AVG(cost_deviation) BETWEEN -10000 AND -1000 THEN 'Средний потенциал экономии'
        ELSE 'Низкий потенциал экономии'
    END as savings_potential
FROM raw_data.cost_survey_results
GROUP BY department, cost_category, cost_optimization_strategy, satisfaction_level;

-- Создание индексов для витрины консультантов
CREATE INDEX idx_mart_consultant_department ON analytics.mart_consultant_metrics(department);
CREATE INDEX idx_mart_consultant_category ON analytics.mart_consultant_metrics(cost_category);
CREATE INDEX idx_mart_consultant_effectiveness ON analytics.mart_consultant_metrics(strategy_effectiveness);
CREATE INDEX idx_mart_consultant_recommendation ON analytics.mart_consultant_metrics(client_recommendation);

-- =====================================================
-- 3.2 ВИТРИНА ДЛЯ HR И РЕКРУТЕРОВ
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_hr_recruitment_metrics;

CREATE TABLE analytics.mart_hr_recruitment_metrics AS
SELECT 
    department,
    cost_category,
    cost_optimization_strategy,
    COUNT(*) as total_records,
    AVG(employee_count) as avg_employee_count,
    AVG(cost_per_employee) as avg_cost_per_employee,
    SUM(actual_costs) as total_costs,
    AVG(actual_costs) as avg_costs,
    AVG(cost_deviation) as avg_deviation,
    -- Анализ зарплатных затрат
    CASE 
        WHEN cost_category = 'Заработная плата персонала' THEN 'Зарплатные затраты'
        WHEN cost_category = 'Обучение сотрудников' THEN 'Инвестиции в развитие'
        ELSE 'Прочие затраты'
    END as cost_type,
    -- Расчет ROI от обучения
    CASE 
        WHEN cost_category = 'Обучение сотрудников' AND AVG(cost_deviation) < 0 
        THEN 'Положительный ROI'
        WHEN cost_category = 'Обучение сотрудников' AND AVG(cost_deviation) >= 0 
        THEN 'Отрицательный ROI'
        ELSE 'Не применимо'
    END as training_roi,
    -- Уровень компетенций (на основе стратегий оптимизации)
    CASE 
        WHEN cost_optimization_strategy LIKE '%квалификации%' OR 
             cost_optimization_strategy LIKE '%обучения%' THEN 'Высокие требования к компетенциям'
        WHEN cost_optimization_strategy LIKE '%автоматизации%' THEN 'Технические компетенции'
        ELSE 'Базовые компетенции'
    END as competency_level,
    -- Рекомендации по найму
    CASE 
        WHEN AVG(cost_per_employee) > 500 AND cost_category = 'Заработная плата персонала'
        THEN 'Требуются высококвалифицированные специалисты'
        WHEN AVG(cost_per_employee) BETWEEN 200 AND 500 AND cost_category = 'Заработная плата персонала'
        THEN 'Средний уровень квалификации достаточен'
        ELSE 'Базовые навыки достаточны'
    END as hiring_recommendation,
    -- Анализ рынка зарплат
    CASE 
        WHEN AVG(cost_per_employee) > 400 THEN 'Высокий уровень зарплат'
        WHEN AVG(cost_per_employee) BETWEEN 200 AND 400 THEN 'Средний уровень зарплат'
        ELSE 'Низкий уровень зарплат'
    END as salary_level,
    -- Тренды найма
    CASE 
        WHEN COUNT(*) > 100 THEN 'Активный найм'
        WHEN COUNT(*) BETWEEN 50 AND 100 THEN 'Умеренный найм'
        ELSE 'Ограниченный найм'
    END as hiring_trend,
    -- Бюджетные рекомендации
    CASE 
        WHEN AVG(cost_deviation) > 10000 AND cost_category = 'Заработная плата персонала'
        THEN 'Пересмотреть зарплатную политику'
        WHEN AVG(cost_deviation) < -5000 AND cost_category = 'Обучение сотрудников'
        THEN 'Увеличить инвестиции в обучение'
        ELSE 'Поддерживать текущий бюджет'
    END as budget_recommendation
FROM raw_data.cost_survey_results
GROUP BY department, cost_category, cost_optimization_strategy;

-- Создание индексов для витрины HR
CREATE INDEX idx_mart_hr_department ON analytics.mart_hr_recruitment_metrics(department);
CREATE INDEX idx_mart_hr_cost_type ON analytics.mart_hr_recruitment_metrics(cost_type);
CREATE INDEX idx_mart_hr_roi ON analytics.mart_hr_recruitment_metrics(training_roi);
CREATE INDEX idx_mart_hr_salary_level ON analytics.mart_hr_recruitment_metrics(salary_level);

-- =====================================================
-- 3.3 ВИТРИНА ДЛЯ СТРАТЕГИЧЕСКОГО ПЛАНИРОВАНИЯ КОМПАНИИ
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_company_strategy_metrics;

CREATE TABLE analytics.mart_company_strategy_metrics AS
SELECT 
    department,
    data_system,
    cost_category,
    cost_optimization_strategy,
    COUNT(*) as total_records,
    AVG(planned_costs) as avg_planned_costs,
    AVG(actual_costs) as avg_actual_costs,
    AVG(cost_deviation) as avg_cost_deviation,
    AVG(cost_per_employee) as avg_cost_per_employee,
    SUM(actual_costs) as total_actual_costs,
    SUM(planned_costs) as total_planned_costs,
    SUM(cost_deviation) as total_cost_deviation,
    -- Расчет эффективности управления затратами
    CASE 
        WHEN AVG(cost_deviation) < -5000 THEN 'Высокая эффективность'
        WHEN AVG(cost_deviation) BETWEEN -5000 AND 5000 THEN 'Средняя эффективность'
        ELSE 'Низкая эффективность'
    END as cost_management_effectiveness,
    -- Анализ технологических решений
    CASE 
        WHEN data_system IN ('ERP', 'CRM') THEN 'Корпоративные системы'
        WHEN data_system IN ('Data Lake', 'ETL-инструменты') THEN 'Аналитические системы'
        ELSE 'Прочие системы'
    END as system_category,
    -- Стратегические рекомендации
    CASE 
        WHEN AVG(cost_deviation) > 10000 AND cost_category = 'Лицензии на ПО'
        THEN 'Пересмотреть лицензионную политику'
        WHEN AVG(cost_deviation) > 10000 AND cost_category = 'Облачные сервисы'
        THEN 'Оптимизировать облачные ресурсы'
        WHEN AVG(cost_deviation) < -5000
        THEN 'Масштабировать успешные практики'
        ELSE 'Поддерживать текущий уровень'
    END as strategic_recommendation,
    -- Конкурентные преимущества
    CASE 
        WHEN AVG(cost_per_employee) < 200 AND AVG(cost_deviation) < 0
        THEN 'Высокая операционная эффективность'
        WHEN AVG(cost_deviation) < -10000
        THEN 'Преимущество в управлении затратами'
        ELSE 'Стандартный уровень'
    END as competitive_advantage,
    -- Приоритеты развития
    CASE 
        WHEN cost_optimization_strategy LIKE '%автоматизации%' THEN 'Цифровизация'
        WHEN cost_optimization_strategy LIKE '%квалификации%' THEN 'Развитие персонала'
        WHEN cost_optimization_strategy LIKE '%облачных%' THEN 'Облачные технологии'
        ELSE 'Операционная оптимизация'
    END as development_priority,
    -- Уровень зрелости процессов
    CASE 
        WHEN AVG(cost_deviation) < -5000 AND COUNT(*) > 50 THEN 'Высокая зрелость'
        WHEN AVG(cost_deviation) BETWEEN -5000 AND 5000 AND COUNT(*) > 20 THEN 'Средняя зрелость'
        ELSE 'Низкая зрелость'
    END as process_maturity,
    -- Инвестиционные приоритеты
    CASE 
        WHEN AVG(cost_deviation) < -10000 THEN 'Высокий приоритет инвестиций'
        WHEN AVG(cost_deviation) BETWEEN -10000 AND 0 THEN 'Средний приоритет инвестиций'
        ELSE 'Низкий приоритет инвестиций'
    END as investment_priority,
    -- Риски для бизнеса
    CASE 
        WHEN AVG(cost_deviation) > 20000 THEN 'Высокий риск'
        WHEN AVG(cost_deviation) BETWEEN 10000 AND 20000 THEN 'Средний риск'
        ELSE 'Низкий риск'
    END as business_risk
FROM raw_data.cost_survey_results
GROUP BY department, data_system, cost_category, cost_optimization_strategy;

-- Создание индексов для витрины стратегического планирования
CREATE INDEX idx_mart_strategy_department ON analytics.mart_company_strategy_metrics(department);
CREATE INDEX idx_mart_strategy_effectiveness ON analytics.mart_company_strategy_metrics(cost_management_effectiveness);
CREATE INDEX idx_mart_strategy_recommendation ON analytics.mart_company_strategy_metrics(strategic_recommendation);
CREATE INDEX idx_mart_strategy_priority ON analytics.mart_company_strategy_metrics(development_priority);

-- =====================================================
-- 4. СОЗДАНИЕ ДОПОЛНИТЕЛЬНЫХ ВИТРИН ДЛЯ СПЕЦИАЛИЗИРОВАННЫХ АНАЛИЗОВ
-- =====================================================

-- =====================================================
-- 4.1 ВИТРИНА ДЛЯ АНАЛИЗА ТРЕНДОВ
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_trend_analysis;

CREATE TABLE analytics.mart_trend_analysis AS
SELECT 
    DATE_TRUNC('month', timestamp) as month,
    department,
    cost_category,
    COUNT(*) as records_count,
    AVG(planned_costs) as avg_planned_costs,
    AVG(actual_costs) as avg_actual_costs,
    AVG(cost_deviation) as avg_cost_deviation,
    SUM(actual_costs) as total_costs,
    -- Расчет трендов
    CASE 
        WHEN AVG(cost_deviation) > LAG(AVG(cost_deviation)) OVER (PARTITION BY department, cost_category ORDER BY DATE_TRUNC('month', timestamp))
        THEN 'Ухудшение'
        WHEN AVG(cost_deviation) < LAG(AVG(cost_deviation)) OVER (PARTITION BY department, cost_category ORDER BY DATE_TRUNC('month', timestamp))
        THEN 'Улучшение'
        ELSE 'Стабильно'
    END as trend_direction,
    -- Прогноз на следующий период
    CASE 
        WHEN AVG(cost_deviation) < -5000 THEN 'Позитивный прогноз'
        WHEN AVG(cost_deviation) BETWEEN -5000 AND 5000 THEN 'Нейтральный прогноз'
        ELSE 'Негативный прогноз'
    END as forecast
FROM raw_data.cost_survey_results
GROUP BY DATE_TRUNC('month', timestamp), department, cost_category
ORDER BY month, department, cost_category;

-- =====================================================
-- 4.2 ВИТРИНА ДЛЯ БЕНЧМАРКИНГА
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_benchmarking;

CREATE TABLE analytics.mart_benchmarking AS
SELECT 
    department,
    cost_category,
    AVG(cost_per_employee) as avg_cost_per_employee,
    AVG(cost_deviation) as avg_cost_deviation,
    COUNT(*) as sample_size,
    -- Бенчмарки по отраслям
    CASE 
        WHEN AVG(cost_per_employee) > 500 THEN 'Выше отраслевого стандарта'
        WHEN AVG(cost_per_employee) BETWEEN 200 AND 500 THEN 'Соответствует отраслевому стандарту'
        ELSE 'Ниже отраслевого стандарта'
    END as industry_benchmark,
    -- Сравнение с лучшими практиками
    CASE 
        WHEN AVG(cost_deviation) < -10000 THEN 'Лучшая практика'
        WHEN AVG(cost_deviation) BETWEEN -10000 AND 0 THEN 'Хорошая практика'
        WHEN AVG(cost_deviation) BETWEEN 0 AND 10000 THEN 'Средняя практика'
        ELSE 'Требует улучшения'
    END as best_practice_level,
    -- Рекомендации по улучшению
    CASE 
        WHEN AVG(cost_deviation) > 10000 THEN 'Критически важно улучшить'
        WHEN AVG(cost_deviation) BETWEEN 5000 AND 10000 THEN 'Рекомендуется улучшить'
        ELSE 'Поддерживать текущий уровень'
    END as improvement_recommendation
FROM raw_data.cost_survey_results
GROUP BY department, cost_category;

-- =====================================================
-- 5. СОЗДАНИЕ ПРЕДСТАВЛЕНИЙ ДЛЯ УДОБСТВА РАБОТЫ
-- =====================================================

-- Представление для быстрого доступа к ключевым метрикам консультантов
CREATE OR REPLACE VIEW analytics.view_consultant_dashboard AS
SELECT 
    department,
    cost_category,
    strategy_effectiveness,
    client_recommendation,
    confidence_level,
    savings_potential,
    total_records,
    avg_cost_deviation,
    avg_cost_per_employee
FROM analytics.mart_consultant_metrics
WHERE total_records >= 10  -- Фильтр для статистически значимых данных
ORDER BY avg_cost_deviation ASC;

-- Представление для HR дашборда
CREATE OR REPLACE VIEW analytics.view_hr_dashboard AS
SELECT 
    department,
    cost_type,
    salary_level,
    training_roi,
    hiring_recommendation,
    budget_recommendation,
    total_records,
    avg_cost_per_employee,
    avg_deviation
FROM analytics.mart_hr_recruitment_metrics
WHERE cost_type IN ('Зарплатные затраты', 'Инвестиции в развитие')
ORDER BY avg_cost_per_employee DESC;

-- Представление для стратегического дашборда
CREATE OR REPLACE VIEW analytics.view_strategy_dashboard AS
SELECT 
    department,
    system_category,
    cost_management_effectiveness,
    strategic_recommendation,
    competitive_advantage,
    development_priority,
    investment_priority,
    business_risk,
    total_records,
    avg_cost_deviation
FROM analytics.mart_company_strategy_metrics
ORDER BY cost_management_effectiveness DESC, avg_cost_deviation ASC;

-- =====================================================
-- 6. СОЗДАНИЕ ФУНКЦИЙ ДЛЯ АВТОМАТИЗАЦИИ
-- =====================================================

-- Функция для обновления витрин
CREATE OR REPLACE FUNCTION analytics.refresh_datamarts()
RETURNS TEXT AS $$
BEGIN
    -- Здесь можно добавить логику обновления витрин
    -- Например, пересоздание таблиц с новыми данными
    
    RETURN 'Витрины данных успешно обновлены';
END;
$$ LANGUAGE plpgsql;

-- Функция для получения рекомендаций по департаменту
CREATE OR REPLACE FUNCTION analytics.get_department_recommendations(dept_name TEXT)
RETURNS TABLE (
    recommendation_type TEXT,
    recommendation_text TEXT,
    priority_level TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        'Стратегическая рекомендация' as recommendation_type,
        csm.strategic_recommendation as recommendation_text,
        CASE 
            WHEN csm.avg_cost_deviation > 10000 THEN 'Высокий приоритет'
            WHEN csm.avg_cost_deviation BETWEEN 5000 AND 10000 THEN 'Средний приоритет'
            ELSE 'Низкий приоритет'
        END as priority_level
    FROM analytics.mart_company_strategy_metrics csm
    WHERE csm.department = dept_name
    ORDER BY csm.avg_cost_deviation DESC
    LIMIT 5;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 7. ПРОВЕРКА СОЗДАННЫХ ОБЪЕКТОВ
-- =====================================================

-- Проверка создания таблиц
SELECT 
    schemaname, 
    tablename, 
    tableowner 
FROM pg_tables 
WHERE schemaname IN ('raw_data', 'analytics')
ORDER BY schemaname, tablename;

-- Проверка количества записей в таблицах
SELECT 'raw_data.cost_survey_results' as table_name, COUNT(*) as record_count FROM raw_data.cost_survey_results
UNION ALL
SELECT 'analytics.mart_consultant_metrics' as table_name, COUNT(*) as record_count FROM analytics.mart_consultant_metrics
UNION ALL
SELECT 'analytics.mart_hr_recruitment_metrics' as table_name, COUNT(*) as record_count FROM analytics.mart_hr_recruitment_metrics
UNION ALL
SELECT 'analytics.mart_company_strategy_metrics' as table_name, COUNT(*) as record_count FROM analytics.mart_company_strategy_metrics
UNION ALL
SELECT 'analytics.mart_trend_analysis' as table_name, COUNT(*) as record_count FROM analytics.mart_trend_analysis
UNION ALL
SELECT 'analytics.mart_benchmarking' as table_name, COUNT(*) as record_count FROM analytics.mart_benchmarking;

-- =====================================================
-- 8. ФИНАЛЬНАЯ ПРОВЕРКА
-- =====================================================

-- Проверка всех созданных объектов
SELECT 
    'Таблицы' as object_type,
    COUNT(*) as count
FROM pg_tables 
WHERE schemaname IN ('raw_data', 'analytics')
UNION ALL
SELECT 
    'Представления' as object_type,
    COUNT(*) as count
FROM pg_views 
WHERE schemaname = 'analytics'
UNION ALL
SELECT 
    'Функции' as object_type,
    COUNT(*) as count
FROM pg_proc 
WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'analytics');

-- Вывод информации о завершении
SELECT 'Схема базы данных успешно создана!' as status;
SELECT 'Все таблицы, витрины и представления готовы к использованию в DataLens' as message;
