from datetime import date, datetime
import numpy as np
from typing import Any, Union


# TODO: Improve this mapping
BIGQUERY_TYPE_MAP = {
    int: "INT64",
    str: "STRING",
    float: "NUMERIC",
    bool: "BOOL",
    date: "DATE",
    datetime: "DATETIME",
}


def get_bq_data_type(data: Any, default: Union[None, str] = None) -> str:
    data_type = type(data)
    if default:
        bq_data_type = BIGQUERY_TYPE_MAP.get(data_type, BIGQUERY_TYPE_MAP[default])
    else:
        bq_data_type = BIGQUERY_TYPE_MAP[data_type]
    return bq_data_type


def value_is_a_scalar_value(value: Any):
    not_scalar_types = [tuple, list, np.array]
    return type(value) not in not_scalar_types
