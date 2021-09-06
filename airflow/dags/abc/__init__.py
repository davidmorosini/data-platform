from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python_operator import (
    PythonOperator,
)
import pendulum


local_tz = pendulum.timezone("America/Sao_Paulo")


args = {
    "owner": "Riscops",
    "depends_on_past": False,
    "start_date": datetime(2021, 3, 1, 0, 0, 0, tzinfo=local_tz),
    "provide_context": True,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

dag = DAG(
    "aa-teste_davizera", schedule_interval=None,
    default_args=args, catchup=False, max_active_runs=1,
)



def func_teste(**kwargs):

    print("DAVIZERAAAAAAAAAAAAaa")
    print(kwargs)

    print(type(kwargs["ds"]))
    print(kwargs["ds"])
    print(kwargs["next_ds"])
    print(type(kwargs["next_ds"]))


with dag:

    node_att_risk_big_query = PythonOperator(
        task_id=f"node_teste",
        python_callable=func_teste,
        provide_context=True,
        op_kwargs={},
    )
