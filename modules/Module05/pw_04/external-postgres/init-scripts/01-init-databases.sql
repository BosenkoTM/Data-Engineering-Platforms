-- init-scripts/01-init-databases.sql
-- Initialize schemas for external PostgreSQL setup
-- Note: Database and user already exist, only creating schemas

-- Connect to superstore database and create schemas
\c superstore;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS raw_data_04;
CREATE SCHEMA IF NOT EXISTS marts_04;

-- Set search path to raw_data_04 schema
SET search_path TO raw_data_04;

-- Create quality_audits table
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
