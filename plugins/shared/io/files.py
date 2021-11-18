import json
from pathlib import Path
from typing import List
import yaml


def read_file_to_str(file_path: Path, mode: str = "r") -> str:
    with open(file_path, mode) as f:
        content = f.read()
    return content


def read_yaml_file_to_dict(yaml_file_path: Path, mode="r") -> dict:
    with open(yaml_file_path, mode) as f:
        yaml_file = yaml.safe_load(f)
    yaml_dumped = json.dumps(yaml_file, default=str)
    dict_loaded = json.loads(yaml_dumped)
    return dict_loaded
