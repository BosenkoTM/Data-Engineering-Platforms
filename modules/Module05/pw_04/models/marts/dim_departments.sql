-- models/marts/dim_departments.sql
-- Department dimension table with aggregated metrics

SELECT
    department,
    COUNT(*) as total_audits,
    AVG(compliance_score) as avg_compliance_score,
    MIN(compliance_score) as min_compliance_score,
    MAX(compliance_score) as max_compliance_score,
    SUM(non_conformities_count) as total_non_conformities,
    SUM(critical_issues) as total_critical_issues,
    SUM(minor_issues) as total_minor_issues,
    SUM(recommendations_count) as total_recommendations,
    AVG(audit_duration_hours) as avg_audit_duration_hours,
    
    -- Calculate compliance trend (last 3 audits vs previous 3)
    AVG(CASE 
        WHEN audit_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) 
        THEN compliance_score 
    END) as recent_avg_compliance,
    
    -- Most common certification level
    APPROX_TOP_COUNT(certification_level, 1)[OFFSET(0)].value as primary_certification,
    
    -- Risk assessment
    COUNT(CASE WHEN risk_level = 'Critical' THEN 1 END) as critical_risk_count,
    COUNT(CASE WHEN risk_level = 'High' THEN 1 END) as high_risk_count,
    
    CURRENT_DATE() as last_updated

FROM {{ ref('stg_quality_audits') }}
GROUP BY department
