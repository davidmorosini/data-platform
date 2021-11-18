from io import BytesIO
import pandas as pd


def df_to_parquet(
    df: pd.DataFrame,
    allow_truncated_timestamps: bool = True,
    filename: str = "file.parquet",
) -> BytesIO:
    """Transform a DataFrame in a parquet file in memory"""
    buffer = BytesIO()
    df.to_parquet(buffer, allow_truncated_timestamps=allow_truncated_timestamps)
    buffer.seek(0)
    buffer.filename = filename
    return buffer
