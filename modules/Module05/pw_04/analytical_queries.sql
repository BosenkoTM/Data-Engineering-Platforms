-- Аналитические запросы для системы менеджмента качества
-- Используйте эти запросы для анализа данных после выполнения dbt-пайплайна

-- 1. Общая статистика по аудитам
SELECT 
    COUNT(*) as total_audits,
    AVG(compliance_score) as avg_compliance_score,
    MIN(compliance_score) as min_compliance_score,
    MAX(compliance_score) as max_compliance_score,
    SUM(non_conformities_count) as total_non_conformities,
    SUM(critical_issues) as total_critical_issues,
    SUM(minor_issues) as total_minor_issues
FROM `your-project-id.dbt_transformed.fact_audit_performance`;

-- 2. Топ-5 отделов по уровню соответствия
SELECT 
    department,
    avg_compliance_score,
    total_audits,
    total_critical_issues,
    primary_certification
FROM `your-project-id.dbt_transformed.dim_departments`
ORDER BY avg_compliance_score DESC
LIMIT 5;

-- 3. Анализ трендов по месяцам
SELECT 
    audit_year,
    audit_month,
    COUNT(*) as audit_count,
    AVG(compliance_score) as avg_compliance,
    SUM(critical_issues) as total_critical_issues,
    SUM(non_conformities_count) as total_non_conformities
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY audit_year, audit_month
ORDER BY audit_year, audit_month;

-- 4. Аудиторы с наибольшим количеством проведенных аудитов
SELECT 
    auditor_name,
    COUNT(*) as audits_conducted,
    AVG(compliance_score) as avg_compliance_score,
    SUM(critical_issues) as total_critical_issues_found
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY auditor_name
ORDER BY audits_conducted DESC;

-- 5. Анализ эффективности аудитов по продолжительности
SELECT 
    audit_efficiency,
    COUNT(*) as audit_count,
    AVG(compliance_score) as avg_compliance_score,
    AVG(audit_duration_hours) as avg_duration_hours
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY audit_efficiency
ORDER BY avg_compliance_score DESC;

-- 6. Процессы с наибольшим количеством несоответствий
SELECT 
    process_name,
    department,
    COUNT(*) as audit_count,
    AVG(non_conformities_count) as avg_non_conformities,
    SUM(critical_issues) as total_critical_issues,
    AVG(compliance_score) as avg_compliance_score
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY process_name, department
HAVING COUNT(*) >= 2
ORDER BY avg_non_conformities DESC;

-- 7. Анализ по типам аудитов
SELECT 
    audit_type,
    COUNT(*) as audit_count,
    AVG(compliance_score) as avg_compliance_score,
    SUM(critical_issues) as total_critical_issues,
    AVG(audit_duration_hours) as avg_duration_hours
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY audit_type
ORDER BY avg_compliance_score DESC;

-- 8. Сертификационные уровни и их эффективность
SELECT 
    certification_level,
    COUNT(*) as audit_count,
    AVG(compliance_score) as avg_compliance_score,
    SUM(critical_issues) as total_critical_issues,
    AVG(non_conformities_count) as avg_non_conformities
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY certification_level
ORDER BY avg_compliance_score DESC;

-- 9. Анализ рисков по отделам
SELECT 
    department,
    COUNT(CASE WHEN risk_level = 'Critical' THEN 1 END) as critical_risk_count,
    COUNT(CASE WHEN risk_level = 'High' THEN 1 END) as high_risk_count,
    COUNT(CASE WHEN risk_level = 'Medium' THEN 1 END) as medium_risk_count,
    COUNT(CASE WHEN risk_level = 'Low' THEN 1 END) as low_risk_count,
    COUNT(*) as total_audits
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY department
ORDER BY critical_risk_count DESC, high_risk_count DESC;

-- 10. Прогноз следующих аудитов
SELECT 
    department,
    process_name,
    next_audit_date,
    days_until_next_audit,
    compliance_score,
    risk_level,
    CASE 
        WHEN days_until_next_audit <= 30 THEN 'Urgent'
        WHEN days_until_next_audit <= 60 THEN 'Soon'
        ELSE 'Scheduled'
    END as priority_level
FROM `your-project-id.dbt_transformed.fact_audit_performance`
WHERE next_audit_date >= CURRENT_DATE()
ORDER BY days_until_next_audit ASC;

-- 11. Сравнение внутренних и внешних аудитов
SELECT 
    audit_type,
    COUNT(*) as audit_count,
    AVG(compliance_score) as avg_compliance_score,
    STDDEV(compliance_score) as compliance_score_stddev,
    AVG(non_conformities_count) as avg_non_conformities,
    AVG(audit_duration_hours) as avg_duration_hours
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY audit_type;

-- 12. Анализ рекомендаций по отделам
SELECT 
    department,
    COUNT(*) as audit_count,
    AVG(recommendations_count) as avg_recommendations,
    SUM(recommendations_count) as total_recommendations,
    AVG(compliance_score) as avg_compliance_score
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY department
ORDER BY avg_recommendations DESC;

-- 13. Корреляция между продолжительностью аудита и качеством
SELECT 
    CASE 
        WHEN audit_duration_hours <= 6 THEN 'Short (≤6h)'
        WHEN audit_duration_hours <= 10 THEN 'Medium (7-10h)'
        ELSE 'Long (>10h)'
    END as duration_category,
    COUNT(*) as audit_count,
    AVG(compliance_score) as avg_compliance_score,
    AVG(non_conformities_count) as avg_non_conformities,
    AVG(recommendations_count) as avg_recommendations
FROM `your-project-id.dbt_transformed.fact_audit_performance`
GROUP BY duration_category
ORDER BY avg_compliance_score DESC;

-- 14. Месячный тренд улучшений/ухудшений
WITH monthly_changes AS (
    SELECT 
        audit_year,
        audit_month,
        AVG(compliance_score_change) as avg_compliance_change,
        COUNT(*) as audit_count
    FROM `your-project-id.dbt_transformed.fact_audit_performance`
    WHERE compliance_score_change IS NOT NULL
    GROUP BY audit_year, audit_month
)
SELECT 
    audit_year,
    audit_month,
    avg_compliance_change,
    audit_count,
    CASE 
        WHEN avg_compliance_change > 0 THEN 'Improvement'
        WHEN avg_compliance_change < 0 THEN 'Decline'
        ELSE 'Stable'
    END as trend_direction
FROM monthly_changes
ORDER BY audit_year, audit_month;

-- 15. Итоговый дашборд для руководства
SELECT 
    'Total Audits' as metric,
    CAST(COUNT(*) AS STRING) as value
FROM `your-project-id.dbt_transformed.fact_audit_performance`

UNION ALL

SELECT 
    'Average Compliance Score' as metric,
    CAST(ROUND(AVG(compliance_score), 2) AS STRING) as value
FROM `your-project-id.dbt_transformed.fact_audit_performance`

UNION ALL

SELECT 
    'Total Critical Issues' as metric,
    CAST(SUM(critical_issues) AS STRING) as value
FROM `your-project-id.dbt_transformed.fact_audit_performance`

UNION ALL

SELECT 
    'Departments Audited' as metric,
    CAST(COUNT(DISTINCT department) AS STRING) as value
FROM `your-project-id.dbt_transformed.fact_audit_performance`

UNION ALL

SELECT 
    'Average Audit Duration (hours)' as metric,
    CAST(ROUND(AVG(audit_duration_hours), 1) AS STRING) as value
FROM `your-project-id.dbt_transformed.fact_audit_performance`;
