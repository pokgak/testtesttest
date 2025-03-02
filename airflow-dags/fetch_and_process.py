from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import json

# Define default_args
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 3, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define DAG
dag = DAG(
    'fetch_and_process_data',
    default_args=default_args,
    description='Fetch data from an API and process it',
    schedule_interval='@daily',
    catchup=False,
)

# Function to fetch data
def fetch_data(**kwargs):
    url = "https://jsonplaceholder.typicode.com/posts/1"  # Example API
    response = requests.get(url)
    data = response.json()
    
    # Push data to XCom
    kwargs['ti'].xcom_push(key='raw_data', value=data)

# Function to process data
def process_data(**kwargs):
    ti = kwargs['ti']
    raw_data = ti.xcom_pull(task_ids='fetch_data', key='raw_data')

    processed_data = {
        "title": raw_data["title"],
        "body_length": len(raw_data["body"])
    }

    with open('/tmp/processed_data.json', 'w') as f:
        json.dump(processed_data, f)

# Define tasks
fetch_task = PythonOperator(
    task_id='fetch_data',
    python_callable=fetch_data,
    provide_context=True,
    dag=dag,
)

process_task = PythonOperator(
    task_id='process_data',
    python_callable=process_data,
    provide_context=True,
    dag=dag,
)

# Define task dependencies
fetch_task >> process_task
