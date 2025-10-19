"""
Quality Management DBT DAG
=========================

This DAG runs dbt transformations for quality management audit data.
It includes data quality checks, transformations, and monitoring tasks.

Author: Data Engineering Team
Date: 2024
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.utils.dates import days_ago
import logging

# Default arguments for the DAG
default_args = {
    'owner': 'data-engineering-team',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'catchup': False,
}

# DAG configuration
dag = DAG(
    'quality_management_dbt_pipeline',
    default_args=default_args,
    description='Quality Management System DBT Pipeline',
    schedule_interval='@daily',  # Run daily
    max_active_runs=1,
    tags=['dbt', 'quality-management', 'data-transformation'],
)

# Path to dbt project in Cloud Storage
DBT_PROJECT_DIR = '/home/airflow/gcs/dags/dbt/quality_management_dbt'

def log_dbt_start(**context):
    """Log the start of dbt execution"""
    logging.info(f"Starting dbt execution for run_id: {context['run_id']}")
    logging.info(f"Execution date: {context['ds']}")

def log_dbt_completion(**context):
    """Log the completion of dbt execution"""
    logging.info(f"Completed dbt execution for run_id: {context['run_id']}")
    logging.info(f"Execution date: {context['ds']}")

# Task 1: Start notification
start_task = DummyOperator(
    task_id='start_pipeline',
    dag=dag,
)

# Task 2: Log start
log_start = PythonOperator(
    task_id='log_dbt_start',
    python_callable=log_dbt_start,
    dag=dag,
)

# Task 3: dbt deps - Install dependencies
dbt_deps = BashOperator(
    task_id='dbt_deps',
    bash_command=f"cd {DBT_PROJECT_DIR} && dbt deps",
    dag=dag,
)

# Task 4: dbt seed - Load seed data (if any)
dbt_seed = BashOperator(
    task_id='dbt_seed',
    bash_command=f"cd {DBT_PROJECT_DIR} && dbt seed",
    dag=dag,
)

# Task 5: dbt run - Execute models
dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --full-refresh",
    dag=dag,
)

# Task 6: dbt test - Run tests
dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command=f"cd {DBT_PROJECT_DIR} && dbt test",
    dag=dag,
)

# Task 7: dbt docs generate - Generate documentation
dbt_docs = BashOperator(
    task_id='dbt_docs_generate',
    bash_command=f"cd {DBT_PROJECT_DIR} && dbt docs generate",
    dag=dag,
)

# Task 8: Log completion
log_completion = PythonOperator(
    task_id='log_dbt_completion',
    python_callable=log_dbt_completion,
    dag=dag,
)

# Task 9: End notification
end_task = DummyOperator(
    task_id='end_pipeline',
    dag=dag,
)

# Task 10: Data quality check (custom)
def check_data_quality(**context):
    """Custom data quality check"""
    import subprocess
    import json
    
    try:
        # Run dbt test and capture results
        result = subprocess.run(
            f"cd {DBT_PROJECT_DIR} && dbt test --store-failures",
            shell=True,
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            logging.info("All data quality tests passed!")
            return "SUCCESS"
        else:
            logging.error(f"Data quality tests failed: {result.stderr}")
            return "FAILED"
            
    except Exception as e:
        logging.error(f"Error in data quality check: {str(e)}")
        return "ERROR"

data_quality_check = PythonOperator(
    task_id='data_quality_check',
    python_callable=check_data_quality,
    dag=dag,
)

# Define task dependencies
start_task >> log_start >> dbt_deps >> dbt_seed >> dbt_run >> dbt_test >> data_quality_check >> dbt_docs >> log_completion >> end_task

# Alternative: Parallel execution of tests and docs after dbt_run
# dbt_run >> [dbt_test, dbt_docs] >> data_quality_check >> log_completion >> end_task
