#!/usr/bin/env python3
"""
Script to load CSV data into external PostgreSQL
"""

import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
import os

def load_data_to_postgres():
    """Load CSV data into external PostgreSQL"""
    
    # Database connection parameters for external PostgreSQL
    conn_params = {
        'host': 'localhost',
        'port': 5432,
        'database': 'raw_data_04',
        'user': 'dbt_user',
        'password': 'dbt_password'
    }
    
    # Connect to database
    conn = psycopg2.connect(**conn_params)
    cursor = conn.cursor()
    
    # Read CSV file
    csv_file = '../quality_management_raw_data.csv'
    
    if os.path.exists(csv_file):
        df = pd.read_csv(csv_file)
        
        # Prepare data for insertion
        data_tuples = [tuple(row) for row in df.values]
        
        # Insert data
        insert_query = """
        INSERT INTO quality_audits (
            audit_id, audit_date, auditor_name, department, audit_type,
            process_name, compliance_score, non_conformities_count,
            critical_issues, minor_issues, recommendations_count,
            audit_status, next_audit_date, audit_duration_hours,
            certification_level
        ) VALUES %s
        ON CONFLICT (audit_id) DO NOTHING
        """
        
        execute_values(cursor, insert_query, data_tuples)
        conn.commit()
        
        print(f"Loaded {len(df)} rows into quality_audits table")
    else:
        print(f"CSV file {csv_file} not found")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    load_data_to_postgres()
