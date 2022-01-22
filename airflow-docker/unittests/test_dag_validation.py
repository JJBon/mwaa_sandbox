import pytest
from airflow.models import DagBag

class TestDagValidation:

    LOAD_SECOND_THRESHOLD = 2
    REQUIRED_EMAIL = "support@airflow.com"
    EXPECTED_NUMBER_OF_DAGS = 3

    def test_import_dags(self, dagbag):
        """
            Verify that Airflow is able to import all DAGs
            in the repo
            - check for typos
            - check for cycles
        """
        assert len(dagbag.import_errors) == 0, "DAG failures detected! Got: {}".format(
            dagbag.import_errors
        )





 
