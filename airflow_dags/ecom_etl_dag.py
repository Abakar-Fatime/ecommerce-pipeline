"""
ecom_etl_dag.py
Example production-ready Airflow DAG for the e-commerce analytics pipeline.

Notes:
- Uses PythonOperator with placeholder callables; replace with your implementations
  (or wrap existing operators like MsSqlOperator, S3ToMsSqlOperator, etc.).
- Includes sensible defaults: retries, SLA, task groups, and simple alerting.
- Expects Airflow connections:
  - conn_id='mssql_dw'     -> SQL Server data warehouse
  - conn_id='s3_source'    -> (optional) S3/Cloud storage for ingests
  - conn_id='alert_email'  -> SMTP/Email (if using EmailOperator)
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.task_group import TaskGroup
from airflow.utils.email import send_email  # optional simple alerting

DEFAULT_ARGS = {
    "owner": "data-eng",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
    "sla": timedelta(hours=2),
}

def _notify_failure(context):
    title = f"DAG {context['task_instance'].dag_id} Failed"
    body = f"""
    Task: {context['task_instance'].task_id}
    Dag: {context['task_instance'].dag_id}
    Execution: {context['execution_date']}
    Log: {context['task_instance'].log_url}
    """
    try:
        send_email(to=["oncall@example.com"], subject=title, html_content=body)
    except Exception:
        print("Failed to send failure email alert")

def extract_from_sources(**kwargs):
    print("Extract: fetch source files / API calls")
    return "extracted"

def load_to_staging(**kwargs):
    print("Stage: load to staging schema")
    return "staged"

def apply_transformations(**kwargs):
    print("Transform: run SQL transformations")
    return "transformed"

def load_dimensions_and_facts(**kwargs):
    print("Load: merge to DW (dimensions + facts)")
    return "loaded"

with DAG(
    dag_id="ecom_etl_hourly",
    description="E-commerce ETL: extract -> stage -> transform -> load DW",
    start_date=datetime(2025, 1, 1),
    schedule_interval="@hourly",
    default_args=DEFAULT_ARGS,
    catchup=False,
    max_active_runs=1,
    on_failure_callback=_notify_failure,
    tags=["ecommerce", "etl", "dw"],
) as dag:

    with TaskGroup("extract_stage", tooltip="Extract from sources and stage") as extract_stage:
        extract = PythonOperator(
            task_id="extract_from_sources",
            python_callable=extract_from_sources,
            provide_context=True,
        )

        stage = PythonOperator(
            task_id="load_to_staging",
            python_callable=load_to_staging,
            provide_context=True,
        )

        extract >> stage

    with TaskGroup("transform_load", tooltip="Transform staging data and load to DW") as transform_load:
        transform = PythonOperator(
            task_id="apply_transformations",
            python_callable=apply_transformations,
            provide_context=True,
        )

        load_dw = PythonOperator(
            task_id="load_dimensions_and_facts",
            python_callable=load_dimensions_and_facts,
            provide_context=True,
        )

        transform >> load_dw

    extract_stage >> transform_load
