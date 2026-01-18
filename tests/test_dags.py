# tests/test_dags.py
# Lightweight tests to ensure DAGs import without syntax errors and basic structure.
import pytest
from airflow.models import DagBag

def test_import_dag():
    dag_bag = DagBag(dag_folder="airflow_dags", include_examples=False)
    assert dag_bag.import_errors == {}, f"DagBag import errors: {dag_bag.import_errors}"

def test_ecom_etl_dag_exists():
    dag_bag = DagBag(dag_folder="airflow_dags", include_examples=False)
    dag = dag_bag.get_dag("ecom_etl_hourly")
    assert dag is not None, "Could not find 'ecom_etl_hourly' DAG"
    assert len(dag.tasks) >= 1, "DAG has no tasks"
