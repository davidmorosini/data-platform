import pandas as pd
from google.cloud import bigquery
from google.cloud.bigquery.job.load import LoadJob

from shared.gcp.base import GCPBase
from shared.gcp.utils import get_bq_data_type, value_is_a_scalar_value


class BigQuery(GCPBase):
    def __init__(self, keyfile: dict = {}, *args, **kwargs):
        super().__init__(bigquery.Client, keyfile, *args, **kwargs)

    def get_table_id(self, dataset: str, table: str) -> str:
        return f"{self.project_id}.{dataset}.{table}"

    def set_scalar_and_array_params(self, parameters: dict) -> tuple:
        values_items = parameters.items()
        scalar_values = [
            (key, value)
            for key, value in values_items
            if value_is_a_scalar_value(value)
        ]
        array_values = [
            (key, value)
            for key, value in values_items
            if not value_is_a_scalar_value(value)
        ]
        return (scalar_values, array_values)

    def make_bq_scalar_parameters(self, parameters: list) -> list:
        scalar_params = [
            bigquery.ScalarQueryParameter(key, get_bq_data_type(value), value)
            for key, value in parameters
        ]
        return scalar_params

    def make_bq_array_parameters(self, parameters: list) -> list:
        array_params = [
            # TODO: Improve this method
            bigquery.ArrayQueryParameter(key, get_bq_data_type(value[0]), value)
            for key, value in parameters
        ]
        return array_params

    def make_bq_parameters(self, parameters: dict) -> list:
        scalar_params, array_params = self.set_scalar_and_array_params(parameters)
        list_scalar_formated_params = self.make_bq_scalar_parameters(scalar_params)
        list_array_formated_params = self.make_bq_array_parameters(array_params)
        list_scalar_formated_params.extend(list_array_formated_params)
        return list_array_formated_params

    def batch_insert(self, df: pd.DataFrame, dataset: str, table: str) -> LoadJob:
        client = self._client
        table_id = self.get_table_id(dataset, table)
        return client.load_table_from_dataframe(df, table_id)

    def run_query(self, query: str, parameters: dict = {}) -> pd.DataFrame:
        bq_parameters = self.make_bq_parameters(parameters)
        job_config = bigquery.QueryJobConfig(query_parameters=bq_parameters)
        query_job = self._client.query(query, job_config=job_config)
        return query_job.to_dataframe()
