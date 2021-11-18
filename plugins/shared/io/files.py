from pathlib import Path


def read_file(filename: Path) -> str:
    """Read files function"""
    with open(filename, "r") as f:
        content = f.read()
    return content
