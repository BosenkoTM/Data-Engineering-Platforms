-- models/marts/fact_audit_performance.sql
-- Fact table with audit performance metrics

SELECT
    audit_id,
    audit_date,
    auditor_name,
    department,
    audit_type,
    process_name,
    compliance_score,
    compliance_level,
    risk_level,
    non_conformities_count,
    critical_issues,
    minor_issues,
    recommendations_count,
    audit_status,
    next_audit_date,
    days_until_next_audit,
    audit_duration_hours,
    certification_level,
    
    -- Performance indicators
    CASE 
        WHEN compliance_score >= 95 THEN 5
        WHEN compliance_score >= 90 THEN 4
        WHEN compliance_score >= 80 THEN 3
        WHEN compliance_score >= 70 THEN 2
        ELSE 1
    END as performance_rating,
    
    -- Efficiency metrics
    CASE 
        WHEN audit_duration_hours <= 6 THEN 'Efficient'
        WHEN audit_duration_hours <= 10 THEN 'Normal'
        ELSE 'Lengthy'
    END as audit_efficiency,
    
    -- Compliance trend calculation
    LAG(compliance_score) OVER (
        PARTITION BY department, process_name 
        ORDER BY audit_date
    ) as previous_compliance_score,
    
    compliance_score - LAG(compliance_score) OVER (
        PARTITION BY department, process_name 
        ORDER BY audit_date
    ) as compliance_score_change,
    
    -- Year and month for time-based analysis
    EXTRACT(YEAR FROM audit_date) as audit_year,
    EXTRACT(MONTH FROM audit_date) as audit_month,
    EXTRACT(QUARTER FROM audit_date) as audit_quarter

FROM {{ ref('stg_quality_audits') }}
