from google.oauth2 import service_account
from typing import Any


class GCPBase:
    """Base class from GCP modules"""

    _credential = {}
    _client = None
    _reference_client = None

    def __init__(self, client: Any, keyfile: dict):
        self._keyfile = keyfile
        self._reference_client = client
        self._load_credential()
        self._load_client()

    def _load_credential(self):
        credential = service_account.Credentials.from_service_account_info(
            self._keyfile
        )
        self._credential = {"credentials": credential, "project": credential.project_id}

    def _load_client(self):
        credential = self._credential
        self._client = self._reference_client(**credential)

    def reload(self):
        self._load_credential()
        self._load_client()

    @property
    def project_id(self):
        return self._client.project
