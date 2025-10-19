#!/usr/bin/env python3
"""
Script to upload CSV data to BigQuery
This script should be run locally before setting up the dbt pipeline
"""

import pandas as pd
from google.cloud import bigquery
from google.cloud import storage
import os
import json

def upload_csv_to_bigquery():
    """Upload CSV data to BigQuery raw_data dataset"""
    
    # Initialize BigQuery client
    client = bigquery.Client()
    
    # Project and dataset configuration
    project_id = "your-gcp-project-id"  # Replace with your project ID
    dataset_id = "raw_data"
    
    # Create dataset if it doesn't exist
    dataset_ref = client.dataset(dataset_id)
    try:
        dataset = client.get_dataset(dataset_ref)
        print(f"Dataset {dataset_id} already exists")
    except Exception:
        dataset = bigquery.Dataset(dataset_ref)
        dataset.location = "US"
        dataset = client.create_dataset(dataset)
        print(f"Created dataset {dataset_id}")
    
    # Table configuration
    table_id = "quality_audits"
    table_ref = dataset_ref.table(table_id)
    
    # Define table schema
    schema = [
        bigquery.SchemaField("audit_id", "STRING", mode="REQUIRED"),
        bigquery.SchemaField("audit_date", "DATE", mode="REQUIRED"),
        bigquery.SchemaField("auditor_name", "STRING", mode="REQUIRED"),
        bigquery.SchemaField("department", "STRING", mode="REQUIRED"),
        bigquery.SchemaField("audit_type", "STRING", mode="REQUIRED"),
        bigquery.SchemaField("process_name", "STRING", mode="REQUIRED"),
        bigquery.SchemaField("compliance_score", "INTEGER", mode="REQUIRED"),
        bigquery.SchemaField("non_conformities_count", "INTEGER", mode="REQUIRED"),
        bigquery.SchemaField("critical_issues", "INTEGER", mode="REQUIRED"),
        bigquery.SchemaField("minor_issues", "INTEGER", mode="REQUIRED"),
        bigquery.SchemaField("recommendations_count", "INTEGER", mode="REQUIRED"),
        bigquery.SchemaField("audit_status", "STRING", mode="REQUIRED"),
        bigquery.SchemaField("next_audit_date", "DATE", mode="REQUIRED"),
        bigquery.SchemaField("audit_duration_hours", "INTEGER", mode="REQUIRED"),
        bigquery.SchemaField("certification_level", "STRING", mode="REQUIRED"),
    ]
    
    # Create table
    table = bigquery.Table(table_ref, schema=schema)
    try:
        table = client.create_table(table)
        print(f"Created table {table_id}")
    except Exception:
        print(f"Table {table_id} already exists")
    
    # Load data from CSV
    csv_file = "quality_management_raw_data.csv"
    
    if os.path.exists(csv_file):
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.CSV,
            skip_leading_rows=1,
            autodetect=False,
            write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        )
        
        with open(csv_file, "rb") as source_file:
            job = client.load_table_from_file(
                source_file, table_ref, job_config=job_config
            )
        
        job.result()  # Wait for the job to complete
        
        print(f"Loaded {job.output_rows} rows into {table_id}")
    else:
        print(f"CSV file {csv_file} not found")

def create_transformed_dataset():
    """Create the transformed dataset for dbt output"""
    
    client = bigquery.Client()
    project_id = "your-gcp-project-id"  # Replace with your project ID
    dataset_id = "dbt_transformed"
    
    dataset_ref = client.dataset(dataset_id)
    try:
        dataset = client.get_dataset(dataset_ref)
        print(f"Dataset {dataset_id} already exists")
    except Exception:
        dataset = bigquery.Dataset(dataset_ref)
        dataset.location = "US"
        dataset = client.create_dataset(dataset)
        print(f"Created dataset {dataset_id}")

if __name__ == "__main__":
    print("Starting data upload to BigQuery...")
    upload_csv_to_bigquery()
    create_transformed_dataset()
    print("Data upload completed!")
