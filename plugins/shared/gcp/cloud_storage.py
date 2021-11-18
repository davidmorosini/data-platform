from google.cloud import storage
from io import BytesIO

from shared.gcp.base import GCPBase


class CloudStorage(GCPBase):
    def __init__(self, keyfile: dict = {}) -> None:
        super().__init__(storage.Client, keyfile)
        self.bucket = None
        self.blob = None

    def set_bucket(self, bucket: str) -> None:
        """Set the current work bucket"""
        self.bucket = self._client.get_bucket(bucket)

    def set_path(self, path: str) -> None:
        """Set the current work path"""
        self.blob = self.bucket.blob(path)

    def exists(self):
        """Verify if blob exists in GCS"""
        return self.blob.exists()

    def delete_bytes(self):
        """Delete blob if there is exists"""
        if self.exists():
            self.blob.delete()

    def upload_bytes(self, obj: BytesIO, overwrite=False) -> str:
        """Upload bytes from any file in memory and returns the public url"""
        if overwrite:
            self.delete_bytes()

        blob = self.blob
        blob.upload_from_file(obj)
        return blob.public_url

    def fetch_bytes(self) -> BytesIO:
        """Fetch bytes from any file and returns a BytesIO structure"""
        blob = self.blob
        byte_buffer = blob.download_as_bytes()
        io_buffer = BytesIO(byte_buffer)
        return io_buffer

    def batch_upload(
        self, data_dict: dict, base_path: str, sulfix: str, overwrite: bool = False
    ) -> dict:
        uploaded_dict = {}
        for df_name, df in data_dict.items():
            path = f"{base_path}/{df_name}_{sulfix}"
            self.set_path(path)
            self.upload_bytes(df, overwrite)
            uploaded_dict[df_name] = path
        return uploaded_dict

    def batch_download(self, data: dict) -> dict:
        buffer_data = {}
        for name, path in data.items():
            self.set_path(path)
            buffer = self.fetch_bytes()
            buffer_data[name] = buffer

        return buffer_data
