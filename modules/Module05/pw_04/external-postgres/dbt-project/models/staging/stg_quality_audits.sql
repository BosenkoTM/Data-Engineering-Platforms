-- models/staging/stg_quality_audits.sql
-- Staging model for quality management audits data

SELECT
    audit_id,
    audit_date,
    auditor_name,
    department,
    audit_type,
    process_name,
    compliance_score,
    non_conformities_count,
    critical_issues,
    minor_issues,
    recommendations_count,
    audit_status,
    next_audit_date,
    audit_duration_hours,
    certification_level,
    
    -- Add calculated fields
    CASE 
        WHEN compliance_score >= 90 THEN 'Excellent'
        WHEN compliance_score >= 80 THEN 'Good'
        WHEN compliance_score >= 70 THEN 'Satisfactory'
        ELSE 'Needs Improvement'
    END as compliance_level,
    
    CASE 
        WHEN critical_issues > 0 THEN 'Critical'
        WHEN non_conformities_count > 3 THEN 'High'
        WHEN non_conformities_count > 1 THEN 'Medium'
        ELSE 'Low'
    END as risk_level,
    
    -- Calculate days until next audit
    next_audit_date - audit_date as days_until_next_audit

FROM {{ source('raw_data', 'quality_audits') }}
