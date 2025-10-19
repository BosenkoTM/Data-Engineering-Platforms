-- Создание баз данных для проекта
CREATE DATABASE raw_data;
CREATE DATABASE dbt_transformed;

-- Создание пользователя для dbt
CREATE USER dbt_user WITH PASSWORD 'dbt_password';
GRANT ALL PRIVILEGES ON DATABASE raw_data TO dbt_user;
GRANT ALL PRIVILEGES ON DATABASE dbt_transformed TO dbt_user;

-- Подключение к базе raw_data
\c raw_data;

-- Создание таблицы для исходных данных
CREATE TABLE quality_audits (
    audit_id VARCHAR(50) PRIMARY KEY,
    audit_date DATE NOT NULL,
    auditor_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    audit_type VARCHAR(50) NOT NULL,
    process_name VARCHAR(100) NOT NULL,
    compliance_score INTEGER NOT NULL CHECK (compliance_score >= 0 AND compliance_score <= 100),
    non_conformities_count INTEGER NOT NULL CHECK (non_conformities_count >= 0),
    critical_issues INTEGER NOT NULL CHECK (critical_issues >= 0),
    minor_issues INTEGER NOT NULL CHECK (minor_issues >= 0),
    recommendations_count INTEGER NOT NULL CHECK (recommendations_count >= 0),
    audit_status VARCHAR(50) NOT NULL,
    next_audit_date DATE NOT NULL,
    audit_duration_hours INTEGER NOT NULL CHECK (audit_duration_hours > 0),
    certification_level VARCHAR(50) NOT NULL
);

-- Предоставление прав пользователю dbt
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dbt_user;
