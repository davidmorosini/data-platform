from airflow.hooks.base import BaseHook
from copy import deepcopy
from datetime import datetime, timedelta
import json
import os
from pathlib import Path
import yaml


def get_current_environment(default: str = "dev") -> str:
    return os.getenv("AIRFLOW_ENV", default=default)


def get_current_gcp_project(default: str = "snmxgfihomh7g4qogpyop2qtu0dief") -> str:
    return os.getenv("AIRFLOW_DEFAULT_GCP_PROJECT", default=default)


def raise_if_not_valid_file(file_path: Path, valid_extensions: str = []) -> bool:
    is_valid_file = os.path.isfile(file_path)
    if not is_valid_file:
        raise FileNotFoundError(f"The file {file_path} isn't a valid file")

    lower_extensions = [e.lower() for e in valid_extensions]
    file_name = file_path.name.lower()
    matchs = [file_name.endswith(e) for e in lower_extensions]
    is_valid_file_with_extension = True in matchs

    if not is_valid_file_with_extension and valid_extensions:
        valid_extensions = ", ".join(valid_extensions)
        raise FileNotFoundError(
            f"The file {file_path} isn't a valid ({valid_extensions}) file"
        )

    return True


def get_dag_info(dag_file_path: Path) -> dict:
    parent_path = dag_file_path.parent
    project_path = parent_path.absolute()
    dag_id_raw_path = "/".join(parent_path.parts)
    dag_id_raw_path_splited = dag_id_raw_path.split("dags/")
    dag_id_path = dag_id_raw_path_splited[-1]
    dag_id = dag_id_path.replace("/", "-")
    dag_name = parent_path.name
    bucket_path = Path(f"airflow/dags/{dag_id_path}")
    return {
        "dag_path": project_path,
        "dag_id": dag_id,
        "dag_name": dag_name,
        "dag_bucket_path": bucket_path,
    }


def get_valid_subdirectories(path: Path, excluded_paths: list = []) -> list:
    if not os.path.isdir(path):
        raise NotADirectoryError(f"The path {path} isn't a valid directory path")

    all_items_in_directory_list = os.listdir(path)
    only_paths_list = [
        p for p in all_items_in_directory_list if os.path.isdir(path.joinpath(p))
    ]
    only_valid_directories = [
        path for path in only_paths_list if path not in excluded_paths
    ]
    return only_valid_directories


def yaml_file_to_dict(yaml_path: Path) -> dict:
    yaml_valid_extensions = ["yaml", "yml"]
    raise_if_not_valid_file(yaml_path, yaml_valid_extensions)

    with open(yaml_path) as f:
        yaml_file = yaml.safe_load(f)

    yaml_dumped = json.dumps(yaml_file, default=str)
    dict_loaded = json.loads(yaml_dumped)
    return dict_loaded


def get_dag_config_file_env_as_dict(file_path: Path) -> dict:
    dict_loaded = yaml_file_to_dict(file_path)
    current_env = get_current_environment()
    config_by_env = dict_loaded[current_env]
    gcp_project_id = get_current_gcp_project()
    config_by_env["environment"]["environment"] = current_env
    config_by_env["environment"]["gcp_project_id"] = gcp_project_id
    return config_by_env


def beautify_dag_configs(configs: dict) -> dict:
    configs_copy = deepcopy(configs)
    datetime_pattern = "%Y-%m-%d %H:%M:%S"
    start_date_raw = configs_copy["start_date"]
    start_date = datetime.strptime(start_date_raw, datetime_pattern)
    configs_copy["start_date"] = start_date

    end_date_raw = configs_copy.get("end_date")
    if end_date_raw:
        end_date = datetime.strptime(end_date_raw, datetime_pattern)
        configs_copy["end_date"] = end_date

    default_args = configs_copy.get("default_args", {})
    retry_delay = default_args.get("retry_delay", 1)
    retry_delay = timedelta(seconds=retry_delay)
    default_args["retry_delay"] = retry_delay
    configs_copy["default_args"] = default_args

    return configs_copy


def get_airflow_gcp_credentials(conn_id: str) -> tuple:
    connection = BaseHook.get_connection(conn_id)
    conn_extra = connection.extra_dejson
    key_access_keyfile = "extra__google_cloud_platform__keyfile_dict"
    keyfile_str = conn_extra[key_access_keyfile]
    keyfile_dict = json.loads(keyfile_str)
    project_id = keyfile_dict["project_id"]
    return (project_id, keyfile_dict)
